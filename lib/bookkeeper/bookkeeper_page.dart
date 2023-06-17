import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mad/bookkeeper/bookkeeper_item_info.dart';
import 'package:mad/bookkeeper/student_purchases.dart';
import 'package:mad/classes/bookkeeper_item.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../classes/bookeeper_item_history.dart';

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
    getPurchasedItems();
    super.initState();
  }

  // This list will keep track of all bookkeeper items taken from Firebase.
  List<BookkeeperItem> bookkeeperItems = [];

  List<BookkeeperItemHistory> bookeeperPurchasedItems = [];

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

                var ref = FirebaseStorage.instance.ref().child(
                    "bookkeeper_images/" +
                        name.toLowerCase().replaceAll(' ', '_') +
                        ".jpg");
                String url = (await ref.getDownloadURL()).toString();

                setState(() {
                  bookkeeperItems.add(BookkeeperItem(
                      cost: cost,
                      name: name,
                      description: description,
                      image: Image.network(
                        url,
                        cacheHeight: (MediaQuery.of(context).size.height *
                                0.22 *
                                MediaQuery.of(context).devicePixelRatio)
                            .round(),
                        fit: BoxFit.cover,
                      )));
                });
              })
            });
  }

  Future<void> getPurchasedItems() async {
    FirebaseFirestore.instance
        .collection('students')
        .doc(widget.user.displayName!.toLowerCase().replaceAll(' ', '_'))
        .collection('purchases')
        .orderBy('datePurchased')
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        var ref = FirebaseStorage.instance.ref().child("bookkeeper_images/" +
            element.data()['name'].toLowerCase().replaceAll(' ', '_') +
            ".jpg");
        String url = (await ref.getDownloadURL()).toString();
        BookkeeperItemHistory item = BookkeeperItemHistory(
            cost: element.data()['cost'],
            name: element.data()['name'],
            time: DateFormat('MMM dd, yyyy')
                .format(element.data()['datePurchased'].toDate()),
            image: Image.network(
              url,
              cacheHeight: 60,
              fit: BoxFit.cover,
            ));

        setState(() {
          bookeeperPurchasedItems.add(item);
        });
      });
    });
  }

  // This function will return the search bar widget, which will be formed by a text field.
  Widget displaySearchBar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 50,
      child: TextField(
        // Has a done button to exit out of the search bar.
        textInputAction: TextInputAction.done,
        focusNode: myfocus,
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            prefixIconColor: Colors.grey,
            hintText: 'Search for items...',
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Color(0xfff6f8fa),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xfff6f8fa)),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xfff6f8fa)),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ))),

        // Filters results when query has changed.
        onChanged: searchActivity,
      ),
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


  // This will build the entire screen by presenting all of the necessary widgets.
  // The search bar will be at the top and the grid items will be below that.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: Colors.white,
  body: SafeArea(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                displaySearchBar(),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xfff6f8fa),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return StudentPurchases(
                            studentId: widget.user.displayName!
                                .replaceAll(' ', '_')
                                .toLowerCase(),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.history),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xff78CAD2).withOpacity(0.6),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'images/money_bookkeeper.png',
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    Text(
                      'Pay Fines\nAt School',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            MasonryGridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: bookkeeperItems.length,
              gridDelegate:
                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
              itemBuilder: (context, index) => Padding(
                padding: index == 1
                    ? EdgeInsets.fromLTRB(8, 35, 8, 8)
                    : EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookkeeperItemInfo(
                              item: bookkeeperItems[index],
                              user: widget.user,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: bookkeeperItems[index].image.image,
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.2),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        bookkeeperItems[index].name,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '\$' + bookkeeperItems[index].cost,
                        style: TextStyle(
                          color: Color(0xff78CAD2),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);

  }
}
