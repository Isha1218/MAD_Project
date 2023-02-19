// Package imports
import 'package:mad/authentication/GoogleSignInApi.dart';
import 'package:mad/authentication/google_signin.dart';
import 'package:mad/authentication/member_login_page.dart';
import 'package:mad/settings/change_pronouns.dart';
import 'package:mad/settings/policy.dart';
import 'package:mad/settings/recommendation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:google_sign_in/google_sign_in.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  const Setting({
    Key? key,
    required this.person,
    required this.user,
  }) : super(key: key);

  final String person;
  final GoogleSignInAccount user;

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  void initState() {
    super.initState();
    getPersonDocuments();
  }

  String firstName = "";
  String lastName = "";
  String pronouns = "";

  Future<void> getPersonDocuments() async {
    var studentCollection = await FirebaseFirestore.instance
        .collection(widget.person)
        .doc(widget.user.displayName?.replaceAll(' ', '_').toLowerCase());

    var docSnapshot = await studentCollection.get();
    if (docSnapshot.exists) {
      setState(() {
        Map<String, dynamic>? data = docSnapshot.data();
        firstName = data!['firstName'];
        lastName = data['lastName'];
        pronouns = data['pronouns'];

        print(firstName + ' ' + lastName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff78CAD2),
      body: SingleChildScrollView(
        // Vertical scroll
        scrollDirection: Axis.vertical,

        // Column of all elements (both blue and white parts)
        child: LayoutBuilder(builder: (context, constraints) {
          if (firstName == "" || lastName == "" || pronouns == "") {
            return Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 40.0, 8.0, 0.0),
              child: Text('Loading...'),
            );
          } else {
            return Column(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 40.0, 8.0, 0.0),
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                // JD circle (profile)
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      )),
                  child: Center(
                      child: Text(
                    firstName.substring(0, 1) + lastName.substring(0, 1),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  )),
                ),

                // Name of user
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: Text(
                    firstName + ' ' + lastName,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // White part below profile and name
                Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Color(0xffF7F7F7),
                  ),
                  child: Column(
                    children: [
                      TopThree(
                        pronouns: pronouns,
                        firstName: firstName,
                        lastName: lastName,
                        person: widget.person,
                        user: widget.user,
                      ),
                      BottomThree(),
                      Logout(),
                    ],
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}

// Top three setting features
class TopThree extends StatefulWidget {
  const TopThree({
    required this.firstName,
    required this.lastName,
    required this.pronouns,
    required this.person,
    required this.user,
    Key? key,
  }) : super(key: key);

  final firstName;
  final lastName;
  final pronouns;
  final person;
  final user;

  @override
  State<TopThree> createState() => _TopThreeState();
}

class _TopThreeState extends State<TopThree> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Heading of top three setting features
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(
            'Account Information',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Top three setting features arranged in a column
        Container(
          margin: EdgeInsets.all(15.0),
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.grey.shade300,
                )
              ]),
          child: Column(
            children: [
              Container(
                  child: Row(
                children: [
                  SettingItemsTop(
                      color: Color(0xff4C2C72),
                      settingName: 'Display Name',
                      settingDisplay:
                          (widget.firstName + ' ' + widget.lastName),
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      )),
                ],
              )),
              Divider(),
              Container(
                  child: Row(
                children: [
                  SettingItemsTop(
                      color: Color(0xffFFD863),
                      settingName: 'Person',
                      settingDisplay: (widget.person
                              .substring(0, 1)
                              .toUpperCase() +
                          widget.person.substring(1, widget.person.length - 1)),
                      icon: Icon(
                        Icons.school,
                        color: Colors.white,
                      )),
                ],
              )),
              Divider(),
              Container(
                child: Column(children: [
                  Container(
                      child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: SettingItemsTop(
                            color: Color(0xffD56AA0),
                            settingName: 'Pronouns',
                            settingDisplay: widget.pronouns,
                            icon: Icon(
                              Icons.transgender_rounded,
                              color: Colors.white,
                            )),
                      ),
                      Expanded(
                        flex: 4,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePronous(
                                        person: widget.person,
                                        user: widget.user,
                                      )),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffBEBEBE),
                                borderRadius: BorderRadius.circular(5.0)),
                            width: 70.0,
                            height: 30.0,
                            padding: EdgeInsets.all(5),
                            child: Center(
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
                ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Bottom three setting features
class BottomThree extends StatefulWidget {
  const BottomThree({super.key});

  @override
  State<BottomThree> createState() => _BottomThreeState();
}

class _BottomThreeState extends State<BottomThree> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Heading
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(
            'Help and Permissions',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Features arranged in columns
        Container(
          margin: EdgeInsets.all(15.0),
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.grey.shade300,
                )
              ]),
          child: Column(
            children: [
              Container(
                  child: TextButton(
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: SettingItemsBottom(
                          icon: Icon(
                            Icons.article,
                            color: Colors.white,
                          ),
                          item: 'View Licensing & Terms of Use',
                          color: Color(0xff4C2C72)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(Icons.arrow_forward_ios_rounded,
                          color: Color(0xffBEBEBE)),
                    )
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Policy()),
                  );
                },
              )),
              Divider(),
              Container(
                child: Column(children: [
                  Container(
                      child: TextButton(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: SettingItemsBottom(
                              icon: Icon(
                                Icons.question_mark,
                                color: Colors.white,
                              ),
                              item: 'Help',
                              color: Color(0xffFFD863)),
                        ),
                        Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(0xffBEBEBE),
                            ))
                      ],
                    ),
                    onPressed: () {},
                  )),
                  Divider(),
                  Container(
                      child: Container(
                          child: TextButton(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: SettingItemsBottom(
                              icon: Icon(
                                Icons.feedback,
                                color: Colors.white,
                              ),
                              item: 'Give us Feedback',
                              color: Color(0xffD56AA0)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Color(0xffBEBEBE),
                          ),
                        )
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Recommendation()),
                      );
                    },
                  )))
                ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Each setting feature arranged in certain way for top three setting tiems
class SettingItemsTop extends StatelessWidget {
  final Color color;
  final String settingName;
  final String settingDisplay;
  final Icon icon;

  const SettingItemsTop({
    Key? key,
    required this.color,
    required this.settingName,
    required this.settingDisplay,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              child: icon,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: color,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(this.settingName,
                    style: TextStyle(
                      fontSize: 15.0,
                    )),
                Text(this.settingDisplay,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ],
        ));
  }
}

// Each setting feature arranged in certain way for bottom three setting tiems
class SettingItemsBottom extends StatelessWidget {
  final Icon icon;
  final String item;
  final Color color;

  const SettingItemsBottom({
    Key? key,
    required this.icon,
    required this.item,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Container(
            child: icon,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color,
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Container(
            width: 150,
            child: Text(this.item,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                )),
          )
        ],
      ),
    );
  }
}

// Logout at the very end
class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Heading
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(
            'Logout',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Row of the setting feature
        Container(
          margin: EdgeInsets.all(15.0),
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.grey.shade300,
                )
              ]),
          child: TextButton(
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: SettingItemsBottom(
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                      item: 'Logout',
                      color: Color(0xff78CAD2)),
                ),
                Expanded(
                  flex: 1,
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      color: Color(0xffBEBEBE)),
                ),
              ],
            ),
            onPressed: () async {
              await GoogleSignInApi.logout();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MemberLoginPage()));
            },
          ),
        )
      ],
    );
  }
}
