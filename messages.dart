import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:google_fonts/google_fonts.dart";
import "search.dart";

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  String username = "";
  String email = "";
  //AuthService authService = AuthService();

  // @override
  // void initState() {
  //   super.initState();
  //   gettingUserData();
  // }

  // gettingUserData() async {
  //   await HelperFunctions.getUserEmailFromSF().then((value) {
  //     setState(() {
  //       email = value!;
  //     });
  //   });

  //   await HelperFunctions.getUserNameFromSF().then((value) {
  //     setState(() {
  //       username = value!;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SearchPage()));
            },
            icon: Icon(Icons.search),
          ),
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color.fromRGBO(120, 202, 210, 1),
        title: Text("Messages",
            style: GoogleFonts.rubik(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700))),
      ),
      drawer: Drawer(
          backgroundColor: Color.fromRGBO(120, 202, 210, 1),
          child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 50),
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  size: 150,
                  color: Colors.white,
                ),
                const SizedBox(height: 15),
                Text("Name?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w300))),
                const SizedBox(height: 30),
                const Divider(height: 2),
                ListTile(
                    onTap: () {},
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    selectedColor: Colors.white,
                    selectedTileColor: Color.fromRGBO(255, 216, 99, 1),
                    selected: false,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(Icons.home),
                    title: Text("Home",
                        style: GoogleFonts.rubik(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w300)))),
                ListTile(
                    onTap: () {},
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    selectedColor: Colors.white,
                    selectedTileColor: Color.fromRGBO(255, 216, 99, 1),
                    selected: false,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(Icons.calendar_month),
                    title: Text("Calendar",
                        style: GoogleFonts.rubik(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w300)))),
                ListTile(
                    onTap: () {},
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    selectedColor: Colors.white,
                    selectedTileColor: Color.fromRGBO(255, 216, 99, 1),
                    selected: false,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(Icons.group),
                    title: Text("Clubs and Activities",
                        style: GoogleFonts.rubik(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w300)))),
                ListTile(
                    onTap: () {},
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    selectedColor: Colors.white,
                    selectedTileColor: Color.fromRGBO(255, 216, 99, 1),
                    selected: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(Icons.message),
                    title: Text("Messages",
                        style: GoogleFonts.rubik(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w300)))),
                ListTile(
                    onTap: () {},
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    selectedColor: Colors.white,
                    selectedTileColor: Color.fromRGBO(255, 216, 99, 1),
                    selected: false,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(Icons.access_time),
                    title: Text("Absences",
                        style: GoogleFonts.rubik(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w300)))),
                ListTile(
                    onTap: () {},
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    selectedColor: Colors.white,
                    selectedTileColor: Color.fromRGBO(255, 216, 99, 1),
                    selected: false,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(Icons.settings),
                    title: Text("Settings",
                        style: GoogleFonts.rubik(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w300)))),
                ListTile(
                    onTap: () {
                      //do auth stuff
                    },
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    selectedColor: Colors.white,
                    selectedTileColor: Color.fromRGBO(255, 216, 99, 1),
                    selected: false,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: const Icon(Icons.exit_to_app),
                    title: Text("Logout",
                        style: GoogleFonts.rubik(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w300))))
              ])),
    );
  }
}
