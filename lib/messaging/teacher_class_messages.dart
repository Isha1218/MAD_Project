import "package:chat_bubbles/chat_bubbles.dart";
import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mad/messaging/teacher_messages.dart';
import '../classes/teacher_messaging_preview.dart';
import '../tabs/teacher_tab.dart';
import 'package:intl/intl.dart';

// Initializes Firestore database
var db = FirebaseFirestore.instance;

// This class lists out all of the teacher's students, so that they can message them.
// The user is also able to send announcements to a class.
class ListingsPage extends StatefulWidget {
  const ListingsPage({
    Key? key,
    required this.className,
    required this.teacher,
    required this.isClass,
    required this.user,
  }) : super(key: key);
  final String className;
  final String teacher;
  final bool isClass;
  final GoogleSignInAccount user;

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  // This controller contains text from an announcements.
  final TextEditingController _announcementController = TextEditingController();

  // This list contains the all students' names in the class
  List<TeacherMessagingPreview> students = [];

  // This controller will function as a search bar to query for items.
  TextEditingController controller = TextEditingController();

  // This FocusNode will add focus to the search bar when it is clicked.
  FocusNode myfocus = FocusNode();

  // Initalized the name and period (none if club) of the class/club through Firebase
  String schoolClassName = '';
  int period = 0;

  // This gets all of the students in the class and the club/class name when the screen initializes.
  @override
  void initState() {
    getStudents();
    if (widget.isClass) {
      getClassName();
    } else {
      getClubName();
    }
    super.initState();
  }

