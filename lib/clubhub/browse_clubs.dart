import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad/classes/activity.dart';
import 'package:mad/classes/icon_tags.dart';
import 'package:mad/clubhub/club_info.dart';

// This widget will allow the user to look through all of the clubs and
// click on them to learn more or to join the club.
class BrowseClubs extends StatefulWidget {
  const BrowseClubs({super.key, required this.user});

  final GoogleSignInAccount user;

  @override
  State<BrowseClubs> createState() => _BrowseClubsState();
}

class _BrowseClubsState extends State<BrowseClubs> {
  // This will get all of the activities at NCHS when the page loads.
  @override
  void initState() {
    getActivities();
    super.initState();
  }

  // This text field will be used for search for clubs at the school.
  TextEditingController controller = TextEditingController();

  // Changes focus if isSearch changes.
  bool isSearch = false;

  // These lists represent the various categories that will be displayed.
  List<Activity> activites = [];
  List<Activity> popularActivites = [];
  List<Activity> businessActivites = [];
  List<Activity> technologyActivites = [];
  List<Activity> artActivities = [];
  List<Activity> cultureActivites = [];
  List<Activity> sportsActivites = [];

  // The secltion of the cateogries will be determined by the selectedIndex.
  int selectedIndex = 0;

  // This FocusNode will change focus depending on if the user is searching or not.
  FocusNode myfocus = FocusNode();

  // This function will get all of the activities at NCHS using Firebase.
  Future<void> getActivities() async {
    int allCount = 0;
    int popularCount = 0;
    int businessCount = 0;
    int technologyCount = 0;
    int artCount = 0;
    int cultureCount = 0;
    int sportsCount = 0;

    // The activities collection will be accessed in Firebase
    await FirebaseFirestore.instance
        .collection('activities')
        .get()
        .then((value) => {
              value.docs.forEach((element) async {
                if (element.data()['name'] != 'NCHS') {
                  String name = element.data()['name'];
                  String instagram = element.data()['instagram'];
                  String remind = element.data()['remind'];
                  String room = element.data()['room'];
                  String adviserRef = element.data()['adviser'].split('/')[1];
                  String adviser = '';
                  String description = element.data()['info'];
                  var adviserSnapshot = await FirebaseFirestore.instance
                      .collection('teachers')
                      .doc(adviserRef)
                      .get();

                  if (adviserSnapshot.exists) {
                    adviser = adviserSnapshot.data()!['lastName'];
                  }

                  int members = element.data()['members'];
                  String tags = element.data()['tags'];

                  List<String> achievements = [];

                  await FirebaseFirestore.instance
                      .collection('activities')
                      .doc(name.replaceAll(' ', '_').toLowerCase())
                      .collection('achievements')
                      .get()
                      .then(((value) {
                    value.docs.forEach((element) async {
                      String achievement = element.data()['achievement'];
                      achievements.add(achievement);
                    });
                  }));

                  // Activitities are added to the various lists.
                  setState(() {
                    activites.add(Activity(
                      name: name,
                      adviser: adviser,
                      members: members,
                      tags: tags,
                      color: findColor(allCount),
                      room: room,
                      instagram: instagram,
                      remind: remind,
                      achievements: achievements,
                      description: description,
                    ));
                    allCount++;
                    print(allCount.toString());
                  });

                  if (members > 50) {
                    setState(() {
                      popularActivites.add(Activity(
                        name: name,
                        adviser: adviser,
                        members: members,
                        tags: tags,
                        color: findColor(popularCount),
                        room: room,
                        instagram: instagram,
                        remind: remind,
                        achievements: achievements,
                        description: description,
                      ));
                      popularCount++;
                    });
                  }

                  if (tags.contains('Business')) {
                    setState(() {
                      businessActivites.add(Activity(
                        name: name,
                        adviser: adviser,
                        members: members,
                        tags: tags,
                        color: findColor(businessCount),
                        room: room,
                        instagram: instagram,
                        remind: remind,
                        achievements: achievements,
                        description: description,
                      ));
                      businessCount++;
                    });
                  }

                  if (tags.contains('STEM')) {
                    setState(() {
                      technologyActivites.add(Activity(
                        name: name,
                        adviser: adviser,
                        members: members,
                        tags: tags,
                        color: findColor(technologyCount),
                        room: room,
                        instagram: instagram,
                        remind: remind,
                        achievements: achievements,
                        description: description,
                      ));
                      technologyCount++;
                    });
                  }

                  if (tags.contains('Art')) {
                    setState(() {
                      artActivities.add(Activity(
                        name: name,
                        adviser: adviser,
                        members: members,
                        tags: tags,
                        color: findColor(artCount),
                        room: room,
                        instagram: instagram,
                        remind: remind,
                        achievements: achievements,
                        description: description,
                      ));
                      artCount++;
                    });
                  }

                  if (tags.contains('Culture')) {
                    setState(() {
                      cultureActivites.add(Activity(
                        name: name,
                        adviser: adviser,
                        members: members,
                        tags: tags,
                        color: findColor(cultureCount),
                        room: room,
                        instagram: instagram,
                        remind: remind,
                        achievements: achievements,
                        description: description,
                      ));
                      cultureCount++;
                    });
                  }

                  if (tags.contains('Sports')) {
                    setState(() {
                      sportsActivites.add(Activity(
                          name: name,
                          adviser: adviser,
                          members: members,
                          tags: tags,
                          color: findColor(sportsCount),
                          room: room,
                          instagram: instagram,
                          remind: remind,
                          achievements: achievements,
                          description: description));
                      sportsCount++;
                    });
                  }
                }
              })
            });
  }

