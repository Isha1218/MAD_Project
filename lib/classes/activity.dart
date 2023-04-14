import 'package:flutter/material.dart';

// This class represents an activity, which will be used in the ClubHub.
// It has the name of the activity, adviser, number of members, tags (or categories),
// color for the background of the icon, room number that the activity is held in, the Instagram
// account of the activity, the remind code (if any), and a list of the club's achievements.
class Activity {
  final String name;
  final String adviser;
  final int members;
  final String tags;
  final Color color;
  final String room;
  final String instagram;
  final String remind;
  final String description;
  final List<String> achievements;

  const Activity({
    required this.name,
    required this.adviser,
    required this.members,
    required this.tags,
    required this.color,
    required this.room,
    required this.instagram,
    required this.remind,
    required this.achievements,
    required this.description,
  });
}
