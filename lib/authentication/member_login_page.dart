// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import "package:flutter/src/widgets/navigator.dart";
import '../main.dart';
import '../tabs/parent_tab.dart';
import '../tabs/student_tab.dart';
import '../tabs/teacher_tab.dart';
import 'GoogleSignInApi.dart';
//import 'package:google_fonts/google_fonts.dart';

class MemberLoginPage extends StatefulWidget {
  const MemberLoginPage({Key? key}) : super(key: key);

  @override
  State<MemberLoginPage> createState() => _MemberLoginPageState();
}

class _MemberLoginPageState extends State<MemberLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(120, 202, 210, 1),
      body: SafeArea(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            // hello again
            const Text(
              'VERTEX',
              style: TextStyle(
                //style: GoogleFonts.bebasNeue(
                fontSize: 45,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            const Text(
              'THE POINT TO CONNECT',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            const Icon(
              Icons.phone_android,
              size: 150,
              color: Colors.white,
            ),

            const SizedBox(height: 50),

            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 25, 10),
                child: Text(
                  'LOGIN AS A...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            // student
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(76, 44, 114, 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: TextButton(
                  onPressed: () {
                    signInStudent();
                  },
                  child: const Text(
                    "STUDENT",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                )),
              ),
            ),

            const SizedBox(height: 12),

            // parent
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(76, 44, 114, 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: TextButton(
                  onPressed: () {
                    signInParent();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  child: const Text(
                    "PARENT",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                )),
              ),
            ),
            const SizedBox(height: 12),

            // staff
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(76, 44, 114, 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: TextButton(
                  onPressed: () {
                    signInTeacher();
                  },
                  child: const Text(
                    "STAFF",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                )),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future signInStudent() async {
    var user = await GoogleSignInApi.login();

    if (user != null && user.email.contains('apps.nsd.org')) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => StudentTab(user: user)));
    }
  }

  Future signInParent() async {
    final user = await GoogleSignInApi.login();

    if (user != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ParentTab(user: user)));
    }
  }

  Future signInTeacher() async {
    final user = await GoogleSignInApi.login();

    if (user != null || user!.email.contains('nsd.org')) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => TeacherTab(user: user)));
    }
  }
}
