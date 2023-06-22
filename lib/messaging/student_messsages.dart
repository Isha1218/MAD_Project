import "package:chat_bubbles/chat_bubbles.dart";
import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../tabs/student_tab.dart';
import 'package:intl/intl.dart';

// Initializes Firestore database
var db = FirebaseFirestore.instance;

// This class displays the messaging page to the student.
// The student can directly interact with a teacher via text and messages.
class MessagesPage extends StatefulWidget {
  const MessagesPage({
    Key? key,
    required this.className,
    required this.teacher,
    required this.studentID,
    required this.isClass,
    required this.user,
  }) : super(key: key);

  final String className;
  final String teacher;
  final String studentID;
  final bool isClass;
  final GoogleSignInAccount user;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  // This controller keeps track of the text that the user messages
  final TextEditingController _textController = TextEditingController();

  // This controller makes sure to scroll to the bottom after every text message
  final ScrollController _scrollController = ScrollController();

  // This file contains an image that the user chooses from the image picker.
  File? imageFile;

  // This is the file name of the image picked
  String fileName = "";

  // This is the url of the image to display the image
  String imageUrl = '';

  // This is the url of the image to display the image
  List imageUrls = [];

  //Multiple Images
  List<File> selectedImages = [];

  // This is the name of the teacher initialized in Firebase
  String teacherName = '';

  // This checks whether the user has chosen an image
  bool isPhoto = false;

  // This is the name of the class/club that user has selected
  String schoolClassName = '';

  // This is the class period (this will be 0 for a club)
  int period = 0;

  // If the focus on the text field changes, the color of the text field will change as well.
  Color detailFocusColor = Colors.transparent;

  // This function will get the teacher's name from Firebase by accessing the teachers collection.
  Future<void> getTeacherName() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('teachers')
        .doc(widget.teacher)
        .get();

