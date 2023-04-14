import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';

// This widget displays the calendar for the parent.
// The parents will have access to all of their children's upcoming events.
// Personal events will not be included.
class CalendarParent extends StatefulWidget {
  const CalendarParent({Key? key, required this.user}) : super(key: key);

  final GoogleSignInAccount user;

  @override
  State<CalendarParent> createState() => _CalendarParentState();
}

class _CalendarParentState extends State<CalendarParent> {
  // Gets all events when this page loads.
  @override
  void initState() {
    super.initState();
    getEventsDocuments();
  }

  // events will store all of the children's events as an Event object.
  late List<Event> events = [];

  // appointments will store all of the events as an Appointment object.
  // Both lists are needed to fit the data structure of the calendar and to identify duplicates.
  late List<Appointment> appointments = [];

  // Checks if all the documents have loaded before displaying them to the user.
  bool hasLoaded = false;

  // This function uses FirebaseFirestore to add all events to the appointments
  // events list.
  Future<void> getEventsDocuments() async {
    // First, the parent's children will be found.
    await FirebaseFirestore.instance
        .collection('parents')
        .doc(widget.user.displayName?.replaceAll(' ', '_').toLowerCase())
        .collection('students')
        .get()
        .then((value) => {
              value.docs.forEach((element) async {
                String studentCollectionRef = 'students';
                String studentDocRef = element.data()['student'].split("/")[1];

                // The children's events will then be accessed and added to the lists.
                var childCollection = await FirebaseFirestore.instance
                    .collection(studentCollectionRef)
                    .doc(studentDocRef);

                await childCollection
                    .collection('activities')
                    .get()
                    .then((value) => {
                          value.docs.forEach((element) async {
                            String activityCollectionRef = 'activities';
                            String activityDocRef =
                                element.data()['clubRef'].split("/")[1];

                            var activityCollection = await FirebaseFirestore
                                .instance
                                .collection(activityCollectionRef)
                                .doc(activityDocRef);

                            var docSnapshot = await activityCollection.get();
                            late String subject;
                            late Color color;
                            if (docSnapshot.exists) {
                              Map<String, dynamic>? data = docSnapshot.data();
                              color = findColor(data!['type']);
                              subject = data['name'];
                            }
                            await activityCollection
                                .collection('events')
                                .get()
                                .then((value) => {
                                      value.docs.forEach((element) async {
                                        String notes = element.data()['notes'];
                                        DateTime startTime = element
                                            .data()['startTime']
                                            .toDate();
                                        DateTime endTime =
                                            element.data()['endTime'].toDate();

                                        Appointment appointment = Appointment(
                                            subject: subject,
                                            notes: notes,
                                            color: color,
                                            startTime: startTime,
                                            endTime: endTime);

                                        // Creates an event that fits the data structure required by the calendar
                                        Event thisEvent = Event(
                                          child: DisplayDate(
                                            appointment: appointment,
                                          ),
                                          dateTime: CalendarDateTime(
                                              year: startTime.year,
                                              month: startTime.month,
                                              day: startTime.day,
                                              calendarType:
                                                  CalendarType.GREGORIAN),
                                        );

                                        // Checks if events have been duplicated (e.g. if 2 children
                                        // participate in the same activity). These events aren't included.
                                        // Adds events only if they occur later than today's date.
                                        setState(() {
                                          if (endTime.compareTo(
                                                      DateTime.now()) >
                                                  0 &&
                                              !isDuplicated(appointment)) {
                                            appointments.add(appointment);
                                            events.add(thisEvent);
                                          }
                                        });
                                      })
                                    });
                          })
                        });
              })
            });

    // Gets all events related to NCHS. Since each student is a part of NCHS,
    // these events are independent of the child.
    await FirebaseFirestore.instance
        .collection('activities')
        .doc('nchs')
        .collection('events')
        .get()
        .then((value) => {
              value.docs.forEach((element) async {
                setState(() {
                  if (element
                          .data()['endTime']
                          .toDate()
                          .compareTo(DateTime.now()) >
                      0) {
                    Appointment appointment = Appointment(
                        subject: 'NCHS',
                        notes: element.data()['notes'],
                        color: findColor('school'),
                        startTime: element.data()['endTime'].toDate(),
                        endTime: element.data()['startTime'].toDate());

                    appointments.add(appointment);

                    events.add(Event(
                      child: DisplayDate(
                        appointment: appointment,
                      ),
                      dateTime: CalendarDateTime(
                          year: element.data()['startTime'].toDate().year,
                          month: element.data()['startTime'].toDate().month,
                          day: element.data()['startTime'].toDate().day,
                          calendarType: CalendarType.GREGORIAN),
                    ));
                  }
                });
              })
            });

    // After all of the documents have been successfully loaded, the events will be displayed.
    setState(() {
      hasLoaded = true;
    });
  }

