import 'package:flutter/material.dart';

// This class represents an Item (either a school class or a club).
// It has a name of the class/item and an icon to further act as a description.
class Item {
  late String name;
  late Icon icon;

  Item(String name, Icon icon) {
    this.name = name;
    this.icon = icon;
  }
}
