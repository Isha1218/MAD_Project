import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad/tabs/parent_tab.dart';
import 'package:mad/tabs/student_tab.dart';
import 'package:mad/tabs/teacher_tab.dart';

// This widget will allow the user to change their pronouns if they wish to do so.
class ChangePronous extends StatefulWidget {
  const ChangePronous({Key? key, required this.person, required this.user})
      : super(key: key);

  final String person;
  final GoogleSignInAccount user;

  @override
  State<ChangePronous> createState() => _ChangePronousState();
}

class _ChangePronousState extends State<ChangePronous> {
  // This controller will represent the text field for recording the new pronouns.
  TextEditingController pronouns = TextEditingController();

  // This color will change depdending on where the focus is (on the text field or elsewhere).
  Color pronounsFocusColor = Colors.transparent;

  // This will dispay the form.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff78CAD2),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 60, 32, 2),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Pronouns',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox.expand(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.9,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New Pronouns',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          // Text field will be displayed.
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            maxLines: null,
                            controller: pronouns,
                            style: TextStyle(color: Colors.black),
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: pronounsFocusColor,
                                prefixIcon: Icon(
                                  Icons.wc,
                                  color: Color(0xff78CAD2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff78CAD2)),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff78CAD2)),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ))),
                            onChanged: (value) => setState(() {
                              if (!value.isEmpty) {
                                pronounsFocusColor =
                                    Color(0xff78CAD2).withOpacity(0.3);
                              } else {
                                pronounsFocusColor = Colors.transparent;
                              }
                            }),
                          ),
                          SizedBox(
                            height: 30,
                          ),

                          // When the user submits new pronouns, this will be updated in Firebase.
                          TextButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection(widget.person)
                                    .doc(widget.user.displayName
                                        ?.replaceAll(' ', '_')
                                        .toLowerCase())
                                    .update({'pronouns': pronouns.text});

                                if (widget.person == 'students') {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => StudentTab(
                                                  user: widget.user,
                                                  selectedIndex: 4)))
                                      .then((_) => {setState(() {})});
                                } else if (widget.person == 'parents') {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => ParentTab(
                                                  user: widget.user,
                                                  selectedIndex: 2)))
                                      .then((_) => {setState(() {})});
                                } else {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => TeacherTab(
                                                  user: widget.user,
                                                  selectedIndex: 2)))
                                      .then((_) => {setState(() {})});
                                }
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xff78CAD2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        50, 15, 50, 15),
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