  // This function gets the class name and period from Firebase by accessing the classes collection
  Future<void> getClassName() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.className)
        .get();
    if (snapshot.exists) {
      setState(() {
        schoolClassName = snapshot.data()!['name'];
        period = snapshot.data()!['period'];
      });
    }
  }

  // This functions gets the club name from Firebase by accessing the activities collection
  Future<void> getClubName() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('activities')
        .doc(widget.className)
        .get();
    if (snapshot.exists) {
      setState(() {
        schoolClassName = snapshot.data()!['name'];
      });
    }
  }

  // This function represents each individual student in the class
  ListTile buildList(String student) {
    return ListTile(
      title: Text(student,
          style: GoogleFonts.rubik(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w300))),
      trailing: Icon(Icons.email),
      tileColor: Color.fromRGBO(76, 44, 114, 0.6),
    );
  }

  // This function gets all of the names of the students and appends them to a list
  // It accesses the students collections in the classes/activities collection.
  Future<void> getStudents() async {
    print('get students');
    print(widget.className);
    await db
        .collection(widget.isClass ? 'classes' : 'activities')
        .doc(widget.className)
        .collection('students')
        .get()
        .then((value) => {
              value.docs.forEach((element) async {
                if (element.exists) {
                  String lastMessage = 'Start a new conversation!';
                  int unreadMessages = 0;
                  String lastMessageDate = '';
                  DateTime lastMessageDateTime =
                      DateFormat('yyyy MMM dd').parse('1977 Jan 01');
                  var conversationSnapshot = await db
                      .collection('conversations')
                      .doc(widget.teacher +
                          element
                              .data()['name']
                              .replaceAll(' ', '_')
                              .toLowerCase() +
                          widget.className)
                      .get();
                  if (conversationSnapshot.exists) {
                    lastMessage = conversationSnapshot.data()!['lastMessage'];
                    unreadMessages =
                        conversationSnapshot.data()!['teacherUnreadMessages'];
                    lastMessageDateTime = conversationSnapshot
                        .data()!['lastMessageDate']
                        .toDate();
                    if (DateFormat('yyyy MM dd').format(lastMessageDateTime) ==
                        DateFormat('yyyy MM dd').format(DateTime.now())) {
                      lastMessageDate =
                          DateFormat('hh:mm a').format(lastMessageDateTime);
                    } else if (DateTime.now()
                            .difference(lastMessageDateTime)
                            .inDays <
                        7) {
                      lastMessageDate =
                          DateFormat('EEE').format(lastMessageDateTime);
                    } else {
                      lastMessageDate =
                          DateFormat('M/d/y').format(lastMessageDateTime);
                    }
                  }
                  setState(() {
                    students.add(TeacherMessagingPreview(
                        element.data()['name'],
                        unreadMessages,
                        lastMessage,
                        lastMessageDate,
                        lastMessageDateTime));
                  });
                  students.sort((a, b) =>
                      b.lastMessageDateTime.compareTo(a.lastMessageDateTime));
                } else {
                  print('nonexistent');
                }
              })
            });
  }

  // This will send an announcement by setting the announcement in Firebase.
  Future<void> sendAnnouncement() async {
    print('announcement: ' + _announcementController.text);
    var data;

    String id;
    for (int index = 0; index < students.length; index++) {
      id = students[index].name.replaceAll(' ', '_').toLowerCase();

      data = {
        'className': widget.className,
        'content': _announcementController.text,
        'isImage': false,
        'announcement': true,
        'reciever': id,
        'sender': widget.teacher,
        'timeSent': Timestamp.now()
      };

      var ref = db
          .collection('conversations')
          .doc(widget.teacher +
              students[index].name.replaceAll(' ', '_').toLowerCase() +
              widget.className)
          .collection('messages')
          .doc();

      ref.set(data);

      var conversationSnapshot = await db
          .collection('conversations')
          .doc(widget.teacher +
              students[index].name.replaceAll(' ', '_').toLowerCase() +
              widget.className)
          .get();
      int teacherUnreadMessages = 0;
      int studentUnreadMessages = 0;
      if (conversationSnapshot.exists) {
        teacherUnreadMessages =
            conversationSnapshot.data()!['teacherUnreadMessages'];
        studentUnreadMessages =
            conversationSnapshot.data()!['studentUnreadMessages'];
        db
            .collection('conversations')
            .doc(widget.teacher +
                students[index].name.replaceAll(' ', '_').toLowerCase() +
                widget.className)
            .set({
          'lastMessage': "ANNOUNCEMENT: " + _announcementController.text,
          'lastMessageDate': DateTime.now(),
          'studentUnreadMessages': studentUnreadMessages + 1,
          'teacherUnreadMessages': teacherUnreadMessages,
        });
      }
    }
    _announcementController.clear();
  }

  Widget displaySearchBar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      child: TextField(
        // Has a done button to exit out of the search bar.
        textInputAction: TextInputAction.done,
        focusNode: myfocus,
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            prefixIconColor: Colors.grey,
            hintText: 'Search for students...',
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Color(0xffF7F7F7),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffF7F7F7)),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffF7F7F7)),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ))),

        // Filters results when query has changed.
        onChanged: searchActivity,
      ),
    );
  }

  // This function will filter the results as the user searches an item.
  void searchActivity(String query) {
    if (query != '') {
      final suggestions = students.where((item) {
        final itemName = item.name.toLowerCase();
        final input = query.toLowerCase();

        return itemName.contains(input);
      }).toList();

      setState(() {
        students = suggestions;
      });

      // query is empty, so it should display all of the bookkeeper items.
    } else {
      students.clear();
      getStudents();
    }
  }

  // This will display the students' list and the send announcements button
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        shadowColor: Color(0xffF7F7F7),
        toolbarHeight: 170,
        elevation: 15,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios,
                        color: Colors.grey, size: 23),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeacherTab(
                                    user: widget.user,
                                    selectedIndex: 0,
                                  )));
                    },
                  ),
                ),
                Text(
                  widget.isClass
                      ? schoolClassName + ' (' + 'P' + period.toString() + ')'
                      : schoolClassName,
                  style: TextStyle(
                    color: Color(0xff78CAD2),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Center(child: displaySearchBar()),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
      backgroundColor: Color(0xffF7F7F7),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 10,
              ),

              // Displays a list of all of the students.
              // When the teacher clicks on a student, they can message them.
              Container(
                height: 400,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: students[index].unread == 0
                                    ? Colors.grey.shade300
                                    : Color(0xff78CAD2),
                                radius: 30,
                                child: CircleAvatar(
                                  backgroundColor: Color(0xffF7F7F7),
                                  radius: 25,
                                  child: Text(
                                    students[index]
                                            .name
                                            .split(' ')[0]
                                            .substring(0, 1)
                                            .toUpperCase() +
                                        students[index]
                                            .name
                                            .split(' ')[1]
                                            .substring(0, 1)
                                            .toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  students[index].lastMessage,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: students[index].unread == 0
                                        ? Colors.grey
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: students[index].unread == 0
                                        ? FontWeight.normal
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                              trailing: LayoutBuilder(
                                  builder: (context, constraints) {
                                if (students[index].unread > 0) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(students[index].lastMessageDate),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Color(0xff78CAD2),
                                        child: Text(
                                          students[index].unread.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  return Text(students[index].lastMessageDate);
                                }
                              }),
                              tileColor: Color(0xffF7F7F7),
                              title: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  students[index].name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              onTap: () async {
                                var conversationSnapshot = await db
                                    .collection('conversations')
                                    .doc(widget.teacher
                                            .replaceAll(' ', '_')
                                            .toLowerCase() +
                                        students[index]
                                            .name
                                            .replaceAll(' ', '_')
                                            .toLowerCase() +
                                        widget.className)
                                    .get();
                                if (conversationSnapshot.exists) {
                                  db
                                      .collection('conversations')
                                      .doc(widget.teacher
                                              .replaceAll(' ', '_')
                                              .toLowerCase() +
                                          students[index]
                                              .name
                                              .replaceAll(' ', '_')
                                              .toLowerCase() +
                                          widget.className)
                                      .update({'teacherUnreadMessages': 0});
                                }

                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return TeacherMessagesPage(
                                    className: widget.className,
                                    studentID: students[index]
                                        .name
                                        .replaceAll(' ', '_')
                                        .toLowerCase(),
                                    teacher: widget.teacher
                                        .replaceAll(' ', '_')
                                        .toLowerCase(),
                                    isClass: widget.isClass,
                                    user: widget.user,
                                  );
                                }));
                              },
                            ),
                            LayoutBuilder(builder: (context, constraints) {
                              if (index != students.length - 1) {
                                return Divider(
                                  indent: 20,
                                  endIndent: 20,
                                );
                              } else {
                                return Container();
                              }
                            }),
                          ],
                        ),
                      );
                    }),
              )
            ]),
          ),
          Positioned(
            bottom: 40,
            right: 30,
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: Offset(12, 12))
              ]),
              child: FloatingActionButton(
                  backgroundColor: Color(0xff78CAD2),
                  child: Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Send Announcement'),
                            content: TextField(
                                maxLines: null,
                                controller: _announcementController,
                                decoration: InputDecoration(
                                    hintText: "Type announcement...")),
                            actions: [
                              IconButton(
                                  onPressed: () async {
                                    // increment student unread messages by 1, but don't change other fields
                                    await sendAnnouncement();
                                    // Navigator.pop(conte
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => ListingsPage(
                                                className: widget.className,
                                                teacher: widget.teacher,
                                                isClass: widget.isClass,
                                                user: widget.user)));
                                  },
                                  icon: Icon(Icons.send))
                            ],
                          );
                        });
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
