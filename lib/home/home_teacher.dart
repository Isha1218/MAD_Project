import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad/classes/event.dart';
import 'package:mad/classes/school_class.dart';
import 'package:mad/classes/icon_tags.dart';
import 'package:intl/intl.dart';
import 'package:mad/classes/club.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mad/tabs/teacher_tab.dart';
import '../messaging/teacher_class_messages.dart';

// This widget will display the home page for the teacher.
// It will have a snapshot of upcoming events for activities that the teacher is an adviser for.
// It will also display the list of the classes and activities that the teacher is a part of.
class HomeTeacher extends StatefulWidget {
  const HomeTeacher({super.key, required this.user});

  final GoogleSignInAccount user;

  @override
  State<HomeTeacher> createState() => _HomeTeacherState();
}

class _HomeTeacherState extends State<HomeTeacher> {
  // This will retrieve all the user's first name, events of the activities that the user is an adviser of,
  // classes that the teacher teaches, and all of the clubs that the teacher is an adviser of when the app loads.
  @override
  void initState() {
    super.initState();
    getUser();
    getEventsDocuments();
    getClassDocuments();
    getClubDocuments();
  }

  // This will store a list of events of the activities that the teacher is a part of
  late List<Event> events = [];

  // This will store a list of classes that the teacher teaches.
  late List<SchoolClass> classList = [];

  // This will store a list of clubs that the teacher is an adviser of.
  late List<Club> clubsList = [];

  // This will store the user's first name.
  String firstName = '';

  // This boolean will check if the user is on the classes section or the activities section
  // and switch to each when isClasses changes.
  bool isClasses = true;

  // This will get all of the clubs that the teacher is an adviser of.
  // It will access the teacher's collection and then the activities collection.
  // It will then go through each of the teacher's clubs and find the reference, so that
  // the club can be accessed through Firebase.
  // This will be done by accessing the activities collection and the Club object will be added to the
  // clubsList.
  Future<void> getClubDocuments() async {
    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(widget.user.displayName?.replaceAll(' ', '_').toLowerCase())
        .collection('activities')
        .get()
        .then((value) => {
              value.docs.forEach((element) async {
                String clubRef = element.data()['clubRef'].split('/')[1];
                var activitySnapshot = await FirebaseFirestore.instance
                    .collection('activities')
                    .doc(clubRef)
                    .get();
                if (activitySnapshot.exists) {
                  String name = activitySnapshot.data()!['name'];
                  String tag = activitySnapshot.data()!['tags'].split(',')[0];
                  setState(() {
                    clubsList.add(
                        Club(name, IconTags(tag, false).findIcon(), firstName));
                  });
                }
              })
            });
  }

  // This function will get the user's first name and set it firstName.
  Future<void> getUser() async {
    var userSnapshot = await FirebaseFirestore.instance
        .collection('teachers')
        .doc(widget.user.displayName?.replaceAll(' ', '_').toLowerCase())
        .get();

    if (userSnapshot.exists) {
      setState(() {
        firstName = userSnapshot.data()!['firstName'];
      });
    }
  }