  // This finds the activity color based on the index in the list,
  // creating a visually appealing look.
  Color findColor(int count) {
    if (count % 3 == 0) {
      return Color(0xffD56AA0);
    } else if (count % 3 == 1) {
      return Color.fromARGB(255, 251, 207, 74);
    } else {
      return Color(0xff909C81);
    }
  }

  Widget displaySearchBar() {
    return TextField(
      focusNode: myfocus,
      controller: controller,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Search for clubs...',
          filled: true,
          iconColor: Color(0xff78CAD2),
          fillColor: Color(0xffF7F7F7),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ))),
      onChanged: searchActivity,
      onTap: () {
        setState(() {
          isSearch = true;
        });
      },
    );
  }

  Color indexColor(Activity activity, int index) {
    if (index % 3 == 1) {
      return Color.fromARGB(255, 251, 207, 74);
    } else if (index % 3 == 0) {
      return Color(0xffD56AA0);
    } else {
      return Color(0xff909C81);
    }
  }

  Widget buildClubCard(Activity activity, int index) {
    return TextButton(
      onPressed: () async {
        bool joined = false;
        await FirebaseFirestore.instance
            .collection('students')
            .doc(widget.user.displayName!.replaceAll(' ', '_').toLowerCase())
            .collection('activities')
            .get()
            .then((value) => {
                  print(value.docs.length),
                  value.docs.forEach((element) async {
                    String activityDocRef =
                        element.data()['clubRef'].split("/")[1];
                    print(activityDocRef.replaceAll('_', ' '));
                    if (activityDocRef.replaceAll('_', ' ') ==
                        activity.name.toLowerCase()) {
                      joined = true;
                    }
                  })
                });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ClubInfo(
                    activity: activity,
                    icon:
                        IconTags(activity.tags.split(',')[0], false).findIcon(),
                    joined: joined,
                    user: widget.user,
                  )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 6, 24, 6),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade200,
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 5))
              ]),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: activity.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      IconTags(activity.tags.split(',')[0], false)
                          .findIcon()
                          .icon,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      activity.adviser,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 18,
                          color: Color(0xff4C2C72),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          activity.members.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Icon(
                          Icons.room,
                          size: 18,
                          color: Color(0xff78CAD2),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          activity.room,
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void searchActivity(String query) {
    if (query != '') {
      final suggestions = activites.where((activity) {
        final activityName = activity.name.toLowerCase();
        final input = query.toLowerCase();

        return activityName.contains(input);
      }).toList();

      setState(() {
        activites = suggestions;
      });
    } else {
      activites.clear();
      popularActivites.clear();
      businessActivites.clear();
      technologyActivites.clear();
      artActivities.clear();
      cultureActivites.clear();
      sportsActivites.clear();
      getActivities();
    }
  }

  Widget buildCategory(String name, Icon icon, int index) {
    return TextButton(
      child: Container(
        width: 95,
        height: 95,
        decoration: BoxDecoration(
            color: index == selectedIndex && !isSearch
                ? Color(0xff4C2C72)
                : Colors.white,
            //color: Color(0xff4C2C72),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200,
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 5))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon.icon,
                color: index == selectedIndex && !isSearch
                    ? Colors.white
                    : Color(0xff78CAD2),
                size: 40,
              ),
              Text(
                name,
                style: TextStyle(
                  color: index == selectedIndex && !isSearch
                      ? Colors.white
                      : Colors.grey,
                  fontSize: 10,
                ),
              )
            ],
          ),
        ),
      ),
      onPressed: () {
        setState(() {
          selectedIndex = index;
          isSearch = false;
          myfocus.unfocus();
          controller.clear();
          // controller.text = '';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff78CAD2),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 60, 0, 0),
            child: Text(
              'Browse Clubs',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
              child: displaySearchBar(),
            ),
          ),
          Expanded(
              child: SizedBox.expand(
                  child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffF7F7F7),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 32, 32, 20),
                      child: Text(
                        'Categories',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            buildCategory(
                                'Popular', Icon(Icons.star_outline), 0),
                            SizedBox(
                              width: 5,
                            ),
                            buildCategory('Business',
                                Icon(Icons.monetization_on_outlined), 1),
                            SizedBox(
                              width: 5,
                            ),
                            buildCategory(
                                'Technology', Icon(Icons.computer_outlined), 2),
                            SizedBox(
                              width: 5,
                            ),
                            buildCategory('Art', Icon(Icons.brush_outlined), 3),
                            SizedBox(
                              width: 5,
                            ),
                            buildCategory(
                                'Culture', Icon(Icons.diversity_2_outlined), 4),
                            SizedBox(
                              width: 5,
                            ),
                            buildCategory(
                                'Sports', Icon(Icons.sports_football), 5)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    LayoutBuilder(builder: (context, constraints) {
                      if (isSearch) {
                        return Column(
                            children: List.generate(activites.length, (index) {
                          return buildClubCard(activites[index], index);
                        }));
                      } else {
                        List<Activity> displayList = [];
                        if (selectedIndex == 0) {
                          displayList = popularActivites;
                        } else if (selectedIndex == 1) {
                          displayList = businessActivites;
                        } else if (selectedIndex == 2) {
                          displayList = technologyActivites;
                        } else if (selectedIndex == 3) {
                          displayList = artActivities;
                        } else if (selectedIndex == 4) {
                          displayList = cultureActivites;
                        } else {
                          displayList = sportsActivites;
                        }
                        return Column(
                            children:
                                List.generate(displayList.length, (index) {
                          return buildClubCard(displayList[index], index);
                        }));
                      }
                    }),
                  ],
                ),
              ),
            ),
          )))
        ],
      ),
    );
  }
}
