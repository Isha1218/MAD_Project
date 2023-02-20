import 'package:flutter/material.dart';

class Event {
  late String subject;
  late String tag;
  late DateTime startTime;
  late DateTime endTime;
  late String notes;

  Event(String subject, String tag, DateTime startTime, DateTime endTime,
      String notes) {
    this.subject = subject;
    this.tag = tag;
    this.startTime = startTime;
    this.endTime = endTime;
    this.notes = notes;
  }
}