  // This function will get all of the events that the teacher is a part of by accessing the
  // activities that they are a part of.
  // It will go through the activities collection in the teachers collection and access the club reference,
  // so that the clubs collection can be accessed and all of the events can be stored in the events list.
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
                              if (element
                                      .data()['endTime']
                                      .toDate()
                                      .compareTo(DateTime.now()) >
                                  0) {
                                events.add(Event(
                                    subject,
                                    tag,
                                    element.data()['startTime'].toDate(),
                                    element.data()['endTime'].toDate(),
                                    element.data()['notes']));
                                events.sort((a, b) {
                                  return a.endTime.compareTo(b.endTime);
                                });
                              }
                            });
                          })
                        });
              })
            });

    // Since all teachers are a part of NCHS, they will also have access to NCHS events.
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

                // These events will be sorted, so that upcoming events will be prioritized first.
                events.sort((a, b) {
                  return a.endTime.compareTo(b.endTime);
                });
              })
            });
  }

  // This function will get all of the classes that the teacher teaches.
  // It will access the teachers collection and the from there, the classes collection.
  // Each class has a classRef that will be taken and be used to access the particular class
  // in the classes collection. Each class will then be appended to the class list as a SchoolClass object.
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
                      data['period'],
                      firstName));
                }
              })
            });
  }

  // This will present the layout of the teacher's home page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      body: SafeArea(
        top: true,
        bottom: false,
        child: LayoutBuilder(builder: (context, constraints) {
          // Progress circle will show if classes haven't fully loaded from Firebase yet.
          if (classList.length == 0) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          } else {
            return Stack(children: [
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

                        // The "see all events" button will redirect the user to the calendar page.
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TeacherTab(
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

                  // This will use the Flutter Swiper package to display the events in aesthetic stacked
                  // layout that is swipable. If the length of events is 0 or 1, this package won't be used.
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
                              height: MediaQuery.of(context).size.height * 0.18,
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

              // This scrollable sheet will allow the user to drag the list of classes/activities to the
              // top of the screen, so that the user can easily view them.
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
                              padding: const EdgeInsets.symmetric(vertical: 10),
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    child: Text(
                                      'Classes',
                                      style: TextStyle(
                                        color: isClasses == true
                                            ? Colors.black
                                            : Colors.black.withOpacity(0.6),
                                        fontWeight: isClasses == true
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: isClasses == true ? 20 : 16,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        this.isClasses = true;
                                      });
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Activities',
                                      style: TextStyle(
                                        color: isClasses == false
                                            ? Colors.black
                                            : Colors.black.withOpacity(0.6),
                                        fontWeight: isClasses == false
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: isClasses == false ? 20 : 16,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        this.isClasses = false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  if (isClasses == true) {
                                    return ListView.builder(
                                      controller: scrollController,
                                      itemCount: classList.length,
                                      itemBuilder: (context, index) {
                                        // The teacher will have the opportunity to message students from a particular class
                                        // when they slide the individual class item to the left.
                                        return Slidable(
                                            endActionPane: ActionPane(
                                              motion: const StretchMotion(),
                                              children: [
                                                SlidableAction(
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 251, 207, 74),
                                                    icon: Icons.message,
                                                    label: 'Message',
                                                    onPressed: (context) {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ListingsPage(
                                                              className: classList[
                                                                          index]
                                                                      .name
                                                                      .replaceAll(
                                                                          ' ',
                                                                          '_')
                                                                      .toLowerCase() +
                                                                  '_p' +
                                                                  classList[
                                                                          index]
                                                                      .period
                                                                      .toString(),
                                                              teacher: widget
                                                                  .user
                                                                  .displayName!
                                                                  .replaceAll(
                                                                      ' ', '_')
                                                                  .toLowerCase(),
                                                              isClass: true,
                                                            ),
                                                          ));
                                                    }),
                                              ],
                                            ),
                                            child:
                                                buildClasses(classList[index]));
                                      },
                                    );
                                  } else {
                                    // The teacher will have the opportunity to message students from a particular activity
                                    // when they slide the individual class item to the left.
                                    return ListView.builder(
                                      itemCount: clubsList.length,
                                      itemBuilder: (context, index) {
                                        return Slidable(
                                            endActionPane: ActionPane(
                                              motion: const StretchMotion(),
                                              children: [
                                                SlidableAction(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 251, 207, 74),
                                                  icon: Icons.message,
                                                  label: 'Message',
                                                  onPressed: (context) =>
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ListingsPage(
                                                              className: clubsList[
                                                                      index]
                                                                  .name
                                                                  .replaceAll(
                                                                      ' ', '_')
                                                                  .toLowerCase(),
                                                              teacher: widget
                                                                  .user
                                                                  .displayName!
                                                                  .replaceAll(
                                                                      ' ', '_')
                                                                  .toLowerCase(),
                                                              isClass: false,
                                                            ),
                                                          )),
                                                ),
                                              ],
                                            ),
                                            child: buildActivities(
                                                clubsList[index]));
                                      },
                                    );
                                  }
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ]);
          }
        }),
      ),
    );
  }

  // This widget will build each individual class as displayed in the list.
  // It will have the class name, period, and icon.
  Widget buildClasses(SchoolClass schoolClass) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            ListTile(
              title: Text(schoolClass.name),
              leading: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: schoolClass.icon,
                ),
              ),
              trailing: Text('P' + schoolClass.period.toString()),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
            )
          ],
        ),
      );

  // This widget will build each individual activity as displayed in the list.
  // It will have the activity name, and icon.
  Widget buildActivities(Club club) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            ListTile(
              title: Text(club.name),
              leading: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: club.icon,
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

// This widget will display each individual event as displayed in the Swiper.
// It will provide information about the name, description, icon, and start/end times of the event.
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