  // This function checks whether this appointment is already present in the list.
  // If so, the function returns true.
  bool isDuplicated(Appointment thisAppointment) {
    for (var appointment in appointments) {
      if (thisAppointment.subject == appointment.subject &&
          thisAppointment.notes == appointment.notes &&
          thisAppointment.startTime == appointment.startTime &&
          thisAppointment.endTime == appointment.endTime) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
          // If all of the events have not been loaded, a loading circle will be displayed.
          if (hasLoaded == false) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );

            // Calendar and events will be displayed if all events have been loaded.
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Uses the Flutter Event Calendar package to create a calendar.
                  EventCalendar(
                    calendarType: CalendarType.GREGORIAN,
                    calendarLanguage: 'en',
                    calendarOptions: CalendarOptions(
                      toggleViewType: true,
                      viewType: ViewType.DAILY,
                    ),
                    headerOptions: HeaderOptions(
                      monthStringType: MonthStringTypes.FULL,
                    ),
                    dayOptions: DayOptions(
                      weekDaySelectedColor: Color(0xff4C2C72),
                      eventCounterColor: Color(0xff4C2C72),
                      selectedBackgroundColor: Color(0xff78CAD2),
                    ),
                    showLoadingForEvent: true,
                    showEvents: true,
                    eventOptions: EventOptions(
                      emptyIconColor: Colors.green,
                      emptyTextColor: Colors.black,
                      emptyText: 'No Events',
                      emptyIcon: Icons.check,
                    ),
                    events: events,
                  ),
                ],
              ),
            );
          }
        })));
  }

  // This function color codes the various events into clubs, sports, and NCHS events.
  Color findColor(String type) {
    if (type == "club") {
      return Color.fromARGB(255, 251, 207, 74);
    } else if (type == "sports") {
      return Color(0xffD56AA0);
    } else {
      return Color(0xff4C2C72);
    }
  }
}

// This widget will display each individual event.
// Each event will have a date (or range of dates), name of the event,
// details of the event, and start/end time of the event.
class DateDataSource extends CalendarDataSource {
  DateDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class DisplayDate extends StatelessWidget {
  final Appointment appointment;
  const DisplayDate({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 14,
          child: Container(
            margin: EdgeInsets.all(10),
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: appointment.color,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('MMM')
                      .format(DateTime(0, appointment.startTime.month)),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),

                // Date is displayed differently depending on whether it spans one day or multiple days
                LayoutBuilder(builder: (context, constraints) {
                  if (appointment.startTime.day == appointment.endTime.day) {
                    return Text(
                      '${appointment.startTime.day}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    );
                  } else {
                    return Column(
                      children: [
                        Text(
                          '${appointment.startTime.day} - ${appointment.endTime.day}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0),
                        ),
                      ],
                    );
                  }
                })
              ],
            ),
          ),
        ),
        Expanded(
          flex: 45,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffF4F4F4),
              ),
              margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.subject,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(appointment.notes,
                        style: TextStyle(
                          fontSize: 17.0,
                        )),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_outlined,
                          color: Color(0xff78CAD2),
                          size: 17.0,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          DateFormat('h:mm a').format(appointment.startTime) +
                              ' - ' +
                              DateFormat('h:mm a').format(appointment.endTime),
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff78CAD2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
