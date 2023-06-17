import 'package:flutter/material.dart';
import 'package:mad/classes/item.dart';

// This class represents a class at school and inherits from the Item class.
// It has the name of the class, teacher of the class, an icon to represent the class,
// and the class period.
class SchoolClass extends Item {
  late String name;
  late String teacher;
  late Icon icon;
  late int period;
  late bool unread;

  SchoolClass(String name, Icon icon, int period, String teacher, bool unread)
      : super(name, icon) {
    this.period = period;
    this.teacher = teacher;
    this.unread = unread;
  }
}
