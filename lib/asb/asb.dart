import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

//HELLO PLS WORK

class ASB extends StatefulWidget {
  const ASB({super.key});

  @override
  State<ASB> createState() => _ASBState();
}

class _ASBState extends State<ASB> {
  @override
  void initState() {
    super.initState();
    getEventsDocuments();
  }

  late List<Appointment> events = [];

  Future<void> getEventsDocuments() async {
    await FirebaseFirestore.instance
        .collection('activities')
        .doc('nchs')
        .collection('events')
        .get()
        .then((value) => {
              // today date: Jan 18
              // event date: Jan 1
              // show event
              // event date has to be greater than today date 1 month ago
              value.docs.forEach((element) async {
                if (element.data()['endTime'].toDate().compareTo(DateTime(
                        DateTime.now().year,
                        DateTime.now().month - 1,
                        DateTime.now().day)) >
                    0) {
                  setState(() {
                    events.add(Appointment(
                        subject: 'NCHS',
                        notes: element.data()['notes'],
                        color: Color(0xff4C2C72),
                        endTime: element.data()['endTime'].toDate(),
                        startTime: element.data()['startTime'].toDate()));

                    events.sort((a, b) {
                      return a.endTime.compareTo(b.endTime);
                    });
                  });
                }
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff78CAD2), // change
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          if (events.isEmpty) {
            return Container(
              child: Text('Loading...'),
            );
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
                  child: Text(
                    'Announcements From ASB',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Expanded(
                  flex: 14,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: events
                          .map((e) => new DisplayEvent(
                                notes: e.notes,
                                startTime: e.startTime,
                                endTime: e.endTime,
                              ))
                          .toList(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            color: Color(0xff4C2C72),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextButton(
                          onPressed: () async {
                            final url = Uri.parse(
                              'https://www.instagram.com/northcreekasb/',
                            );
                            if (await canLaunchUrl(url)) {
                              launchUrl(url);
                            } else {
                              // ignore: avoid_print
                              print("Can't launch $url");
                            }
                          },
                          child: Text(
                            'Check Out ASB on Instagram',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        }),
      ),
    );

    // give body single child scroll view
    // don't give button scroll
  }
}

class DisplayEvent extends StatefulWidget {
  final String notes;
  final DateTime startTime;
  final DateTime endTime;

  const DisplayEvent({
    Key? key,
    required this.notes,
    required this.startTime,
    required this.endTime,
  }) : super(key: key);

  @override
  State<DisplayEvent> createState() => _DisplayEventState();
}

class _DisplayEventState extends State<DisplayEvent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.fromLTRB(32, 16, 32, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      color: Color(0xff4C2C72),
                      size: 40.0,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Flexible(
                      child: Column(
                        children: [
                          Text(
                            DateFormat('MMM dd').format(widget.startTime),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff4C2C72),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormat('hh:mm a').format(widget.startTime),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff4C2C72),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                      child: Text(
                        '.....',
                        style: TextStyle(
                          color: Color(0xff4C2C72),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          DateFormat('MMM dd').format(widget.endTime),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff4C2C72),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('hh:mm a').format(widget.endTime),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff4C2C72),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.notes,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                )
              ]),
            )),
      ],
    );
  }
}
