import 'package:flutter/material.dart';

// This class represents an individual bookkeeper item.
// It has the cost of the item, name of the item, and a description of
// what the item could be used for.
class BookkeeperItem {
  final String cost;
  final String name;
  final String description;
  final Image image;

  const BookkeeperItem({
    required this.cost,
    required this.name,
    required this.description,
    required this.image,
  });
}
