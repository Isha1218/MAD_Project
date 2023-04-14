import 'package:flutter/material.dart';
import '../tabs/parent_tab.dart';
import '../tabs/student_tab.dart';
import '../tabs/teacher_tab.dart';
import 'google_sign_in_api.dart';

// This widget will display the sign in page.
// It will use the GoogleSignInApi class to assess whether the user
// able to be successfully authorized.
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
            // Title of app
            Text(
              'VERTEX',
              style: TextStyle(
                fontSize: 45,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),

            // App slogan
            const Text(
              'THE POINT TO CONNECT',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            // App logo
            Image.asset(
              'images/logo.png',
              height: 300,
            ),
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

            // Student sign in button
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

            // Parent sign in button
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

            // Teacher sign in button
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
                    "TEACHER",
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

  // Signs in student by first checking whether the Google account is verified
  // Secondary verification occurs by checking if the email matches the 'apps.nsd.org' extension.
  // This extension is common to all NCHS students.
  Future signInStudent() async {
    var user = await GoogleSignInApi.login();

    if (user != null && user.email.contains('apps.nsd.org')) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StudentTab(
                user: user,
                selectedIndex: 0,
              )));
    }
  }

  // Signs in parent by checking whether the Google account is verified.
  Future signInParent() async {
    final user = await GoogleSignInApi.login();

    if (user != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ParentTab(user: user, selectedIndex: 0)));
    }
  }

  // Signs in teacher by checking whether the Google account is verfied.
  // Secondary verification occurs by checking if the email contains the 'nsd.org' extension.
  // This extension common to all NCHS teachers.
  Future signInTeacher() async {
    final user = await GoogleSignInApi.login();

    if (user != null || user!.email.contains('nsd.org')) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TeacherTab(
                user: user,
                selectedIndex: 0,
              )));
    }
  }
}
