import "package:chat_bubbles/chat_bubbles.dart";
import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mad/messaging/teacher_messages.dart';

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
  }) : super(key: key);
  final String className;
  final String teacher;
  final bool isClass;

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  // This controller contains text from an announcements.
  final TextEditingController _announcementController = TextEditingController();

  // This list contains the all students' names in the class
  List<String> students = [];

  // Initalized the name and period (none if club) of the class/club through Firebase
  String schoolClassName = '';
  int period = 0;

  // This gets all of the students in the class and the club/class name when the screen initializes.
  @override
  void initState() {
    print('in init');
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
                  print('in hereeee');
                  setState(() {
                    students.add(element.data()['name']);
                  });
                } else {
                  print('nonexistent');
                }
              })
            });
  }

  // This will send an announcement by setting the announcement in Firebase.
  void sendAnnouncement() {
    print('announcement: ' + _announcementController.text);
    var data;

    String id;
    for (int index = 0; index < students.length; index++) {
      id = students[index].replaceAll(' ', '_').toLowerCase();

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
              students[index].replaceAll(' ', '_').toLowerCase() +
              widget.className)
          .collection('messages')
          .doc();

      ref.set(data);
    }
    _announcementController.clear();
  }

  // This will display the students' list and the send announcements button
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        toolbarHeight: 100,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff78CAD2),
        title: LayoutBuilder(builder: (context, constraints) {
          if (widget.isClass) {
            return Column(
              children: [
                Text(
                  schoolClassName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Period ' + period.toString(),
                  style: TextStyle(
                    color: Color(0xffF7F7F7),
                    fontSize: 18,
                  ),
                )
              ],
            );
          } else {
            return Text(
              schoolClassName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            );
          }
        }),
      ),
      backgroundColor: Color(0xffF7F7F7),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("ANNOUNCEMENTS",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),

          // This will allow the teacher to send an announcement.
          ListTile(
            minVerticalPadding: 20,
            trailing: IconButton(
              icon: Icon(
                Icons.add_circle,
                color: Colors.black,
              ),

              // When the user adds an announcement, they will be able to type an announcement in the text field.
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
                              onPressed: () {
                                sendAnnouncement();
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.send))
                        ],
                      );
                    });
              },
            ),
            title: Text(widget.isClass
                ? schoolClassName + ' (Period ' + period.toString() + ')'
                : schoolClassName),
            tileColor: Colors.white,
            subtitle: Text("Send Announcement"),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text("STUDENTS", style: TextStyle(fontWeight: FontWeight.bold)),
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
                    color: Colors.white,
                    child: Column(
                      children: [
                        ListTile(
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.grey,
                          ),
                          tileColor: Colors.white,
                          textColor: Colors.black,
                          title: Text(students[index]),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TeacherMessagesPage(
                                      className: widget.className,
                                      studentID: students[index]
                                          .replaceAll(' ', '_')
                                          .toLowerCase(),
                                      teacher: widget.teacher
                                          .replaceAll(' ', '_')
                                          .toLowerCase(),
                                      isClass: widget.isClass,
                                    )));
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
    );
  }
}

class MessagesPage extends StatefulWidget {
  const MessagesPage(
      {Key? key,
      required this.className,
      required this.teacher,
      required this.studentID})
      : super(key: key);

  final String className;
  final String teacher;
  final String studentID;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

final TextEditingController _textController = TextEditingController();
final ScrollController _scrollController = ScrollController();
File? imageFile;

class _MessagesPageState extends State<MessagesPage> {
  Widget buildInputBox() {
    return Material(
      child: Row(children: [
        IconButton(
          icon: Icon(Icons.add),

          //images
          onPressed: () {},
        ),
        Expanded(
            child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  helperText: "Enter your message",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                ))),
        IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              //clear textcontroller
              //call send message function
              String message = _textController.text;
              _textController.clear();
              sendMessage(message, 0);
            })
      ]),
    );
  }

//get image
  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      //uploadFile();
    }
  }

//load previous messages
  Widget loadMessages() {
    return StreamBuilder(
        stream: db
            .collection('conversations')
            .doc(widget.teacher + widget.studentID + widget.className)
            .collection('messages')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.size,
              itemBuilder: (context, index) =>
                  buildItem(snapshot.data?.docs[index]),
              reverse: true,
            );
          } else {
            return Center(child: Text("Be the first to send a message!"));
          }
        });
  }

//build invididual message bubble
//add is Image chain
  Widget buildItem(QueryDocumentSnapshot<Map<String, dynamic>>? document) {
    if (document?.get('reciever') == widget.studentID) {
      if (document?.get('announcement')) {
        return Column(children: [
          Text("Announcement", style: TextStyle(fontSize: 30)),
          BubbleNormal(
              text: document?.get('content'),
              color: Color.fromRGBO(120, 202, 210, 1),
              tail: true,
              isSender: true)
        ]);
      }
      return BubbleNormal(
          text: document?.get('content'),
          color: Color.fromRGBO(120, 202, 210, 1),
          tail: true,
          isSender: true);
    } else {
      return BubbleNormal(
          text: document?.get('content'),
          color: Colors.grey,
          tail: true,
          isSender: false);
    }
  }

//handle sending messages including images
//0 is text
//1 is image
  BubbleNormal sendMessage(String content, int type) {
    final data;
    if (type == 0) {
      data = {
        'className': widget.className,
        'content': content,
        'isImage': false,
        'reciever': widget.teacher,
        'sender': widget.studentID,
        'timeSent': Timestamp.now()
      };
    } else {
      data = {
        'className': widget.className,
        'content': content,
        'isImage': true,
        'reciever': widget.teacher,
        'sender': widget.studentID,
        'timeSent': Timestamp.now()
      };
    }

    final ref = db
        .collection('conversations')
        .doc(widget.teacher + widget.studentID + widget.className)
        .collection('messages')
        .doc();

    ref.set(data);

    return BubbleNormal(
        text: data['content'],
        isSender: true,
        color: Color.fromRGBO(120, 202, 210, 1),
        tail: true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[loadMessages(), buildInputBox()]);
  }
}
