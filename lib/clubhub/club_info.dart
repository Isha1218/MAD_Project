import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mad/tabs/student_tab.dart';
import '../classes/activity.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

// This widget will display the info about each individual club when the user
// selects on it.
class ClubInfo extends StatefulWidget {
  const ClubInfo({
    super.key,
    required this.activity,
    required this.icon,
    required this.joined,
    required this.user,
  });

  final Activity activity;
  final Icon icon;

  final bool joined;
  final GoogleSignInAccount user;

  @override
  State<ClubInfo> createState() => _ClubInfoState();
}

// The information is displayed as a column.
// Several necessary components are displayed to the user.
class _ClubInfoState extends State<ClubInfo> {
  late WebViewController controllerInstagram;
  late WebViewController controllerRemind;

  @override
  void initState() {
    controllerInstagram = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
          Uri.parse('https://www.instagram.com/' + widget.activity.instagram));

    controllerRemind = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
          Uri.parse('https://www.remind.com/join/' + widget.activity.remind));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 1.2),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 75, 32, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back arrow
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios),
                    ),

                    // Icon to represent club
                    Center(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade200,
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                      offset: Offset(0, 5))
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(
                                widget.icon.icon,
                                size: 80,
                                color: widget.activity.color,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          // Name of activity
                          Text(
                            widget.activity.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),

                          // Name of adviser
                          Text(
                            'Adviser: ' + widget.activity.adviser,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                size: 18,
                                color: Color(0xff4C2C72),
                              ),
                              SizedBox(
                                width: 3,
                              ),

                              // Number of members
                              Text(
                                widget.activity.members.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '  /  ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.room,
                                size: 18,
                                color: Color(0xff78CAD2),
                              ),
                              SizedBox(
                                width: 3,
                              ),

                              // Room number of activity
                              Text(
                                widget.activity.room,
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          // List of all tags displayed in a row.
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  widget.activity.tags.split(',').length,
                                  (index) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xff4C2C72),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          widget.activity.tags
                                              .split(', ')[index],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Description',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  // Contains the description of the activity
                                  Text(
                                    widget.activity.description,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Achievements',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.workspace_premium,
                                        color:
                                            Color.fromARGB(255, 216, 166, 14),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  // Contains a list of the club's achievements.
                                  Column(
                                    children: List.generate(
                                        widget.activity.achievements.length,
                                        (index) {
                                      return Column(
                                        children: [
                                          Text(
                                            '\u2022 ' +
                                                widget.activity
                                                    .achievements[index],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          )
                                        ],
                                      );
                                    }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Displays Instagram of the club when clicked and allows user to join the club
          // if not already joined.
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    TextButton(
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  Instagram(controller: controllerInstagram)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FaIcon(FontAwesomeIcons.instagram,
                              size: 60, color: Color(0xff78CAD2)),
                        )),
                    Expanded(
                      child: LayoutBuilder(builder: (context, constraints) {
                        if (widget.joined) {
                          return Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: Color(0xff78CAD2),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text(
                                'Already Joined',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: Color(0xff78CAD2),
                                borderRadius: BorderRadius.circular(20)),
                            child: TextButton(
                              // When the user wants to join, the activity will be added to the student's
                              // activity collection.
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('students')
                                    .doc(widget.user.displayName
                                        ?.replaceAll(' ', '_')
                                        .toLowerCase())
                                    .collection('activities')
                                    .doc(widget.activity.name
                                        .replaceAll(' ', '_')
                                        .toLowerCase())
                                    .set({
                                  'clubRef': 'activities/' +
                                      widget.activity.name
                                          .replaceAll(' ', '_')
                                          .toLowerCase()
                                });

                                // Add student to activities collection, so they can message with teacher
                                await FirebaseFirestore.instance
                                    .collection('activities')
                                    .doc(widget.activity.name
                                        .replaceAll(' ', '_')
                                        .toLowerCase())
                                    .collection('students')
                                    .doc(widget.user.displayName!
                                        .replaceAll(' ', '_')
                                        .toLowerCase())
                                    .set({'name': widget.user.displayName});

                                // Update members
                                var activitySnapshot = await FirebaseFirestore
                                    .instance
                                    .collection('activities')
                                    .doc(widget.activity.name
                                        .replaceAll(' ', '_')
                                        .toLowerCase())
                                    .get();
                                int members = 0;
                                if (activitySnapshot.exists) {
                                  members = activitySnapshot.data()!['members'];
                                }

                                await FirebaseFirestore.instance
                                    .collection('activities')
                                    .doc(widget.activity.name
                                        .replaceAll(' ', '_')
                                        .toLowerCase())
                                    .update({'members': members + 1});

                                // A pop up box will ask the user if they have already joined the remind.
                                // If the user has not already joined the remind, they can do so.
                                if (widget.activity.remind != '') {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            widget.activity.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: Text(
                                              'Have you joined Remind for ' +
                                                  widget.activity.name +
                                                  ' yet?'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              StudentTab(
                                                                  user: widget
                                                                      .user,
                                                                  selectedIndex:
                                                                      2)));
                                                },
                                                child: Text('Already Joined')),
                                            TextButton(
                                                onPressed: () async {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              Instagram(
                                                                  controller:
                                                                      controllerRemind)));
                                                },
                                                child: Text('Join Remind'))
                                          ],
                                        );
                                      });
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => StudentTab(
                                              user: widget.user,
                                              selectedIndex: 2)));
                                }
                              },
                              child: Text(
                                'Join ' + widget.activity.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Instagram extends StatefulWidget {
  const Instagram({super.key, required this.controller});

  final WebViewController controller;

  @override
  State<Instagram> createState() => _InstagramState();
}

class _InstagramState extends State<Instagram> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff78CAD2),
        title: Text('Vertex'),
      ),
      body: WebViewWidget(controller: widget.controller),
    );
  }
}
