import 'package:flutter/material.dart';
import 'package:mad/classes/item.dart';

class Child extends Item {
  late String firstName;
  late String lastName;
  late Icon icon;

  Child(String firstName, String lastName, Icon icon) : super(firstName, icon) {
    this.lastName = lastName;
  }
}
