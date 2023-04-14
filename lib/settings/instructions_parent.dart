import 'package:flutter/material.dart';

// This widget shows all instructions for how to use the app as a parent.
class InstructionsParent extends StatefulWidget {
  const InstructionsParent({super.key});

  @override
  State<InstructionsParent> createState() => _InstructionsParentState();
}

class _InstructionsParentState extends State<InstructionsParent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff78CAD2),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 40.0, 8.0, 0.0),
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
                        'Instructions',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )),
            Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Color(0xffF7F7F7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 20.0),
                        child: Text(
                          'Instructions',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Overview',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'The purpose of Vertex is to connect teachers, parents, and students on one platform in order to get the best education experience possible.\n',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'As a student, you have access to the following pages:\n',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: '1. Home (home icon): ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      TextSpan(
                          text:
                              'Displays your children\'s upcoming events and a list of your children.\n',
                          style: TextStyle(
                            color: Colors.black,
                          ))
                    ])),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: '2. Calendar (calendar icon): ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      TextSpan(
                          text:
                              'Displays upcoming events of activities that your children are a part of.\n',
                          style: TextStyle(
                            color: Colors.black,
                          ))
                    ])),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: '3. Settings (settings icon): ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      TextSpan(
                          text:
                              'Displays all user settings, including pronouns, terms of licensing & use, a feedback page, and so much more.\n',
                          style: TextStyle(
                            color: Colors.black,
                          ))
                    ])),
                    Text(
                      'Home Page',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'This page is meant to provide a snapshot of the events that your children are a part of and a list of all your children in one location for easy access. In this page, you will see:\n',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Upcoming Events',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                        'You will have access to up to five upcoming events for your children, prioritized by date and time. These events will have the name, description, start time, and end time of the event. An icon is also displayed to provide more information about the event. These events will be displayed on cards. You can swipe through the cards to browse through the different events.\n',
                        style: TextStyle(color: Colors.black)),
                    Text(
                      'Lists of Children',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'A list of your children will be displayed. Each list item will have the name of your child. By dragging each list item to the left, you will be presented with the option to report the absence of a particular child.\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Report Absences',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'By pressing on the report absences option for a particular child, you will be redirected to a form, where you will be asked to input information about your child\’s absence. This information will be stored and used for administrative purposes.\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Calendar Page',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'The purpose of this page is to see any upcoming events that your children are a part of. In this page, the default calendar mode will show weekly calendar events.\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Browsing Through Events',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text:
                            'You will be able to click through the different dates (switching across days, months, and even years); a subscript on the date will tell you the number of events that you have on that particular day; when you click on the date, a list of your events will show up. The events are color-coded into the following categories: ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                          text: 'NCHS events, ',
                          style: TextStyle(
                            color: Color(0xff4c2c72),
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(
                          text: 'club events, ',
                          style: TextStyle(
                            color: Color(0xfffbcf4b),
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(
                          text: 'and ',
                          style: TextStyle(
                            color: Colors.black,
                          )),
                      TextSpan(
                          text: 'sports events. ',
                          style: TextStyle(
                            color: Color(0xfffdd5566),
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(
                          text:
                              'A date that has no events will be labeled as such. To return to today’s date, you can click on the clock icon.\n',
                          style: TextStyle(
                            color: Colors.black,
                          )),
                    ])),
                    Text(
                      'Monthly Calendar View',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'As you are browsing through your various events, you may also consider viewing the events in the monthly calendar mode by clicking on the calendar icon at the top of the screen. The functionality of the calendar will still be the same.\n',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Add Activity Event',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'An add icon will be located at the bottom right corner of the screen. When you click this icon, you will be able to add an event of an activity that you are the adviser of. A form will show on the screen and you will be required to input the following information: Subject of event (which will be in the form of a dropdown menu), details of event, start time (which will display a date and time picker), and end time (which will also display a date and time picker). When you click “submit”, you will be redirected to the calendar page and your event will be displayed at the date chosen. This event will also be displayed on the students\' end if they are a part of the activity.\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Settings Page',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'The settings page is meant to provide an overview information about your account and information about Vertex. In the settings page, you will be able to view:\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Account Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'This information will be relevant to you. It will include items, such as your name, the type of person you are (“parent” in this case), and your pronouns. The only editable field is your pronouns.\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Changing Pronouns',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'You will be able to change your pronouns by being redirected to a page where you will be able to input your new pronouns. This is important because this information will be displayed to the individual being messaged.\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Help and Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'These settings will present information about our app, including our licensing & terms of use, these instructions, and a feedback page.\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Give Us Feedback',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'If you have a bug, suggestion, compliments, etc. to report you can give us feedback, which we will seriously consider. To give us feedback, you will be redirected to a new page, which will be a form. You will rate the satisfaction you have with Vertex on a scale of 0-10, pick the subject of feedback through a dropdown menu, and add an option comment. When you click the submit button, this feedback will be recorded and we will make sure to consider it.\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'The last item on this screen is the logout button. It will log you out of your account and take you back to the sign in page.\n',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
