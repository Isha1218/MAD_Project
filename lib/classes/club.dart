import 'package:flutter/material.dart';
import 'package:mad/classes/item.dart';

// This class represents a school club, which inherits from the Item class.
// It has the name of the club, an icon to represent the club, and the adviser of the club.
class Club extends Item {
  late String name;
  late Icon icon;
  late String adviser;
  late bool unread;

  Club(super.name, super.icon, String adviser, bool unread) {
    this.adviser = adviser;
    this.unread = unread;
  }
}
