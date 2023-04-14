import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad/tabs/student_tab.dart';

// This widget will allow the user to create their own personal events.
class StudentSetEvent extends StatefulWidget {
  const StudentSetEvent({Key? key, required this.user}) : super(key: key);

  final GoogleSignInAccount user;

  @override
  State<StudentSetEvent> createState() => _StudentSetEventState();
}

class _StudentSetEventState extends State<StudentSetEvent> {
  // These are controllers for the various text fields in the form.
  TextEditingController notes = TextEditingController();
  TextEditingController subject = TextEditingController();

  late DateTime startTime;
  late DateTime endTime;

  String startTimeStr = 'Pick start time';
  String endTimeStr = 'Pick end time';

  // These colors will change depending on which fields the user has clicked.
  Color subjectFocusColor = Colors.transparent;
  Color notesFocusColor = Colors.transparent;
  Color startDateFocusColor = Colors.transparent;
  Color endDateFocusColor = Colors.transparent;

  // This function will return a widget that will take the form of a text field.
  // The text field will allow the user to input the subject of the event.
  Widget buildSubjectForm() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      maxLines: null,
      controller: subject,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      decoration: InputDecoration(
          hintText: 'e.g. Math homework...',
          border: InputBorder.none,
          filled: true,
          fillColor: subjectFocusColor,
          prefixIcon: Icon(
            Icons.assignment_add,
            color: Color(0xff78CAD2),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff78CAD2)),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff78CAD2)),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ))),
      onChanged: (value) => setState(() {
        if (!value.isEmpty) {
          subjectFocusColor = Color(0xff78CAD2).withOpacity(0.3);
        } else {
          subjectFocusColor = Colors.transparent;
        }
      }),
    );
  }

  // This function will return a widget that will take the form of a text field.
  // The text field will allow the user to input the details of the event.
  Widget buildNotesField() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      maxLines: null,
      controller: notes,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      decoration: InputDecoration(
          hintText: 'e.g. do p.512, #12, 13, 17...',
          border: InputBorder.none,
          filled: true,
          fillColor: notesFocusColor,
          prefixIcon: Icon(
            Icons.edit_note,
            size: 30,
            color: Color(0xff78CAD2),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff78CAD2)),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff78CAD2)),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ))),
      onChanged: (value) => setState(() {
        if (!value.isEmpty) {
          notesFocusColor = Color(0xff78CAD2).withOpacity(0.3);
        } else {
          notesFocusColor = Colors.transparent;
        }
      }),
    );
  }

  // This will show the date picker to the user using a Cupertino Date Picker.
  void showDatePicker(ctx, String type) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 500,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 400,
                    child: CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (val) {
                        setState(() {
                          if (type == "startTime") {
                            startTime = val;
                            startTimeStr =
                                DateFormat('MMM dd, yyyy, hh:mm a').format(val);
                          } else {
                            endTime = val;
                            endTimeStr =
                                DateFormat('MMM dd, yyyy, hh:mm a').format(val);
                          }
                        });
                      },
                    ),
                  ),
                  CupertinoButton(
                      child: Text('Close'),
                      onPressed: () => Navigator.of(ctx).pop())
                ],
              ),
            ));
  }

  // This function will return a field where the user can select the start time of the event.
  // A date picker will show up so that the user can browse through the various dates and times.
  Widget buildStartTimeField() {
    return TextButton(
      onPressed: () {
        setState(() {
          startDateFocusColor = Color(0xff78CAD2).withOpacity(0.3);
        });
        showDatePicker(context, "startTime");
      },
      child: Container(
        decoration: BoxDecoration(
            color: startDateFocusColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color(0xff78CAD2))),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: Color(0xff78CAD2),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                startTimeStr,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // This function will return a field where the user can select the end time of the event.
  // A date picker will show up so that the user can browse through the various dates and times.
  Widget buildEndTimeField() {
    return TextButton(
      onPressed: () {
        setState(() {
          endDateFocusColor = Color(0xff78CAD2).withOpacity(0.3);
        });
        showDatePicker(context, "endTime");
      },
      child: Container(
        decoration: BoxDecoration(
            color: endDateFocusColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color(0xff78CAD2))),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: Color(0xff78CAD2),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                endTimeStr,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // This will combine all of the widgets above into a fully functioning form.
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
                        'Create',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Event',
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
                            'Subject of event',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          buildSubjectForm(),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Details of event',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 10),
                          buildNotesField(),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Start Time',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          buildStartTimeField(),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Start Time',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          buildEndTimeField(),
                          SizedBox(
                            height: 30,
                          ),

                          // When submitted, this event will be added to the student's personal events
                          // through Firebase.
                          TextButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('students')
                                    .doc(widget.user.displayName!
                                        .replaceAll(' ', '_')
                                        .toLowerCase())
                                    .collection('events')
                                    .add({
                                  'endTime': endTime,
                                  'notes': notes.text,
                                  'startTime': startTime,
                                  'subject': subject.text
                                });
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StudentTab(
                                              user: widget.user,
                                              selectedIndex: 1,
                                            )));
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
                                  )))
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
