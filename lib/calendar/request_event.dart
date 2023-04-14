import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad/tabs/teacher_tab.dart';

// This widget will allow teachers only to set events for activities that they are the advisers of.
class RequestEvent extends StatefulWidget {
  const RequestEvent({Key? key, required this.user}) : super(key: key);

  final GoogleSignInAccount user;

  @override
  State<RequestEvent> createState() => _RequestEventState();
}

class _RequestEventState extends State<RequestEvent> {
  // This will retrieve all clubs that the teacher is the adviser of
  @override
  void initState() {
    super.initState();
    retrieveClubs();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // This will be the value selected from the dropdown menu.
  String? selectedValue = null;

  // This will be the textfield that the teacher will use to set the description of the event.
  TextEditingController description = TextEditingController();

  late DateTime startTime;
  late DateTime endTime;

  String startTimeStr = 'Pick start time';
  String endTimeStr = 'Pick end time';

  // Focus colors will change, depending on whether the user has clicked on a particular field.
  Color activityFocusColor = Colors.transparent;
  Color descriptionFocusColor = Colors.transparent;
  Color startDateFocusColor = Colors.transparent;
  Color endDateFocusColor = Colors.transparent;

  // This list will contain all of the clubs that the teacher is an adviser of.
  // These clubs will be displayed in the dropdown menu.
  late List<DropdownMenuItem<String>> clubsOwned = [];

  // This function will retrieve all the clubs that the teacher is an adviser of and add it to the list.
  Future<void> retrieveClubs() async {
    // The teacher's collection in Firebase will be accessed and all of their activities will be added to the list.
    await FirebaseFirestore.instance
        .collection('teachers')
        .doc(widget.user.displayName?.replaceAll(' ', '_').toLowerCase())
        .collection('activities')
        .get()
        .then((value) => {
              value.docs.forEach((element) async {
                String activityCollectionRef = 'activities';
                String activityDocRef = element.data()['clubRef'].split("/")[1];

                var activityCollection = await FirebaseFirestore.instance
                    .collection(activityCollectionRef)
                    .doc(activityDocRef);

                var docSnapshot = await activityCollection.get();
                if (docSnapshot.exists) {
                  setState(() {
                    clubsOwned.add(DropdownMenuItem(
                        child: Text(docSnapshot.data()!['name']),
                        value: docSnapshot.data()!['name']));
                  });
                }
              })
            });
  }

  // This function will return a dropdown menu widget, containing all of the activities that
  // the teacher is a part of. The teacher can select these menu items.
  Widget buildAcitvityForm() {
    return DropdownButtonFormField(
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            hintText: 'Activities',
            border: InputBorder.none,
            filled: true,
            fillColor: activityFocusColor,
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
        validator: (value) => value == null ? "Select a reason" : null,
        dropdownColor: Colors.white,

        // The selected value will be changed depending on what the teacher clicks in the dropdown menu.
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue!;
            activityFocusColor = Color(0xff78CAD2).withOpacity(0.3);
          });
        },
        items: clubsOwned);
  }

  // This function will display a text field, so that the teacher can input the description of the event.
  Widget buildDescriptionForm() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      maxLines: null,
      controller: description,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      decoration: InputDecoration(
          hintText: 'e.g. Club meeting',
          border: InputBorder.none,
          filled: true,
          fillColor: descriptionFocusColor,
          prefixIcon: Icon(
            Icons.edit_note,
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
          descriptionFocusColor = Color(0xff78CAD2).withOpacity(0.3);
        } else {
          descriptionFocusColor = Colors.transparent;
        }
      }),
    );
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
                                DateFormat('MMM dd, yyyy  hh:mm a').format(val);
                          } else {
                            endTime = val;
                            endTimeStr =
                                DateFormat('MMM dd, yyyy  hh:mm a').format(val);
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

  // This will combine all of the widgets above into a fully functioning form.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff78CAD2),
        body: LayoutBuilder(builder: (context, constraints) {
          // Progress circle will show when the owned clubs haven't been loaded.
          if (clubsOwned.length == 0) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );

            // Otherwise, a form will be displayed for the teacher to input this information.
          } else {
            return Column(
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
                                  'Select Activity',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                buildAcitvityForm(),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  'Select Activity',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                buildDescriptionForm(),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  'Select Start Time',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                buildStartTimeField(),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  'Select End Time',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                buildEndTimeField(),
                                SizedBox(
                                  height: 30,
                                ),

                                // When submitted, this event will be added to the activity that the teacher selected
                                // through Firebase.
                                TextButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('activities')
                                          .doc(selectedValue!
                                              .replaceAll(' ', '_')
                                              .toLowerCase())
                                          .collection('events')
                                          .add({
                                        'endTime': endTime,
                                        'notes': description.text,
                                        'startTime': startTime,
                                      });
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => TeacherTab(
                                                  user: widget.user,
                                                  selectedIndex: 1)));
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xff78CAD2),
                                          borderRadius:
                                              BorderRadius.circular(10),
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
            );
          }
        }));
  }
}
