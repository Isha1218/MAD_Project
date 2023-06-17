import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad/classes/event.dart';
import 'package:mad/classes/school_class.dart';
import 'package:mad/classes/icon_tags.dart';
import 'package:mad/tabs/student_tab.dart';
import 'package:intl/intl.dart';
import 'package:mad/classes/club.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../messaging/student_messsages.dart';

// This class displays the home page for the student
class Home extends StatefulWidget {
  const Home({super.key, required this.user});

  final GoogleSignInAccount user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // The user's first name, clubs and their events, and classes will be retrieved from Firebase
  // when the page initialized.
  @override
  void initState() {
    super.initState();
    getUser();
    getClubsAndEventsDocuments();
    getClassesDocuments();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // This list will keep track of the user's events.
  late List<Event> events = [];

  // This list will keep track of the clubs that the user is a part of.
  late List<Club> clubList = [];

  // This list will keep track of the classes that the user is a part of.
  late List<SchoolClass> classList = [];

  // This variable will assign the user's first name.
  String firstName = '';

  // This boolean will keep track of whether the student is looking at the classes or
  // events list.
  bool isClasses = true;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This function will produce a draft of an email to a particular teacher.
  sendEmail(String recipientEmail) async {
    final Email email = Email(
      body: '',
      subject: '',
      recipients: [recipientEmail],
      isHTML: false,
    );
    await FlutterEmailSender.send(email);
  }

  // This function will get the user's first name via Firebase.
  Future<void> getUser() async {
    var userSnapshot = await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.user.displayName?.replaceAll(' ', '_').toLowerCase())
        .get();

    if (userSnapshot.exists) {
      setState(() {
        firstName = userSnapshot.data()!['firstName'];
      });
    }
  }

