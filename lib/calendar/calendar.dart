import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad/calendar/student_set_event.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key, required this.user}) : super(key: key);

  final GoogleSignInAccount user;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  // Gets all events when this page loads.
  @override
  void initState() {
    super.initState();
    getDocuments();
  }

  // This list will store all of the student's personal events and events from activties
  // that they are a part of. These events will be taken from Firebase.
  late List<Event> events = [];

  // This boolean will check if all of the events have been loaded to display them to the user.
  bool hasLoaded = false;

  // This function will get all of the student's events using Firebase and append them to the events list.
  Future<void> getDocuments() async {
    // First access the students collection and find all of their activities.
    var studentCollection = await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.user.displayName?.replaceAll(' ', '_').toLowerCase())
        .collection('activities');
    await studentCollection.get().then((value) {
      value.docs.forEach((element) async {
        var clubRef = element.data()["clubRef"];
        String collectionStr = "activities";
        String docStr = clubRef.split("/")[1];

        // Access each activity collection that the student is part of and get the events
        // from those activities.
        var actvityCollection = await FirebaseFirestore.instance
            .collection(collectionStr)
            .doc(docStr);

        var docSnapshot = await actvityCollection.get();
        late String subject;
        late Color color;
        if (docSnapshot.exists) {
          Map<String, dynamic>? data = docSnapshot.data();
          subject = data!['name'];
          color = findColor(data['type']);
        }
        await actvityCollection.collection('events').get().then((value) {
          value.docs.forEach((element) async {
            String notes = element.data()['notes'];
            DateTime startTime = element.data()['startTime'].toDate();
            DateTime endTime = element.data()['endTime'].toDate();

            // Only adds events that are later than today's date.
            setState(() {
              if (endTime.compareTo(DateTime.now()) > 0) {
                events.add(Event(
                  child: DisplayDate(
                    appointment: Appointment(
                        subject: subject,
                        notes: notes,
                        color: color,
                        startTime: startTime,
                        endTime: endTime),
                  ),
                  dateTime: CalendarDateTime(
                      year: startTime.year,
                      month: startTime.month,
                      day: startTime.day,
                      calendarType: CalendarType.GREGORIAN),
                ));
              }
            });
          });
        });
      });
    });

    // Adds all NCHS events because all students are a part of this school by
    //  going through the activities collection and accessing all NCHS events.
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
                                color: findColor('school'),
                                notes: element.data()['notes'],
                                endTime: element.data()['endTime'].toDate(),
                                startTime:
                                    element.data()['startTime'].toDate())),
                        dateTime: CalendarDateTime(
                            year: element.data()['startTime'].toDate().year,
                            month: element.data()['startTime'].toDate().month,
                            day: element.data()['startTime'].toDate().day,
                            calendarType: CalendarType.GREGORIAN)));
                  }
                });
              })
            });

    // Adds student's personal events by accessing the students collection and navigating
    // to the user document. The events collection will then be accessed to get all of the events.
    await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.user.displayName!.replaceAll(' ', '_').toLowerCase())
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
                              subject: element.data()['subject'],
                              notes: element.data()['notes'],
                              endTime: element.data()['endTime'].toDate(),
                              startTime: element.data()['startTime'].toDate(),
                              color: Color(0xff909C81)),
                        ),
                        dateTime: CalendarDateTime(
                            year: element.data()['startTime'].toDate().year,
                            month: element.data()['startTime'].toDate().month,
                            day: element.data()['startTime'].toDate().day,
                            calendarType: CalendarType.GREGORIAN)));
                  }
                });
              })
            });

    // Notfies the widget to display the events to the user when they have all been loaded.
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
          // If the events haven't been loaded, the progress circle will show.
          if (hasLoaded == false) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );

            // Otherwise it will display the calendar and all of the events.
          } else {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Uses the Flutter Event Calendar package to build the calendar.
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

                // Add icon positioned at the bottom right of the screen.
                // When clicked, the user will be redirected to a screen to add their own personal events.
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.8,
                  top: MediaQuery.of(context).size.height * 0.75,
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
                                  StudentSetEvent(user: widget.user)),
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
