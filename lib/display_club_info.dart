import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayClubInfo extends StatefulWidget {
  final String club;

  const DisplayClubInfo({
    Key? key,
    required this.club,
  }) : super(key: key);

  @override
  State<DisplayClubInfo> createState() => _DisplayClubInfoState();
}

class _DisplayClubInfoState extends State<DisplayClubInfo> {
  bool moreInfo = false;
  String moreInfoText = 'More';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff78CAD2),
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('clubs')
                .doc(widget.club)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return new CircularProgressIndicator();
              }
              var document = snapshot.data;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          document!['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        )),
                    child: Center(
                      child: findIcon(document['tags'].split(', ')[0]),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Tags: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.5,
                                    ),
                                  ),
                                  Column(
                                    children: document['tags']
                                        .split(", ")
                                        .map<Widget>((element) {
                                      return Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          decoration: BoxDecoration(
                                              color: Color(0xff4C2C72),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                element,
                                                style: TextStyle(
                                                  fontSize: 17.5,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ));
                                    }).toList(),
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Adviser: ',
                                        style: TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        document['adviser'],
                                        style: TextStyle(fontSize: 17.5),
                                      )
                                    ],
                                  )),
                            ),
                            Divider(),
                            Container(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('Members: ',
                                          style: TextStyle(
                                            fontSize: 17.5,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Text(
                                        document['members'].toString(),
                                        style: TextStyle(fontSize: 17.5),
                                      ),
                                    ],
                                  ),
                                )),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    child: Text('Info:',
                                        style: TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  Container(child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      if (moreInfo) {
                                        return Text(
                                          document['info'],
                                          style: TextStyle(
                                            fontSize: 17.5,
                                          ),
                                        );
                                      } else {
                                        return Text(document['info'],
                                            maxLines: 3,
                                            style: TextStyle(fontSize: 17.5));
                                      }
                                    },
                                  )),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        moreInfo = !moreInfo;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        moreInfo ? Text('Less') : Text('More'),
                                        moreInfo
                                            ? Icon(Icons.arrow_upward)
                                            : Icon(Icons.arrow_downward),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }

  Icon findIcon(String primary) {
    if (primary == "Business") {
      return Icon(
        Icons.money,
        size: 60.0,
        color: Colors.white,
      );
    } else {
      return Icon(
        Icons.computer,
        size: 60.0,
        color: Colors.white,
      );
    }
  }
}
