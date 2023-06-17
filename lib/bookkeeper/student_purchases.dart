import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../classes/bookeeper_item_history.dart';

class StudentPurchases extends StatefulWidget {
  const StudentPurchases({super.key, required this.studentId});

  final String studentId;

  @override
  State<StudentPurchases> createState() => _StudentPurchasesState();
}

class _StudentPurchasesState extends State<StudentPurchases> {
  List<BookkeeperItemHistory> bookeeperItems = [];

  @override
  void initState() {
    getStudentPurchases();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Purchase History',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close),
                    color: Colors.grey,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: bookeeperItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                          title: Text(
                            bookeeperItems[index].name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            bookeeperItems[index].time,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          trailing: Text('\$' + bookeeperItems[index].cost),
                          leading: Container(
                              height: 60,
                              width: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: bookeeperItems[index].image,
                              ))),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getStudentPurchases() async {
    print('in here: ' + widget.studentId);
    FirebaseFirestore.instance
        .collection('students')
        .doc(widget.studentId)
        .collection('purchases')
        .get()
        .then((value) => {
              value.docs.forEach((element) async {
                print('in heerrererer');
                var ref = FirebaseStorage.instance.ref().child(
                    "bookkeeper_images/" +
                        element
                            .data()['name']
                            .toLowerCase()
                            .replaceAll(' ', '_') +
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
                  bookeeperItems.add(item);
                });
                bookeeperItems.sort((a, b) =>
                    (DateFormat('MMM dd, yyyy').parse(b.time))
                        .compareTo(DateFormat('MMM dd, yyyy').parse(a.time)));
              }),
            });
  }
}
