import 'package:flutter/material.dart';
//import 'package:vertex/service/auth_service.dart';
import "package:google_fonts/google_fonts.dart";
// import '../helper/helper_function.dart';
import "search.dart";

class AbsencesPage extends StatefulWidget {
  const AbsencesPage({Key? key}) : super(key: key);

  @override
  State<AbsencesPage> createState() => _AbsencesPageState();
}

class _AbsencesPageState extends State<AbsencesPage> {
  //create texteditingcontroller to store text field values
  //send to firebase

  String username = "";
  String email = "";
  //AuthService authService = AuthService();

  //Dropdown code
  String dropdownVal = 'Sick';

  var items = [
    "Sick",
    "Covid-positive",
    "Conflicting Appointment",
    "Travel",
    "Other"
  ];

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
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color.fromRGBO(120, 202, 210, 1),
          title: Text("Absences",
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
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
                      selected: false,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
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
                      selected: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      leading: const Icon(Icons.exit_to_app),
                      title: Text("Logout",
                          style: GoogleFonts.rubik(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300))))
                ])),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text("Reason for Absence",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.rubik(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold))),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: DropdownButtonFormField(
                  decoration: (InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(255, 227, 220, 0.55)),
                          borderRadius: BorderRadius.circular(20)),
                      filled: true,
                      fillColor: Color.fromRGBO(255, 227, 220, 0.55))),
                  value: dropdownVal,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items,
                          style: GoogleFonts.rubik(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500))),
                    );
                  }).toList(),
                  onChanged: (String? newVal) {
                    setState(() {
                      //store in firebase
                      dropdownVal = newVal!;
                      // ignore: prefer_const_constructors
                    });
                  }),
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color.fromRGBO(255, 227, 220, 0.55),
                      hintText: "Please provide details",
                      hintStyle: GoogleFonts.rubik(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w300))),
                  maxLines: 5,
                )),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text("Duration of Absence",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.rubik(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold))),
            ),

            //include period options

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text("Parent/Guardian Contact",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.rubik(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold))),
            ),

            //button
          ],
        ));
  }
}
