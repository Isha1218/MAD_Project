import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class RequestEvent extends StatefulWidget {
  const RequestEvent({super.key});

  @override
  State<RequestEvent> createState() => _RequestEventState();
}

class _RequestEventState extends State<RequestEvent> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController subject = TextEditingController();
  TextEditingController notes = TextEditingController();
  late DateTime startTime;
  late DateTime endTime;
  String startTimeStr = 'Pick start time';
  String endTimeStr = 'Pick end time';

  Widget buildSubjectField() {
    return TextField(
      controller: subject,
      maxLines: 1,
      decoration: InputDecoration(
        labelText: 'Club',
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 3, color: Color(0xff4C2C72)),
        ),
      ),
    );
  }

  Widget buildNotesField() {
    return TextField(
      controller: notes,
      maxLines: null,
      decoration: InputDecoration(
        labelText: 'Event Description',
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 3, color: Color(0xff4C2C72)),
        ),
      ),
    );
  }

  Widget buildStartTimeField() {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 3.0, color: Color(0xff4C2C72)))),
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              showDatePicker(context, "startTime");
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    startTimeStr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
                                DateFormat('yyyy-MM-dd hh:mm a').format(val);
                          } else {
                            endTime = val;
                            endTimeStr =
                                DateFormat('yyyy-MM-dd hh:mm a').format(val);
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

  Widget buildEndTimeField() {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 3.0, color: Color(0xff4C2C72)))),
      child: TextButton(
        onPressed: () {
          showDatePicker(context, "endTime");
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Icon(
                Icons.calendar_month_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                endTimeStr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff78CAD2),
      body: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Request an Event',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: buildSubjectField(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: buildNotesField(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 30, 16, 30),
                  child: buildStartTimeField(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 30, 16, 30),
                  child: buildEndTimeField(),
                ),
                SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                  child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: TextButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('event_requests')
                                .add({
                              'subject': subject.text,
                              'notes': notes.text,
                              'startTime': startTime,
                              'endTime': endTime,
                              'adviser': 'rhonda_mcgee',
                            });
                            Navigator.pop(context);
                          },
                          child: Text('Submit'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xff32959E),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                      )),
                )
              ],
            ),
          )),
    );
  }
}
