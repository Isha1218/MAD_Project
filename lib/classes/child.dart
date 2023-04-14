import 'package:flutter/material.dart';
import 'package:mad/classes/item.dart';

// This class represent a child of the parent that will exclusively be used by the
// parent widgets.
// It has the first and last names of the child, as well as an icon to represent the child.
class Child extends Item {
  late String firstName;
  late String lastName;
  late Icon icon;

  Child(String firstName, String lastName, Icon icon) : super(firstName, icon) {
    this.lastName = lastName;
  }
}