    if (snapshot.exists) {
      setState(() {
        teacherName =
            snapshot.data()!['firstName'] + ' ' + snapshot.data()!['lastName'];
      });
    }
  }

  // This function will get the club's name from Firebase by accessing the activities collection
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

  // This function will get the class's name from Firebase by accessing the classes collection
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

  // This will get the messages, teacher's name, and class/club name, when the page initializes.
  @override
  void initState() {
    loadMessages();
    getTeacherName();
    if (widget.isClass) {
      getClassName();
    } else {
      getClubName();
    }
    super.initState();
  }

  //Show the sheet with attachment options
  showAttachmentSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 15.0),
                child: ListTile(
                    leading: Icon(Icons.image),
                    title: Text('Image'),
                    onTap: () async {
                      Navigator.pop(context);
                      await uploadImage(false);
                    }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 15.0),
                child: ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('Camera'),
                    onTap: () async {
                      Navigator.pop(context);
                      await uploadImage(true);
                    }),
              )
            ],
          ));
        });
  }

  Future<void> uploadImage(bool camera) async {
    setState(() {
      isPhoto = true;
    });
    print("the value of isPhoto: " + isPhoto.toString());
    // Pick image from gallery
    ImagePicker picker = ImagePicker();
    XFile? image;

    if (!camera) {
      //image = await picker.pickImage(source: ImageSource.gallery);
      final pickedFiles =
          await picker.pickMultiImage(maxHeight: 1000, maxWidth: 1000);
      List<XFile> xFilePick = pickedFiles;

      //if at least one photo is selected, it will add to the list
      if (xFilePick.isNotEmpty) {
        print("inside if statement at 489");
        for (var index = 0; index < xFilePick.length; index++) {
          setState(() {
            selectedImages.add(File(xFilePick[index].path));
          });
        }

        print("this is the length of selectedImages: " +
            selectedImages.length.toString());
      }
    } else {
      image = await picker.pickImage(source: ImageSource.camera);

      setState(() {
        selectedImages.add(File(image!.path));
      });

      // Check if image null
      if (image == null) {
        //print('image is null');
        return;
      }
    }

    for (int index = 0; index < selectedImages.length; index++) {
      //Timestamp for unique name for image
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Upload to Firebase storage
      //Get a reference to storage
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('messageImages');

      // Create reference for image to be stored
      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueFileName);

      // Handle error/success
      try {
        //Store the file
        await referenceImageToUpload.putFile(selectedImages[index]);

        //get download URL
        var downloadUrl = await referenceImageToUpload.getDownloadURL();
        setState(() {
          imageUrls.add(downloadUrl);
        });

        // Navigator.pop(context as BuildContext);
      } catch (error) {}
    }
    print("this is the length of imageUrls at 590!: " +
        imageUrls.length.toString());
  }

  // This is the text box widget at the bottom of the screen.
  Widget buildInputBox() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: Material(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))),
          elevation: 60,
          shadowColor: Colors.grey,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 32),
            child: Row(children: [
              LayoutBuilder(builder: (context, constraints) {
                // If user has not selected photo, the add button will be present
                if (!isPhoto) {
                  return IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.grey,
                    ),

                    // The user will need to give permission to access images
                    onPressed: () {
                      showAttachmentSheet(context);
                      () async {
                        var _permissionStatus = await Permission.storage.status;

                        //should allow user to grant permission to image gallery
                        if (_permissionStatus != PermissionStatus.granted) {
                          PermissionStatus permissionStatus =
                              await Permission.storage.request();
                          setState(() {
                            _permissionStatus = permissionStatus;
                          });
                        }
                      }();
                      // uploadImage();
                    },
                  );

                  // Otherwise, there will be a close icon to remove the image
                } else {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        isPhoto = false;
                      });
                    },
                    icon: Icon(Icons.close),
                  );
                }
              }),
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  // If the user has not selected a photo, a text field will show for the user to type
                  // as message.
                  if (!isPhoto) {
                    return TextFormField(
                      textInputAction: TextInputAction.done,
                      maxLines: null,
                      controller: _textController,
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          hintText: 'Enter message here...',
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Color(0xffF7F7F7),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ))),
                    );

                    // If the user has selected an image, the image will show in a container and the text field
                    // won't show up.
                  } else {
                    if (imageUrls.length == 1) {
                      return Container(
                        height: 110,
                        width: 110,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(imageUrls[0])),
                      );
                    } else if (imageUrls.length > 1) {
                      //multiple images

                      print("imageUrls length at 272: " +
                          imageUrls.length.toString());
                      return Container(
                          child: SingleChildScrollView(
                              child: Column(
                        children: [
                          SizedBox(
                              height: 140,
                              child: ListView.builder(
                                  itemCount: imageUrls.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    //print(imageUrls[index].toString());
                                    return Container(
                                      height: 140,
                                      width: 140,
                                      margin: EdgeInsets.all(10),
                                      child: ClipRRect(
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.network(imageUrls[index],
                                                fit: BoxFit.cover),
                                            Positioned(
                                                right: 4,
                                                top: 5,
                                                child: IconButton(
                                                  onPressed: () {
                                                    //Deletes images from list and ListView
                                                    imageUrls.removeAt(index);
                                                    setState(() {});
                                                  },
                                                  icon:
                                                      Icon(Icons.remove_circle),
                                                  color: Colors.black,
                                                ))
                                          ],
                                        ),
                                      ),
                                    );
                                  }))
                        ],
                      )));
                    } else {
                      return LinearProgressIndicator();
                    }
                  }
                }),
              ),
              SizedBox(width: 10),

              // When the send button is clicked, either the message or the image will be
              // added to Firebase and Firebase Storage and show up in the display.
              FloatingActionButton(
                  elevation: 0,
                  backgroundColor: Color(0xff78CAD2),
                  child: Icon(Icons.send, size: 20),
                  onPressed: () async {
                    if (!isPhoto) {
                      print("in wrong place");
                      String message = _textController.text;
                      print('message: ' + message);
                      sendMessage(message);
                      _textController.clear();
                      loadMessages();

                      //will be a photo
                    } else {
                      print('in photo');
                      //send an image!

                      for (int index = 0; index < imageUrls.length; index++) {
                        await setImageData(index);
                        //sendImage(index);
                      }
                      setState(() {
                        print("image url when send!: " +
                            imageUrls.length.toString());

                        isPhoto = false;
                        selectedImages.clear();
                        imageUrls.clear();
                      });

                      // print("now the length should be 0: " +
                      // selectedImages.length.toString();
                    }
                  }),
              SizedBox(
                width: 10,
              )
            ]),
          ),
        ),
      ),
    );
  }

  // This will return an image in a chat bubble based on an image url.
  Widget sendImage() {
    return BubbleNormalImage(
      id: '',
      image: Image.network(imageUrl),
      isSender: true,
    );
  }

  // This will set the image data in Firebase, so that it can be later retrieved.
  // It is set in the messages collection, which is in the conversations collection.
  Future<void> setImageData(int index) async {
    CollectionReference imageMessageRef = await db
        .collection("conversations")
        .doc(widget.teacher + widget.studentID + widget.className)
        .collection('messages');

    var data = {
      'className': widget.className,
      'content': imageUrls[index],
      'isImage': true,
      'announcement': false,
      'reciever': widget.teacher,
      'sender': widget.studentID,
      'timeSent': Timestamp.now()
    };

    imageMessageRef.add(data);

    var messageSnapshot = await db
        .collection('conversations')
        .doc(widget.teacher + widget.studentID + widget.className)
        .get();

    int messages = 0;
    if (messageSnapshot.exists) {
      messages = messageSnapshot['teacherUnreadMessages'];
    }

    db
        .collection('conversations')
        .doc(widget.teacher + widget.studentID + widget.className)
        .set({
      'lastMessage': 'Photo sent',
      'teacherUnreadMessages': messages + 1,
      'studentUnreadMessages': 0,
      'lastMessageDate': DateTime.now(),
    });
  }

  // This function load previous messages using a StreamBuilder.
  // A StreamBuilder is used because this is happening in real time.
  Widget loadMessages() {
    print('in load messages');
    return StreamBuilder(
        stream: db
            .collection('conversations')
            .doc(widget.teacher + widget.studentID + widget.className)
            .collection('messages')
            .orderBy('timeSent')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('snapshot has data');
            print('not waiting');
            print(snapshot.data?.size);
            return Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 100),
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data?.size,
                  itemBuilder: (context, index) {
                    return buildItem(snapshot.data?.docs[index]);
                  }),
            );
          } else {
            return Text("Be the first to send a message");
          }
        });
  }

  // This will build an invididual message bubble using the Chat Bubbles package.
  Widget buildItem(QueryDocumentSnapshot<Map<String, dynamic>>? document) {
    DateTime messageSent = document?.get('timeSent').toDate();
    String messageSentString = getMessageSentString(messageSent);
    if (document?.get('isImage')) {
      if (document?.get('sender') == widget.studentID) {
        final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BubbleNormalImage(
                  color: Colors.transparent,
                  id: '',
                  isSender: true,
                  image: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      child: Image.network(
                        document?.get('content'),
                        cacheHeight: (MediaQuery.of(context).size.height *
                                devicePixelRatio)
                            .round(),
                      ))),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  messageSentString,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
        );
      } else {
        final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BubbleNormalImage(
                  color: Colors.transparent,
                  id: "",
                  isSender: false,
                  image: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(12)),
                      child: Image.network(document?.get('content'),
                          cacheHeight: (MediaQuery.of(context).size.height *
                                  devicePixelRatio)
                              .round()))),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text(
                  messageSentString,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
        );
      }
    } else {
      if (document?.get('sender') == widget.studentID) {
        print('sending 2');
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BubbleNormal(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  bubbleRadius: 12,
                  text: document?.get('content'),
                  color: Color.fromRGBO(120, 202, 210, 1),
                  tail: true,
                  isSender: true),
              Padding(
                padding: const EdgeInsets.only(right: 16, top: 4),
                child: Text(
                  messageSentString,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
        );
      } else {
        DateTime messageSent = document?.get('timeSent').toDate();
        String messageSentString = getMessageSentString(messageSent);
        if (document?.get('announcement')) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 8),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xff78CAD2),
                    child: Icon(
                      Icons.announcement,
                      color: Color(0xffF7F7F7),
                      size: 20,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BubbleNormal(
                        bubbleRadius: 12,
                        textStyle: TextStyle(
                          color: Colors.black.withOpacity(0.75),
                          fontSize: 18,
                        ),
                        text: document?.get('content'),
                        color: Color(0xffF7F7F7),
                        tail: true,
                        isSender: false),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Text(
                        messageSentString,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BubbleNormal(
                    bubbleRadius: 12,
                    textStyle: TextStyle(
                      color: Colors.black.withOpacity(0.75),
                      fontSize: 18,
                    ),
                    text: document?.get('content'),
                    color: Color(0xffF7F7F7),
                    tail: true,
                    isSender: false),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    messageSentString,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),
          );
        }
      }
    }
  }

  String getMessageSentString(DateTime messageSent) {
    String messageSentString = '';
    if (messageSent.difference(DateTime.now()).inDays == 0) {
      messageSentString = DateFormat('hh:mm a').format(messageSent);
    } else if (messageSent.difference(DateTime.now()).inDays < 7) {
      messageSentString = DateFormat('EEE, hh:mm a').format(messageSent);
    } else {
      messageSentString = DateFormat('M/d/y').format(messageSent);
    }
    return messageSentString;
  }

  // This will handle sending messages by setting it in Firestore.
  void sendMessage(String content) async {
    final data;
    data = {
      'className': widget.className,
      'content': content,
      'isImage': false,
      'announcement': false,
      'reciever': widget.teacher,
      'sender': widget.studentID,
      'timeSent': Timestamp.now()
    };

    final ref = db
        .collection('conversations')
        .doc(widget.teacher + widget.studentID + widget.className)
        .collection('messages')
        .doc();

    if (_textController.text != '') {
      var messageSnapshot = await db
          .collection('conversations')
          .doc(widget.teacher + widget.studentID + widget.className)
          .get();
      int messages = 0;
      if (messageSnapshot.exists &&
          messageSnapshot.data()!.containsKey('teacherUnreadMessages')) {
        messages = messageSnapshot['teacherUnreadMessages'];
      }
      ref.set(data);
      db
          .collection('conversations')
          .doc(widget.teacher + widget.studentID + widget.className)
          .set({
        'lastMessage': content,
        'teacherUnreadMessages': messages + 1,
        'studentUnreadMessages': 0,
        'lastMessageDate': DateTime.now(),
      });
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }

    setState(() {
      detailFocusColor = Colors.transparent;
    });
  }

  // This will display the messages and text field
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          toolbarHeight: 100,
          elevation: 15,
          shadowColor: Color(0xffFEFEFE),
          leading: Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
              onPressed: () async {
                var conversationSnapshot = await db
                    .collection('conversations')
                    .doc(widget.teacher + widget.studentID + widget.className)
                    .get();
                if (conversationSnapshot.exists) {
                  db
                      .collection('conversations')
                      .doc(widget.teacher + widget.studentID + widget.className)
                      .set({
                    'lastMessage': conversationSnapshot.data()!['lastMessage'],
                    'lastMessageDate':
                        conversationSnapshot.data()!['lastMessageDate'],
                    'studentUnreadMessages': 0,
                    'teacherUnreadMessages':
                        conversationSnapshot.data()!['teacherUnreadMessages']
                  });
                }

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudentTab(
                              user: widget.user,
                              selectedIndex: 0,
                            )));
              },
            ),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: 25,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 23,
                  child: Text(
                    widget.teacher.split('_')[0].substring(0, 1).toUpperCase() +
                        widget.teacher
                            .split('_')[1]
                            .substring(0, 1)
                            .toUpperCase(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Text(
                      widget.isClass
                          ? schoolClassName + ' (P' + period.toString() + ')'
                          : schoolClassName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    teacherName,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xffFEFEFE),
        body: Stack(children: <Widget>[
          loadMessages(),
          buildInputBox(),
        ]));
  }
}
