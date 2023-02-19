import 'package:flutter/material.dart';

class IconTags {
  late String tag;
  late bool top;

  IconTags(String tag, bool top) {
    this.tag = tag;
    this.top = top;
  }

  Icon findIcon() {
    if (this.tag == "Business") {
      return Icon(
        Icons.money,
        color: top ? Colors.white : Colors.green,
        size: top ? 130 : 40,
      );
    } else if (this.tag == "Tennis") {
      return Icon(
        Icons.sports_tennis,
        color: top ? Colors.white : Colors.blue,
        size: top ? 130 : 40,
      );
    } else if (this.tag == "Math") {
      return Icon(
        Icons.calculate,
        color: top ? Colors.white : Colors.green,
        size: top ? 130 : 40,
      );
    } else if (this.tag == "English") {
      return Icon(
        Icons.notes,
        color: top ? Colors.white : Colors.red,
        size: top ? 130 : 40,
      );
    } else if (this.tag == "Science") {
      return Icon(
        Icons.science,
        color: top ? Colors.white : Colors.blue,
        size: top ? 130 : 40,
      );
    } else if (this.tag == "Computer Science") {
      return Icon(
        Icons.code,
        color: top ? Colors.white : Colors.blueGrey,
        size: top ? 130 : 40,
      );
    } else if (this.tag == "History") {
      return Icon(
        Icons.history,
        color: top ? Colors.white : Colors.orange,
        size: top ? 130 : 40,
      );
    } else {
      return Icon(
        Icons.school,
        color: top ? Colors.white : Colors.purple,
        size: top ? 130 : 40,
      );
    }
  }
}
