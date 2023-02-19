import 'package:flutter/material.dart';
import 'package:mad/classes/item.dart';

class SchoolClass extends Item {
  late String name;
  late Icon icon;
  late int period;

  SchoolClass(String name, Icon icon, int period) : super(name, icon) {
    this.period = period;
  }
}
