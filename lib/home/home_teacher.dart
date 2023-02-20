// At bottom, list of all children
// When student is clicked, absence can be reported
// At top, event that each child is a part of

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad/classes/child.dart';
import 'package:mad/classes/school_class.dart';
import 'package:mad/classes/icon_tags.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:intl/intl.dart';
import 'package:mad/classes/club.dart';
import 'package:mad/home/display_clubs_or_classes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad/classes/event.dart';
import 'carousel_page.dart';

class HomeTeacher extends StatefulWidget {
  const HomeTeacher({Key? key, required this.user}) : super(key: key);

  final GoogleSignInAccount user;

  @override
  State<HomeTeacher> createState() => _HomeTeacherState();
}

class _HomeTeacherState extends State<HomeTeacher> {
  @override
  void initState() {
    super.initState();
    getEventsDocuments();
    getClassDocuments();
  }

  late List<Event> events = [];
  late List<SchoolClass> classList = [];

  Future<void> getEventsDocuments() async {
    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(widget.user.displayName?.replaceAll(' ', '_').toLowerCase())
        .collection('activities')
        .get()
        .then((value) => {
              value.docs.forEach((element) async {
                String activityCollectionRef = 'activities';
                String activityDocRef = element.data()['clubRef'].split("/")[1];

                var activityCollection = await FirebaseFirestore.instance
                    .collection(activityCollectionRef)
                    .doc(activityDocRef);

                var docSnapshot = await activityCollection.get();
                late String subject;
                late String tag;
                if (docSnapshot.exists) {
                  Map<String, dynamic>? data = docSnapshot.data();
                  subject = data!['name'];
                  tag = data['type'].split(",")[0];
                }

                await activityCollection
                    .collection('events')
                    .get()
                    .then((value) => {
                          value.docs.forEach((element) async {
                            setState(() {
                              events.add(Event(
                                  subject,
                                  tag,
                                  element.data()['startTime'].toDate(),
                                  element.data()['endTime'].toDate(),
                                  element.data()['notes']));
                              events.sort((a, b) {
                                return a.endTime.compareTo(b.endTime);
                              });
                            });
                          })
                        });
              })
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
                    events.add(Event(
                        'NCHS',
                        'School',
                        element.data()['startTime'].toDate(),
                        element.data()['endTime'].toDate(),
                        element.data()['notes']));
                  }
                });

                events.sort((a, b) {
                  return a.endTime.compareTo(b.endTime);
                });
              })
            });
  }

  Future<void> getClassDocuments() async {
    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(widget.user.displayName?.replaceAll(' ', '_').toLowerCase())
        .collection('classes')
        .get()
        .then((value) => {
              value.docs.forEach((element) async {
                String classCollectionRef = 'classes';
                String classDocRef = element.data()['classRef'].split("/")[1];

                var activityCollection = await FirebaseFirestore.instance
                    .collection(classCollectionRef)
                    .doc(classDocRef);

                var docSnapshot = await activityCollection.get();

                if (docSnapshot.exists) {
                  Map<String, dynamic>? data = docSnapshot.data();
                  classList.add(SchoolClass(
                      data!['name'],
                      IconTags(data['type'], false).findIcon(),
                      data['period']));
                }
              })
            });
  }

  final _controller = PageController();

  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff78CAD2),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('VERTEX',
                    style: GoogleFonts.bungee(
                      textStyle: TextStyle(
                        shadows: [
                          Shadow(
                            offset: Offset(3.0, 3.0),
                            blurRadius: 3.0,
                            color:
                                Color.fromARGB(255, 0, 0, 0).withOpacity(0.25),
                          ),
                        ],
                        color: Colors.white,
                        fontSize: 32.5,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: 150,
                    child: LayoutBuilder(builder: (context, constraints) {
                      if (events.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No Upcoming Events',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 60,
                            )
                          ],
                        );
                      } else if (events.length == 1) {
                        return PageView(
                          controller: _controller,
                          children: [
                            CarouselPageDisplay(events: events, index: 0)
                          ],
                        );
                      } else if (events.length == 2) {
                        return PageView(
                          controller: _controller,
                          children: [
                            CarouselPageDisplay(events: events, index: 0),
                            CarouselPageDisplay(events: events, index: 1),
                          ],
                        );
                      } else {
                        return PageView(
                          controller: _controller,
                          children: [
                            CarouselPageDisplay(events: events, index: 0),
                            CarouselPageDisplay(events: events, index: 1),
                            CarouselPageDisplay(events: events, index: 2),
                          ],
                        );
                      }
                    })),
                SmoothPageIndicator(
                  controller: _controller,
                  count: events.length > 2 ? 3 : events.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Color(0xff4C2C72),
                    dotColor: Colors.white,
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                ),
                Wrap(children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.56,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xffF7F7F7),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff78CAD2),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                                  child: Text(
                                    'Classes',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(child: ClubsOrClassesFormat(list: classList))
                      ],
                    ),
                  ),
                ])
              ],
            ),
          ),
        ));
  }

  Color findColor(String type) {
    if (type == "club") {
      return Color(0xffFFD863);
    } else if (type == "sports") {
      return Color(0xff4C2C72);
    } else {
      return Color(0xffD56AA0);
    }
  }

  Color findPronounColor(String pronoun) {
    if (pronoun.contains('she')) {
      return Colors.pink;
    } else if (pronoun.contains('he')) {
      return Colors.blue;
    } else {
      return Colors.yellow;
    }
  }
}
