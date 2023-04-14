
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad/classes/event.dart';
import 'package:mad/classes/icon_tags.dart';
import 'package:mad/home/studentAbsences.dart';
import 'package:mad/tabs/parent_tab.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../classes/child.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// This widget will display the home page for the parent.
// It will display a snapshot of the events of the activities that the user's children are
// a part of.
// It will also display the list of children, so that the parent can report absences for their child.
class HomeParent extends StatefulWidget {
  const HomeParent({super.key, required this.user});

  final GoogleSignInAccount user;

  @override
  State<HomeParent> createState() => _HomeParentState();
}

class _HomeParentState extends State<HomeParent> {
  // This will get the parent's first name and the list of children and the events the children are a part of.
  @override
  void initState() {
    super.initState();
    getFirstName();
    getChildrenDocuments();
  }

  // This list will contain all of the events from activities that the children are a part of.
  List<Event> events = [];

  // This list will contain all of the children of the parent.
  List<Child> childrenList = [];

  // This will record the parent's first name to display.
  String firstName = '';

  // This function will get the user's first name by accessing the parents collection
  // and finding the doc id of the parent to access the firstName document field.
  Future<void> getFirstName() async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection('parents')
        .doc(widget.user.displayName?.replaceAll(' ', '_').toLowerCase())
        .get();

