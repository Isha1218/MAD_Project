import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../classes/bookkeeper_item.dart';

// This widget displays information about each bookkeeper item and also provides the option to purchase the item.
// It has an item of type Bookkeeper and the user.
class BookkeeperItemInfo extends StatefulWidget {
  const BookkeeperItemInfo({super.key, required this.item, required this.user});

  final BookkeeperItem item;
  final GoogleSignInAccount user;

  @override
  State<BookkeeperItemInfo> createState() => _BookkeeperItemInfoState();
}

class _BookkeeperItemInfoState extends State<BookkeeperItemInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 1),
              child: Column(
                children: [
                  // Displays te image of the bookkeeper item at the top of the screen.
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        image: DecorationImage(
                            image: AssetImage('images/' +
                                widget.item.name
                                    .replaceAll(' ', '_')
                                    .toLowerCase() +
                                '.jpg'),
                            fit: BoxFit.cover),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200,
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 5))
                        ]),
                  ),

                  // The cost, name, and description of the item are at the bottom of the screen.
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.item.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$' + widget.item.cost,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.item.description,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),

                  // Button that user can click to purchase the item.
                  TextButton(
                    onPressed: () {
                      // User is alerted to first pay fine before recieving item.
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                widget.item.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                  'By purchasing this item, a fine will be added to your school account. You will recieve the item only when you pay this fine.'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel')),

                                // When user confirms purchase, the item will be added to the user's purchases collection
                                // in Firebase.
                                TextButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('students')
                                          .doc(widget.user.displayName!
                                              .replaceAll(' ', '_')
                                              .toLowerCase())
                                          .collection('purchases')
                                          .doc()
                                          .set({
                                        'name': widget.item.name,
                                        'cost': widget.item.cost,
                                        'datePurchased': DateTime.now(),
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text('Confirm'))
                              ],
                            );
                          });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.075,
                      decoration: BoxDecoration(
                        color: Color(0xff78CAD2),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff78CAD2).withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 5))
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Buy Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Allows user to go back to the previous screen.
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Align(
              alignment: Alignment.topLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
