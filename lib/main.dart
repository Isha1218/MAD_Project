// @dart=2.9

import 'package:mad/authentication/google_signin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad/authentication/member_login_page.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'authentication/splash_page.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';

void main() async {
  // Necessary to add when using Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: OverlaySupport(
          // overlay support was added
          child: MaterialApp(
              // Removes debug banner
              debugShowCheckedModeBanner: false,

              // Sets all fonts used (unless specified) to rubik
              theme: ThemeData(
                fontFamily: GoogleFonts.rubik().fontFamily,
              ),

              // First page that the user will see is the Member Login Page.

              home: SplashScreen.navigate(
                  name: 'assets/vertex_splash_screen.riv',
                  next: (context) => MemberLoginPage(),
                  until: () => Future.delayed(Duration(milliseconds: 2500)),
                  startAnimation: 'Timeline 1')
              // home: Splash()
              ),
        ),
      );
}
