import 'package:flutter/material.dart';

// This widget shows all instructions for how to use the app as a student.
class Instructions extends StatefulWidget {
  const Instructions({super.key});

  @override
  State<Instructions> createState() => _InstructionsState();
}

class _InstructionsState extends State<Instructions> {
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
                              'Displays upcoming events and classes/activities.\n',
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
                              'Displays personal and events from activities you participate in.\n',
                          style: TextStyle(
                            color: Colors.black,
                          ))
                    ])),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: '3. ClubHub (information icon): ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      TextSpan(
                          text:
                              'Displays a list of all clubs organized by several categories.\n',
                          style: TextStyle(
                            color: Colors.black,
                          ))
                    ])),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: '4. Bookkeeper (money icon): ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      TextSpan(
                          text:
                              'Displays a list of purchasable items at NCHS.\n',
                          style: TextStyle(
                            color: Colors.black,
                          ))
                    ])),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: '5. Settings (settings icon): ',
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
                      'This page is meant to provide a snapshot of your events, classes, and activities all in one location for easy access. In this page, you will see:\n',
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
                        'You will have access to up to five upcoming events, prioritized by date and time. These events will have the name, description, start time, and end time of the event. An icon is also displayed to provide more information about the event. These events will be displayed on cards. You can swipe through the cards to browse through the different events.\n',
                        style: TextStyle(color: Colors.black)),
                    Text(
                      'Lists of Classes and Activities',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'A list of classes and activities that you are currently in will be displayed; each can be accessed by the “classes” and “activities” buttons at the top of lists. Each list item will provide information about the teacher and a helpful icon to go along with it. The classes list item will further have information about the class period. By dragging each list item to the left, you will be presented with the options to either message or email the teacher of a particular class.\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'By pressing on the email option, an email draft will pop up on your screen, addressed to the teacher’s email. The body or subject will not be filled out. You can either send the email or save the email as a draft.\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Messaging',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'By pressing on the messaging option, you will be presented with a screen where you can privately message with a particular teacher. This will take the form of a simple chat app, where you will be able to upload images or other media as well as text.\n',
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
                      'The purpose of this page is to see any upcoming events that either you have created or that an activity that you are in has added. In this page, the default calendar mode will show weekly calendar events.\n',
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
                          text: 'personal events, ',
                          style: TextStyle(
                            color: Color(0xff909c81),
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
                      'Add Personal Event',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'An add icon will be located at the bottom right corner of the screen. When you click this icon, you will be able to add your own event. A form will show on the screen and you will be required to input the following information: Subject of event, details of event, start time (which will display a date and time picker), and end time (which will also display a date and time picker). When you click “submit”, you will be redirected to the calendar page and your event will be displayed at the date chosen.\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'ClubHub',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'The ClubHub is an area where you can browse through all of the clubs and sports at NCHS in order to get more information about each or to join a particular club. Each item will contain the name, adviser, members, room number, and icon, and of the club. You can browse through the clubs in two different ways:\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Browse Using Categories',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'There are six different categories that you can select: Popular, business, technology, art, culture, and sports. These six categories represent a majority of clubs at this school. When you click on a particular category, a list of clubs that belong in this category will be displayed in a column.\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Browse Using Search Bar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'A search bar will be displayed at the top of the page. When nothing has been searched for, a list of all of the clubs at NCHS will be displayed in a column. As you search for a particular club, the results will filter, until you reach the particular club that you are looking for.\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Clicking On the Club',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'When you click on the club that you would like to join or find more information on, the tags, description, and achievements of the club in addition to all of the information on the previous list item. On this expanded view of the club, you will also be able to:\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'View the Club\'s Instagram',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'An Instagram icon will be displayed at the bottom of the screen. When clicking on this icon, you will be able to see the club\'s Instagram posts to get more information.\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Join the Club',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Click on the “join” button, also displayed at the bottom of the screen if this is a club that you are not already a part of. When clicking join, a box will pop up, asking if you have already joined the Remind code (unless the club has no Remind code). If not, a link will redirect you to join the Remind for the particular club.\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Bookkeeper Page',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'The purpose of the bookkeeper page is to allow students to make purchases (as an alternative to NSD touchbase). A list of all purchasable items will be displayed as a grid. Each grid item has an image of the time, name of the item, and the cost of the item. To browse for the bookkeeper items, a search bar can be used.\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Browse Using Search Bar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'A search bar will be displayed at the top of the page. When nothing has been searched for, a list of all purchasable items at NCHS will be displayed in a grid. As you search for a particular item, the results will filter, until you reach the particular item that you are looking for.\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Clicking On the Bookkeeper Item',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'When you click on an item that you would like to purchase, all of the elements from the grid element will be presented along with a description of the item. At the end, a “Buy Now” button will be presented. You can click on it if you decide to go ahead with the purchase.\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Make the Purchase',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'When you click buy now, a warning that you must first pay the fine to receive the item will be displayed. You will then have the option to either click cancel or confirm. When you confirm the purchase, the item and fine will be added to your account. If you click cancel, the purchase will not be registered.\n',
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
                      'This information will be relevant to you. It will include items, such as your name, the type of person you are (“student” in this case), and your pronouns. The only editable field is your pronouns.\n',
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