    if (docSnapshot.exists) {
      setState(() {
        firstName = docSnapshot.data()!['firstName'];
      });
    }
  }

  // This function will get the list of the parent's children.
  // It will access the parent collection and then the students collection.
  // It will then take the student reference and access the students collection
  // and add the child to the children list and children's events to the events list.
  Future<void> getChildrenDocuments() async {
    await FirebaseFirestore.instance
        .collection('parents')
        .doc(widget.user.displayName?.replaceAll(' ', '_').toLowerCase())
        .collection('students')
        .get()
        .then((value) => {
              value.docs.forEach((element) async {
                String studentCollectionRef = 'students';
                String studentDocRef = element.data()['student'].split("/")[1];

                var childCollection = await FirebaseFirestore.instance
                    .collection(studentCollectionRef)
                    .doc(studentDocRef);

                var docSnapshot = await childCollection.get();
                if (docSnapshot.exists) {
                  Map<String, dynamic>? data = docSnapshot.data();
                  childrenList.add(Child(
                      data!['firstName'],
                      data['lastName'],
                      Icon(Icons.face_rounded,
                          color: Color.fromARGB(255, 99, 57, 151), size: 40)));
                }

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
                            late String tag;
                            if (docSnapshot.exists) {
                              Map<String, dynamic>? data = docSnapshot.data();
                              tag = data!['tags'].split(",")[0];
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

                                        Event thisEvent = new Event(subject,
                                            tag, startTime, endTime, notes);

                                        // If this activity is not a duplicate, it will be added to the list.
                                        setState(() {
                                          if (endTime.compareTo(
                                                      DateTime.now()) >
                                                  0 &&
                                              !isDuplicated(thisEvent)) {
                                            events.add(thisEvent);

                                            events.sort((a, b) {
                                              return a.endTime
                                                  .compareTo(b.endTime);
                                            });
                                          }
                                        });
                                      })
                                    });
                          })
                        });
              })
            });

    // Since all students are from NCHS, all events in this collection will be accessed as well.
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

  // This function will check if the events have been duplicated in the list.
  // Two children may belong to the same activity, and therefore, have the same events.
  bool isDuplicated(Event thisEvent) {
    for (var event in events) {
      if (event.subject == thisEvent.subject &&
          event.notes == thisEvent.notes &&
          event.startTime == thisEvent.startTime &&
          event.endTime == thisEvent.endTime) {
        return true;
      }
    }
    return false;
  }

  // This will lay out the events and children in a nice manner.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      body: SafeArea(
        top: true,
        bottom: false,
        child: LayoutBuilder(builder: (context, constraints) {
          if (childrenList.length == 0) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          } else {
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                      child: Text(
                        'Welcome back',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        children: [
                          Text(
                            firstName,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.waving_hand,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Upcoming Events',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ParentTab(
                                            user: widget.user,
                                            selectedIndex: 1)));
                              },
                              child: Text(
                                'See all',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    // The Flutter Swiper package is used to display the events.
                    // Each event can be browsed by sliding. This pacakge displays the events in a cool
                    // stack layout.
                    // Events that have 0 or 1 event will not use the Swiper package.
                    LayoutBuilder(builder: (context, constraints) {
                      if (events.length > 1) {
                        return Swiper(
                          loop: events.length == 1 ? false : true,
                          itemBuilder: (BuildContext context, int index) {
                            print(events.length);
                            if (events.length != 0) {
                              return EventCard(event: events[index]);
                            } else {
                              return Text('');
                            }
                          },
                          itemCount: events.length > 5 ? 5 : events.length,
                          itemWidth: MediaQuery.of(context).size.width * 0.8,
                          itemHeight: MediaQuery.of(context).size.height * 0.18,
                          layout: SwiperLayout.STACK,
                        );
                      } else if (events.length == 1) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height:
                                    MediaQuery.of(context).size.height * 0.18,
                                child: EventCard(event: events[0])),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.18,
                              decoration: BoxDecoration(
                                  color: Color(0xff78CAD2),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'No Events',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Icon(
                                      Icons.check,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),

                // Allows the user to drag the list of children to the top of the screen for a more clear view.
                DraggableScrollableSheet(
                    initialChildSize: 0.5,
                    minChildSize: 0.5,
                    maxChildSize: 1,
                    builder: (context, scrollController) {
                      return SingleChildScrollView(
                        controller: scrollController,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.85,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: Colors.grey.shade300,
                              )
                            ],
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  height: 5,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 52),
                                child: Text(
                                  'Children',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: ListView.builder(
                                    controller: scrollController,
                                    itemCount: childrenList.length,
                                    itemBuilder: (context, index) {
                                      // When each individual list item is slided to the left, the user
                                      // will have the option to report an absence for that particular child.
                                      return Slidable(
                                          endActionPane: ActionPane(
                                            motion: const StretchMotion(),
                                            children: [
                                              SlidableAction(
                                                foregroundColor: Colors.white,
                                                backgroundColor: Color.fromARGB(
                                                    255, 251, 207, 74),
                                                icon: Icons.report,
                                                label: 'Report Absence',
                                                onPressed: (context) =>
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                StudentAbsences(
                                                                  child: childrenList[
                                                                          index]
                                                                      .name
                                                                      .toLowerCase(),
                                                                  user: widget
                                                                      .user,
                                                                ))),
                                              ),
                                            ],
                                          ),
                                          child: buildChildren(
                                              childrenList[index]));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            );
          }
        }),
      ),
    );
  }

  // This will create each individual list item for a specific child.
  // It will have the child's name and an icon to go along with it.
  Widget buildChildren(Child child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            ListTile(
              title: Text(child.name),
              leading: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: child.icon,
                ),
              ),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
            )
          ],
        ),
      );
}

// This will display each individual event in the Swiper
// It will display an icon, the subject, description, and start/end times of the event.
class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff78CAD2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(
            children: [
              IconTags(event.tag, true).findIcon(),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.subject,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    event.notes,
                    style: TextStyle(color: Color.fromARGB(230, 255, 255, 255)),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 25,
          ),
          LayoutBuilder(builder: (context, constraints) {
            if (event.startTime.day == event.endTime.day &&
                event.startTime.month == event.endTime.month &&
                event.startTime.year == event.endTime.year) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              DateFormat('MMM dd').format(event.startTime),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              DateFormat('h:mm a').format(event.startTime) +
                                  ' - ' +
                                  DateFormat('h:mm a').format(event.endTime),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              );
            } else {
              return Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              DateFormat('MMM dd').format(event.startTime) +
                                  ' - ' +
                                  DateFormat('MMM dd').format(event.endTime),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              );
            }
          }),
        ]),
      ),
    );
  }
}
