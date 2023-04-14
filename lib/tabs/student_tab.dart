import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad/clubhub/browse_clubs.dart';
import 'package:mad/calendar/calendar.dart';
import 'package:mad/home/home.dart';
import 'package:mad/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../bookkeeper/bookkeeper_page.dart';

// This widget displays the tab bar at the bottom of the screen.
class StudentTab extends StatefulWidget {
  StudentTab({Key? key, required this.user, required this.selectedIndex})
      : super(key: key);

  final GoogleSignInAccount user;
  int selectedIndex;

  @override
  State<StudentTab> createState() => _StudentTabState();
}

class _StudentTabState extends State<StudentTab> {
  @override
  Widget build(BuildContext context) {
    // These are the list of tabs at the bottom.
    List<Widget> navItems = [
      Home(user: widget.user),
      Calendar(user: widget.user),
      BrowseClubs(user: widget.user),
      BookkeeperPage(
        user: widget.user,
      ),
      Setting(person: 'students', user: widget.user),
    ];

    return Scaffold(
      body: navItems.elementAt(widget.selectedIndex),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),

          // The Google Nav Bar package was used to display the tab bar in a neat view.
          child: GNav(
            gap: 8,
            backgroundColor: Colors.transparent,
            color: Colors.black,
            activeColor: Colors.white,
            tabBackgroundColor: Color(0xff3A404C),
            selectedIndex: widget.selectedIndex,
            onTabChange: (index) {
              setState(() {
                widget.selectedIndex = index;
              });
            },
            padding: EdgeInsets.all(12),
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.calendar_month,
                text: 'Calendar',
              ),
              GButton(
                icon: Icons.info,
                text: 'ClubHub',
              ),
              GButton(
                icon: Icons.monetization_on,
                text: 'Bookkeeper',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
              )
            ],
          ),
        ),
      ),
    );
  }
}
