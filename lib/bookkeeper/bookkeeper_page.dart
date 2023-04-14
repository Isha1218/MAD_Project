import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad/bookkeeper/bookkeeper_item_info.dart';
import 'package:mad/classes/bookkeeper_item.dart';

// This widget will display all of the bookkeeper items at NCHS
// in a grid format.
class BookkeeperPage extends StatefulWidget {
  const BookkeeperPage({super.key, required this.user});

  final GoogleSignInAccount user;

  @override
  State<BookkeeperPage> createState() => _BookkeeperPageState();
}

class _BookkeeperPageState extends State<BookkeeperPage> {
  // This will get all of the items from Firebase as the page loads.
  @override
  void initState() {
    getBookkeeperItems();
    super.initState();
  }

  // This list will keep track of all bookkeeper items taken from Firebase.
  List<BookkeeperItem> bookkeeperItems = [];

  // This controller will function as a search bar to query for items.
  TextEditingController controller = TextEditingController();

  // This FocusNode will add focus to the search bar when it is clicked.
  FocusNode myfocus = FocusNode();

  // This function will get all of the bookkeeper items from Firebase.
  Future<void> getBookkeeperItems() async {
    // Accesses the bookkeepers collection to do so.
    await FirebaseFirestore.instance
        .collection('bookkeepers')
        .get()
        .then((value) => {
              value.docs.forEach((element) async {
                String name = element.data()['name'];
                String cost = element.data()['cost'];
                String description = element.data()['description'];

                setState(() {
                  bookkeeperItems.add(BookkeeperItem(
                      cost: cost, name: name, description: description));
                });
              })
            });
  }

  // This function will return the search bar widget, which will be formed by a text field.
  Widget displaySearchBar() {
    return TextField(
      // Has a done button to exit out of the search bar.
      textInputAction: TextInputAction.done,
      focusNode: myfocus,
      controller: controller,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Search for items...',
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

      // Filters results when query has changed.
      onChanged: searchActivity,
    );
  }

  // This function will filter the results as the user searches an item.
  void searchActivity(String query) {
    if (query != '') {
      final suggestions = bookkeeperItems.where((item) {
        final itemName = item.name.toLowerCase();
        final input = query.toLowerCase();

        return itemName.contains(input);
      }).toList();

      setState(() {
        bookkeeperItems = suggestions;
      });

      // query is empty, so it should display all of the bookkeeper items.
    } else {
      bookkeeperItems.clear();
      getBookkeeperItems();
    }
  }

  // This function will return a widget that will display each individual bookkeeper item.
  // Each item will have an image and the cost and name of the item below the image.
  Widget buildItemCard(BookkeeperItem item) {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookkeeperItemInfo(
                      item: item,
                      user: widget.user,
                    )));
      },
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.27,
            width: MediaQuery.of(context).size.width * 0.45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 5))
                ]),

            // Image
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.19,
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: Image.asset(
                          "images/" +
                              item.name.replaceAll(' ', '_').toLowerCase() +
                              ".jpg",
                          fit: BoxFit.cover,
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),

                  // Cost and name
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      item.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      '\$' + item.cost,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // This will build the entire screen by presenting all of the necessary widgets.
  // The search bar will be at the top and the grid items will be below that.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff78CAD2),
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
            child: Text(
              'All Items',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),

          // Search bar at top.
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
                            minHeight: MediaQuery.of(context).size.height * 1,
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
                                      padding: const EdgeInsets.fromLTRB(
                                          32, 20, 32, 32),

                                      // Displays items in a grid (2 columns and unlimited rows).
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 2,
                                          mainAxisSpacing: 4,
                                          mainAxisExtent: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.3,
                                        ),
                                        itemCount: bookkeeperItems.length,
                                        itemBuilder: (context, index) {
                                          return buildItemCard(
                                              bookkeeperItems[index]);
                                        },
                                      ),
                                    ),
                                  ]))))))
        ]),
      ),
    );
  }
}
