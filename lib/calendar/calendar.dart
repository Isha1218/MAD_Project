import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key, required this.user}) : super(key: key);

  final GoogleSignInAccount user;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  void initState() {
    super.initState();
    getDocuments();
  }

  late List<Appointment> events = [];
  Future<void> getDocuments() async {
    var studentCollection = await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.user.displayName?.replaceAll(' ', '_').toLowerCase())
        .collection('activities');
    await studentCollection.get().then((value) {
      value.docs.forEach((element) async {
        var clubRef = element.data()["clubRef"];
        String collectionStr = "activities";
        String docStr = clubRef.split("/")[1];

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

            setState(() {
              if (endTime.compareTo(DateTime.now()) > 0) {
                events.add(Appointment(
                    subject: subject,
                    notes: notes,
                    color: color,
                    startTime: startTime,
                    endTime: endTime));

                events.sort((a, b) {
                  return a.endTime.compareTo(b.endTime);
                });
              }
            });
          });
        });
      });
    });

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
                    events.add(Appointment(
                        subject: 'NCHS',
                        color: findColor('school'),
                        notes: element.data()['notes'],
                        endTime: element.data()['endTime'].toDate(),
                        startTime: element.data()['startTime'].toDate()));
                  }
                });

                events.sort((a, b) {
                  return a.endTime.compareTo(b.endTime);
                });
              })
            });
  }

  Widget buildList(QuerySnapshot snapshot) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final doc = events[index];
        return DisplayDate(
            subject: doc.subject,
            startTime: doc.startTime,
            endTime: doc.endTime,
            notes: doc.notes,
            color: doc.color);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff78CAD2),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Calendar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              height: 300,
              child: SfCalendar(
                view: CalendarView.month,
                dataSource: DateDataSource(events),
                backgroundColor: Color(0xff78CAD2),
                headerHeight: 50,
                todayHighlightColor: Colors.black,
                headerStyle: CalendarHeaderStyle(
                    textStyle: TextStyle(
                  color: Colors.white,
                )),
                viewHeaderStyle: ViewHeaderStyle(
                    dayTextStyle: TextStyle(
                  color: Colors.white,
                )),
                monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.indicator,
                    monthCellStyle: MonthCellStyle(
                        textStyle: TextStyle(
                      color: Colors.white,
                    ))),
                showDatePickerButton: true,
                showNavigationArrow: true,
                minDate: DateTime.now(),
              ),
            ),
            Expanded(
              child: Container(
                height: 700,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Column(
                  children: [
                    Text(
                      'Upcoming Events',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("events")
                          .orderBy("endTime")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return LinearProgressIndicator();
                        else
                          return Expanded(child: buildList(snapshot.data!));
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Color findColor(String type) {
    if (type == "club") {
      return Color(0xffFFD863);
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

class DisplayDate extends StatelessWidget {
  final String subject;
  final DateTime startTime;
  final DateTime endTime;
  final String notes;
  final Color color;

  const DisplayDate({
    Key? key,
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.notes,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          height: 100,
          width: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: this.color,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('MMM').format(DateTime(0, this.startTime.month)),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
              Text(
                '${this.startTime.day}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ],
          ),
        ),
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xffF4F4F4),
            ),
            margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
            height: 100,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    this.subject,
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  Text(this.notes,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
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
                        DateFormat('h:mm a').format(this.startTime) +
                            ' - ' +
                            DateFormat('h:mm a').format(this.endTime),
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
      ],
    );
  }
}