  late NavigatorState _navigator;

  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  // This function will get the clubs that the user is a part of and events of those clubs.
  // It will start by accessing the activities collection in the students collection.
  // Then, the clubRef will be retrieved, which will be used to access the club in the activities collection.
  // The clubs will be added to the clubs list.
  // Events will be retrieved in the club collection and appended to the events list.
  Future<void> getClubsAndEventsDocuments() async {
    var activitiesCollection = await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.user.displayName?.replaceAll(' ', '_').toLowerCase())
        .collection('activities');
    await activitiesCollection.get().then((value) {
      value.docs.forEach((element) async {
        String clubRef = element.data()["clubRef"];
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
          String adviserRef = data!['adviser'].split('/')[1];
          var teacherSnapshot = await FirebaseFirestore.instance
              .collection('teachers')
              .doc(adviserRef)
              .get();

          String adviserName = '';

          if (teacherSnapshot.exists) {
            adviserName = teacherSnapshot.data()!['lastName'];
          }

          tag = data['tags'].split(",")[0];
          subject = data['name'];

          bool unread = false;
          await db.collection('conversations').get().then((value) => {
                value.docs.forEach((element) {
                  if (element.id.contains(clubRef) &&
                      element.data()['studentUnreadMessages'] > 0 && element.id.contains(widget.user.displayName!
                              .replaceAll(' ', '_')
                              .toLowerCase())) {
                    unread = true;
                  }
                })
              });
          clubList.add(Club(
              subject, IconTags(tag, false).findIcon(), adviserName, unread));
        }

        await actvityCollection.collection('events').get().then((value) {
          value.docs.forEach((element) async {
            String notes = element.data()['notes'];
            DateTime startTime = element.data()['startTime'].toDate();
            DateTime endTime = element.data()['endTime'].toDate();

            // Events will be prioritized based on time.
            setState(() {
              if (endTime.compareTo(DateTime.now()) > 0) {
                events.add(Event(subject, tag, startTime, endTime, notes));
              }
            });
          });
        });
      });
    });

    // Since all students are a part of NCHS, these events will also be added from
    // the nchs collection.
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

    // Finally, all personal events that students have created will be displayed as well.
    // This will access the events collection in the students collection and retrieve all
    // necessary information.
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
                        element.data()['subject'],
                        'Personal',
                        element.data()['startTime'].toDate(),
                        element.data()['endTime'].toDate(),
                        element.data()['notes']));
                  }
                });
              })
            });

    events.sort((a, b) {
      return a.endTime.compareTo(b.endTime);
    });
  }

  // This function will get all of the classes that the user is a part of.
  // It will access the schedule collection in the students collection.
  // Each class will be able to be retrieved from there and added to the class list.
  // Each class document has a teacherRef that will be used to find the teacher,
  // which will later be displayed.
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
              String teacherRef = docSnapshot.data()!['teacher'].split('/')[1];
              var teacherSnapshot = await FirebaseFirestore.instance
                  .collection('teachers')
                  .doc(teacherRef)
                  .get();

              String teacherName = '';

              if (teacherSnapshot.exists) {
                teacherName = teacherSnapshot.data()!['lastName'];
              }

              bool unread = false;
              await db.collection('conversations').get().then((value) => {
                    value.docs.forEach((element) {
                      if (element.id.contains(docRef) &&
                          element.data()['studentUnreadMessages'] > 0 &&
                          element.id.contains(widget.user.displayName!
                              .replaceAll(' ', '_')
                              .toLowerCase())) {
                        unread = true;
                      }
                    })
                  });

              setState(() {
                classList.add(SchoolClass(
                    docSnapshot.data()!['name'],
                    IconTags(docSnapshot.data()!['type'], false).findIcon(),
                    docSnapshot.data()!['period'],
                    teacherName,
                    unread));
                classList.sort((a, b) {
                  return a.period.compareTo(b.period);
                });
              });
            }
          })
        });
  }

  // This will build the layout of student home page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffF7F7F7),
      body: SafeArea(
        top: true,
        bottom: false,
        child: LayoutBuilder(builder: (context, constraints) {
          // If the classes haven't loaded, a progress circle will appear.
          if (classList.length == 0) {
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

                          // User will be redirected to the calendar page if the click on the
                          // "see all" events button.
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StudentTab(
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

                    // This will use the Flutter Swiper package, which displays the events in
                    // stacked and aestethic format. If the number of events is 0 or 1, the Swiper
                    // package won't be used.
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
                                borderRadius: BorderRadius.circular(20),
                              ),
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
                                    color: Colors.white,
                                    size: 40,
                                  )
                                ],
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

                // The user's list of classes and activities can scroll to the top of the screen,
                // so that the user can easily access them.
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
                                child: Builder(builder: (context) {
                                  if (isClasses == true) {
                                    return ListView.builder(
                                      controller: scrollController,
                                      itemCount: classList.length,
                                      itemBuilder: (context, index) {
                                        // When the user slides each individual list item to the left,
                                        // they will have the option to either message or email the teacher
                                        // of a particular class.
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

                                                    // The teacher's doc id will be accessed from Firebase,
                                                    // so that it can be passed into the Messaging page.
                                                    onPressed: (context) async {
                                                      var snapshot =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'classes')
                                                              .doc(classList[
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
                                                                      .toString())
                                                              .get();
                                                      if (snapshot.exists) {
                                                        String teacherId =
                                                            snapshot
                                                                .data()![
                                                                    'teacher']
                                                                .split('/')[1];

                                                        var conversationSnapshot = await db
                                                            .collection(
                                                                'conversations')
                                                            .doc(teacherId +
                                                                widget.user
                                                                    .displayName!
                                                                    .replaceAll(
                                                                        ' ',
                                                                        '_')
                                                                    .toLowerCase() +
                                                                classList[index]
                                                                    .name
                                                                    .replaceAll(
                                                                        ' ',
                                                                        '_')
                                                                    .toLowerCase() +
                                                                '_p' +
                                                                classList[index]
                                                                    .period
                                                                    .toString())
                                                            .get();
                                                        if (conversationSnapshot
                                                            .exists) {
                                                          db
                                                              .collection(
                                                                  'conversations')
                                                              .doc(teacherId
                                                                      .replaceAll(
                                                                          ' ', '_')
                                                                      .toLowerCase() +
                                                                  widget.user
                                                                      .displayName!
                                                                      .replaceAll(
                                                                          ' ', '_')
                                                                      .toLowerCase() +
                                                                  classList[
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
                                                                      .toString())
                                                              .update({
                                                            'studentUnreadMessages':
                                                                0
                                                          });
                                                        }
                                                        _navigator.push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      MessagesPage(
                                                                        className: classList[index].name.replaceAll(' ', '_').toLowerCase() +
                                                                            '_p' +
                                                                            classList[index].period.toString(),
                                                                        teacher:
                                                                            teacherId,
                                                                        studentID: widget
                                                                            .user
                                                                            .displayName!
                                                                            .replaceAll(' ',
                                                                                '_')
                                                                            .toLowerCase(),
                                                                        isClass:
                                                                            true,
                                                                        user: widget
                                                                            .user,
                                                                      )),
                                                        );
                                                      }
                                                    }),

                                                // This will allow the user to email the teacher by using sendEmail function.
                                                SlidableAction(
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor:
                                                        Color(0xffD56AA0),
                                                    icon: Icons.mail,
                                                    label: 'Email',

                                                    // This will get the user's email through Firebase
                                                    onPressed: (context) async {
                                                      var classSnapshot =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'classes')
                                                              .doc(classList[
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
                                                                      .toString())
                                                              .get();

                                                      if (classSnapshot
                                                          .exists) {
                                                        String teacherRef =
                                                            classSnapshot
                                                                .data()![
                                                                    'teacher']
                                                                .split('/')[1];

                                                        var teacherSnapshot =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'teachers')
                                                                .doc(teacherRef)
                                                                .get();

                                                        if (teacherSnapshot
                                                            .exists) {
                                                          sendEmail(
                                                              teacherSnapshot
                                                                      .data()![
                                                                  'email']);
                                                        }
                                                      }
                                                    })
                                              ],
                                            ),
                                            child:
                                                buildClasses(classList[index]));
                                      },
                                    );

                                    // The same options are presented for the activities side.
                                  } else {
                                    return ListView.builder(
                                      itemCount: clubList.length,
                                      itemBuilder: (context, index) {
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
                                                    onPressed: (context) async {
                                                      var snapshot =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'activities')
                                                              .doc(clubList[
                                                                      index]
                                                                  .name
                                                                  .replaceAll(
                                                                      ' ', '_')
                                                                  .toLowerCase())
                                                              .get();
                                                      if (snapshot.exists) {
                                                        String teacherId =
                                                            snapshot
                                                                .data()![
                                                                    'adviser']
                                                                .split('/')[1];

                                                        _navigator.push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      MessagesPage(
                                                                        className: clubList[index]
                                                                            .name
                                                                            .replaceAll(' ',
                                                                                '_')
                                                                            .toLowerCase(),
                                                                        teacher:
                                                                            teacherId,
                                                                        studentID: widget
                                                                            .user
                                                                            .displayName!
                                                                            .replaceAll(' ',
                                                                                '_')
                                                                            .toLowerCase(),
                                                                        isClass:
                                                                            false,
                                                                        user: widget
                                                                            .user,
                                                                      )),
                                                        );
                                                      }
                                                    }),
                                                SlidableAction(
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor:
                                                        Color(0xffD56AA0),
                                                    icon: Icons.mail,
                                                    label: 'Email',
                                                    onPressed: (context) async {
                                                      var activitySnapshot =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'activities')
                                                              .doc(clubList[
                                                                      index]
                                                                  .name
                                                                  .replaceAll(
                                                                      ' ', '_')
                                                                  .toLowerCase())
                                                              .get();

                                                      if (activitySnapshot
                                                          .exists) {
                                                        String teacherRef =
                                                            activitySnapshot
                                                                .data()![
                                                                    'adviser']
                                                                .split('/')[1];

                                                        var teacherSnapshot =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'teachers')
                                                                .doc(teacherRef)
                                                                .get();

                                                        if (teacherSnapshot
                                                            .exists) {
                                                          sendEmail(
                                                              teacherSnapshot
                                                                      .data()![
                                                                  'email']);
                                                        }
                                                      }
                                                    })
                                              ],
                                            ),
                                            child: buildActivities(
                                                clubList[index]));
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
                  },
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  // Each individual class is built in the list. It has the name, period, teacher,
  // and icon of the class.
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
              subtitle: Text(schoolClass.teacher),
              trailing: schoolClass.unread
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('P' + schoolClass.period.toString()),
                        SizedBox(
                          height: 2,
                        ),
                        CircleAvatar(
                          backgroundColor: Color(0xff78CAD2),
                          radius: 4,
                        )
                      ],
                    )
                  : Text('P' + schoolClass.period.toString()),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
            )
          ],
        ),
      );

  // Each individual activity is built in the list. It has the name, teacher, and icon of
  // the activity.
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
              subtitle: Text(club.adviser),
              trailing: club.unread
                  ? CircleAvatar(
                      backgroundColor: Color(0xff78CAD2),
                      radius: 4,
                    )
                  : Text(''),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
            )
          ],
        ),
      );
}

// Each individual event will be built and displayed in the Swiper.
// The event will provide information about the event's subject,
// description, icon, and start/end time.
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
