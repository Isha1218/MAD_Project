import 'package:flutter/material.dart';
import 'package:mad/classes/child.dart';
import 'package:mad/classes/item.dart';
import 'package:mad/classes/club.dart';
import 'package:mad/classes/school_class.dart';

class ClubsOrClassesFormat extends StatelessWidget {
  const ClubsOrClassesFormat({
    Key? key,
    required this.list,
  }) : super(key: key);

  final List<Item> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < list.length; i += 2)
          if (list.length % 2 == 1 && i == list.length - 1)
            Row(
              children: [DisplayClubOrClass(item: list[i])],
            )
          else
            Row(
              children: [
                DisplayClubOrClass(item: list[i]),
                DisplayClubOrClass(item: list[i + 1]),
              ],
            )
      ],
    );
  }
}

class DisplayClubOrClass extends StatelessWidget {
  final Item item;

  const DisplayClubOrClass({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(offset: Offset(2.0, 2.0), color: Colors.grey.shade300),
            ]),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            item.icon,
            SizedBox(
              height: 10,
            ),
            LayoutBuilder(builder: (context, constraints) {
              if (item.runtimeType == SchoolClass) {
                return Text(
                    'Period ' + (item as SchoolClass).period.toString());
              } else {
                return Container();
              }
            }),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            LayoutBuilder(builder: (context, constraints) {
              if (item.runtimeType == Child) {
                return Align(
                  child: Text(
                    (item as Child).lastName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              } else {
                return Container();
              }
            }),
          ]),
        ),
      ),
    );
  }
}
