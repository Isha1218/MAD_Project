import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad/calendar/request_event.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';

// This widget displays the calendar and the events that this teacher is an adviser of.
// the teacher will also be able to create an event for an activity they are an adviser of.
class CalendarTeacher extends StatefulWidget {
  const CalendarTeacher({Key? key, required this.user}) : super(key: key);

  final GoogleSignInAccount user;

  @override
  State<CalendarTeacher> createState() => _CalendarTeacherState();
}

class _CalendarTeacherState extends State<CalendarTeacher> {
  // Gets all events when this page loads.
  @override
  void initState() {
    super.initState();
    getEventsDocuments();
  }

  // This list will append Event items present in Firebase.
  late List<Event> events = [];

  // Checks whether all events have loaded from Firebase
  bool hasLoaded = false;

  // This function uses FirebaseFirestore to get events from activities that the teacher
  // is an adviser of.
  Future<void> getEventsDocuments() async {
    // First gets all of the teacher's activities that they are an adviser of.
    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(widget.user.displayName?.replaceAll(' ', '_').toLowerCase())
        .collection('activities')
        .get()
        .then((value) => {
              value.docs.forEach((element) async {
                String activityCollectionRef = 'activities';
                String activityDocRef = element.data()['clubRef'].split("/")[1];

                // Then gets all of the events from each activity and adds them to the list.
                var activityCollection = await FirebaseFirestore.instance
                    .collection(activityCollectionRef)
                    .doc(activityDocRef);

                var docSnapshot = await activityCollection.get();
                late String name;
                late Color color;
                if (docSnapshot.exists) {
                  Map<String, dynamic>? data = docSnapshot.data();
                  name = data!['name'];
                  color = findColor(data['type']);
                }

                await activityCollection
                    .collection('events')
                    .get()
                    .then((value) => {
                          value.docs.forEach((element) async {
                            setState(() {
                              // Only gets events that end later than today's date.
                              if (element
                                      .data()['endTime']
                                      .toDate()
                                      .compareTo(DateTime.now()) >
                                  0) {
                                events.add(Event(
                                  child: DisplayDate(
                                    appointment: Appointment(
                                      subject: name,
                                      notes: element.data()['notes'],
                                      color: color,
                                      endTime:
                                          element.data()['endTime'].toDate(),
                                      startTime:
                                          element.data()['startTime'].toDate(),
                                    ),
                                  ),
                                  dateTime: CalendarDateTime(
                                      year: element
                                          .data()['startTime']
                                          .toDate()
                                          .year,
                                      month: element
                                          .data()['startTime']
                                          .toDate()
                                          .month,
                                      day: element
                                          .data()['startTime']
                                          .toDate()
                                          .day,
                                      calendarType: CalendarType.GREGORIAN),
                                ));
                              }
                            });
                          })
                        });
              })
            });

    // Since teachers are a part of NCHS, they will also see events from NCHS.
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
                    events.add(Event(
                      child: DisplayDate(
                        appointment: Appointment(
                          subject: 'NCHS',
                          notes: element.data()['notes'],
                          color: findColor('school'),
                          endTime: element.data()['endTime'].toDate(),
                          startTime: element.data()['startTime'].toDate(),
                        ),
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

    // Once all of the events have been loaded, this will be set to true and the events
    // will be displayed to the user.
    setState(() {
      hasLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          // If the events haven't been loaded yet, a loading circle will show.
          if (hasLoaded == false) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );

            // Otherwise, all events have been loaded and will be displayed to the user.
          } else {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Uses the Flutter Event Calendar package to create a calendar that displays
                      // the events that were appended to the list.
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
                ),

                // An "add" icon will be at the bottom right of the screen.
                // This button will allow the teacher to add an event for an activity that
                // they are the adviser of by redirecting them to the Request Event page.
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.8,
                  top: MediaQuery.of(context).size.height * 0.72,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: Offset(12, 12))
                    ]),
                    child: IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: Colors.black,
                        size: 60,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RequestEvent(user: widget.user)),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
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

class DateDataSource extends CalendarDataSource {
  DateDataSource(List<Appointment> source) {
    appointments = source;
  }
}

// This widget will display each individual event.
// Each event will have a date (or range of dates), name of the event,
// details of the event, and start/end time of the event.
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
