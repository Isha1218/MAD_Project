import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad/authentication/GoogleSignInApi.dart';
import 'package:mad/settings/settings.dart';

class ChangePronous extends StatefulWidget {
  const ChangePronous({Key? key, required this.person, required this.user})
      : super(key: key);

  final String person;
  final GoogleSignInAccount user;

  @override
  State<ChangePronous> createState() => _ChangePronousState();
}

class _ChangePronousState extends State<ChangePronous> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff78CAD2),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  Text(
                    'Change Pronouns',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.fromLTRB(40.0, 0, 40.0, 75.0),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: 'Pronouns',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  hintText: 'Enter your pronouns',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(40.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      // change firestore value
                      FirebaseFirestore.instance
                          .collection(widget.person)
                          .doc(widget.user.displayName
                              ?.replaceAll(' ', '_')
                              .toLowerCase())
                          .update({'pronouns': textController.text});
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Setting(
                                      person: widget.person,
                                      user: widget.user)))
                          .then((_) => {setState(() {})});
                    },
                    child: Text('Submit'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xff32959E),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                )),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
