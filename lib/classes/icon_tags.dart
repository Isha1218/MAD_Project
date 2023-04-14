import 'package:flutter/material.dart';

// This class will find the best icon based on the tags.
// The size will also be determined by whether it is at the top of the page
// or the bottom.
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
        color: top ? Colors.white : Color.fromARGB(255, 99, 57, 151),
        size: top ? 50 : 30,
      );
    } else if (this.tag == "Tennis") {
      return Icon(
        Icons.sports_tennis,
        color: top ? Colors.white : Color.fromARGB(255, 99, 57, 151),
        size: top ? 50 : 30,
      );
    } else if (this.tag == "Math") {
      return Icon(
        Icons.calculate,
        color: top ? Colors.white : Color.fromARGB(255, 99, 57, 151),
        size: top ? 50 : 30,
      );
    } else if (this.tag == "English") {
      return Icon(
        Icons.notes,
        color: top ? Colors.white : Color.fromARGB(255, 99, 57, 151),
        size: top ? 50 : 30,
      );
    } else if (this.tag == "Science") {
      return Icon(
        Icons.science,
        color: top ? Colors.white : Color.fromARGB(255, 99, 57, 151),
        size: top ? 50 : 30,
      );
    } else if (this.tag == "Computer Science") {
      return Icon(
        Icons.code,
        color: top ? Colors.white : Color.fromARGB(255, 99, 57, 151),
        size: top ? 50 : 30,
      );
    } else if (this.tag == "History") {
      return Icon(
        Icons.history,
        color: top ? Colors.white : Color.fromARGB(255, 99, 57, 151),
        size: top ? 50 : 30,
      );
    } else if (this.tag == "Personal") {
      return Icon(
        Icons.article,
        color: Colors.white,
        size: top ? 50 : 30,
      );
    } else if (this.tag == "Art") {
      return Icon(
        Icons.brush,
        color: Colors.white,
        size: top ? 50 : 30,
      );
    } else if (this.tag == "Culture") {
      return Icon(
        Icons.diversity_2,
        color: Colors.white,
        size: top ? 50 : 30,
      );
    } else {
      return Icon(
        Icons.school,
        color: top ? Colors.white : Color.fromARGB(255, 99, 57, 151),
        size: top ? 50 : 30,
      );
    }
  }
}
