import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad/classes/event.dart';
import 'package:mad/classes/school_class.dart';
import 'package:mad/classes/icon_tags.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:intl/intl.dart';
import 'package:mad/classes/club.dart';
import 'package:mad/home/display_clubs_or_classes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'carousel_page.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.user}) : super(key: key);

  final GoogleSignInAccount user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    getClubsAndEventsDocuments();
    getClassesDocuments();
  }

  late List<Event> events = [];
  late List<Club> clubList = [];
  late List<SchoolClass> classList = [];

  Future<void> getClubsAndEventsDocuments() async {
    var activitiesCollection = await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.user.displayName?.replaceAll(' ', '_').toLowerCase())
        .collection('activities');
    await activitiesCollection.get().then((value) {
      value.docs.forEach((element) async {
        var clubRef = element.data()["clubRef"];
        String collectionStr = "activities";
        String docStr = clubRef.split("/")[1];

        var actvityCollection = await FirebaseFirestore.instance
            .collection(collectionStr)
            .doc(docStr);

        var docSnapshot = await actvityCollection.get();
        late String subject;
        late String tag;
        if (docSnapshot.exists) {
          Map<String, dynamic>? data = docSnapshot.data();
          tag = data!['tags'].split(",")[0];
          subject = data['name'];
          clubList.add(Club(subject, IconTags(tag, false).findIcon()));
        }

        await actvityCollection.collection('events').get().then((value) {
          value.docs.forEach((element) async {
            String notes = element.data()['notes'];
            DateTime startTime = element.data()['startTime'].toDate();
            DateTime endTime = element.data()['endTime'].toDate();

            setState(() {
              if (endTime.compareTo(DateTime.now()) > 0) {
                events.add(Event(subject, tag, startTime, endTime, notes));
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

  Future<void> getClassesDocuments() async {
    var classesCollection = await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.user.displayName?.replaceAll(' ', '_').toLowerCase())
        .collection('schedule');
    classesCollection.get().then((value) => {
          value.docs.forEach((element) async {
            String collectionRef = 'classes';
            String docRef = element.data()['classRef'].split("/")[1];

            var scheduleCollection = await FirebaseFirestore.instance
                .collection(collectionRef)
                .doc(docRef);

            var docSnapshot = await scheduleCollection.get();
            if (docSnapshot.exists) {
              Map<String, dynamic>? data = docSnapshot.data();
              classList.add(SchoolClass(data!['name'],
                  IconTags(data['type'], false).findIcon(), data['period']));
              classList.sort((a, b) {
                return a.period.compareTo(b.period);
              });
            }
          })
        });
  }

  final _controller = PageController();

  bool isFirst = false;

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
                  count: events.length > 3 ? 3 : events.length,
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
                              TextButton(
                                onPressed: () {
                                  // change isFirst to true
                                  setState(() {
                                    isFirst = false;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: !isFirst
                                        ? Color(0xff78CAD2)
                                        : Color(0xffF7F7F7),
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 8.0, 10.0, 8.0),
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
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              TextButton(
                                onPressed: () {
                                  // change isFirst to false
                                  setState(() {
                                    isFirst = true;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isFirst
                                        ? Color(0xff78CAD2)
                                        : Color(0xffF7F7F7),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 8.0, 10.0, 8.0),
                                    child: Text(
                                      'Activities',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(child:
                            LayoutBuilder(builder: (context, constraints) {
                          if (isFirst) {
                            return ClubsOrClassesFormat(list: clubList);
                          } else {
                            return ClubsOrClassesFormat(list: classList);
                          }
                        })),
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
}
