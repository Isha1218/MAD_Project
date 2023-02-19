import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad/asb/asb.dart';
import 'package:mad/calendar/calendar.dart';
import 'package:mad/calendar/calendar_teacher.dart';
import 'package:mad/home/home.dart';
import 'package:mad/home/home_teacher.dart';
import 'package:mad/calendar/request_event.dart';
import 'package:mad/settings/settings.dart';
import 'package:flutter/material.dart';

class TeacherTab extends StatefulWidget {
  const TeacherTab({Key? key, required this.user}) : super(key: key);

  final GoogleSignInAccount user;

  @override
  State<TeacherTab> createState() => _TeacherTabState();
}

class _TeacherTabState extends State<TeacherTab> {
  int pageIndex = 0;
  List<Widget> getPages() {
    return [
      HomeTeacher(user: widget.user),
      CalendarTeacher(user: widget.user),
      Setting(
        person: 'teachers',
        user: widget.user,
      ),
      ASB()
    ];
  }

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
            )
          ],
        ),
      ),
    );
  }
}
