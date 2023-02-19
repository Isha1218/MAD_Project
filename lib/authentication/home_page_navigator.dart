import "package:flutter/material.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:mad/authentication/member_login_page.dart';
import 'package:mad/home/home.dart';
import 'package:mad/tabs/student_tab.dart';

class HomePageNavigator extends StatefulWidget {
  const HomePageNavigator({super.key});

  @override
  State<HomePageNavigator> createState() => _HomePageNavigatorState();
}

class _HomePageNavigatorState extends State<HomePageNavigator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: StreamBuilder(
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //   builder: (context, snapshot) {
        //     print('in here');
        //     if (snapshot.hasData) {
        //       print('what');
        //       return StudentTab();
        //     } else {
        //       print('hello');
        //       return StudentTab();
        //     }
        //   },
        // ),
        );
  }
}
