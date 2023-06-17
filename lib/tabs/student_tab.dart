import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad/clubhub/browse_clubs.dart';
import 'package:mad/calendar/calendar.dart';
import 'package:mad/home/home.dart';
import 'package:mad/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
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

class _StudentTabState extends State<StudentTab> with TickerProviderStateMixin {
  TabController? _tabController;
  List<String> labels = [
    "Home",
    "Calendar",
    "ClubHub",
    "Bookkeeper",
    "Settings"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: widget.selectedIndex,
      length: 5,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: labels[widget.selectedIndex],
        useSafeArea: true,
        labels: labels,
        icons: const [
          Icons.home,
          Icons.calendar_month,
          Icons.info,
          Icons.monetization_on,
          Icons.settings
        ],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Colors.grey,
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: Color(0xff78CAD2).withOpacity(0.75),
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int value) {
          setState(() {
            _tabController!.index = value;
          });
        },
      ),
      body: TabBarView(
        physics:
            NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
        controller: _tabController,
        // ignore: prefer_const_literals_to_create_immutables
        children: <Widget>[
          Home(user: widget.user),
          Calendar(user: widget.user),
          BrowseClubs(user: widget.user),
          BookkeeperPage(user: widget.user),
          Setting(person: 'students', user: widget.user)
        ],
      ),
    );
  }
}
