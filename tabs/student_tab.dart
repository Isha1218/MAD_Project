import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad/asb/asb.dart';
import 'package:mad/authentication/GoogleSignInApi.dart';
import 'package:mad/calendar/calendar.dart';
import 'package:mad/home/home.dart';
import 'package:mad/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:mad/messages.dart';
import 'package:mad/absences.dart';

class StudentTab extends StatefulWidget {
  const StudentTab({Key? key, required this.user}) : super(key: key);

  final GoogleSignInAccount user;

  @override
  State<StudentTab> createState() => _StudentTabState();
}

class _StudentTabState extends State<StudentTab> {
  List<Widget> getPages() {
    return <Widget>[
      Home(user: widget.user),
      Calendar(user: widget.user),
      Setting(
        person: 'students',
        user: widget.user,
      ),
      ASB(),
      MessagesPage(),
    ];
  }

  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getPages()[pageIndex],
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: pageIndex == 0
                  ? Icon(
                      Icons.home_filled,
                      color: Colors.white,
                      size: 35,
                    )
                  : Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              icon: pageIndex == 1
                  ? Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.white,
                      size: 35,
                    )
                  : Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              icon: pageIndex == 2
                  ? Icon(
                      Icons.settings_rounded,
                      color: Colors.white,
                      size: 35,
                    )
                  : Icon(
                      Icons.settings_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 3;
                });
              },
              icon: pageIndex == 3
                  ? Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 35,
                    )
                  : Icon(
                      Icons.school_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 4;
                });
              },
              icon: pageIndex == 4
                  ? Icon(
                      Icons.message,
                      color: Colors.white,
                      size: 35,
                    )
                  : Icon(
                      Icons.message_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
