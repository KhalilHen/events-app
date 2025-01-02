import 'package:flutter/material.dart';
import '../controllers/event_controllers.dart';

class Event {
  // final int id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String time;
  final String location;
  // final String image;

  Event({
    // required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.time,
    required this.location,
    // required this.image
  });

  factory Event.fromMap(Map<String, dynamic> data) {
    return Event(
      // id: data['id'],
      title: data['title'], //When i change this into something that isn't equal in the DB then it will give no events
      //But start date i have correct but it still gives no events

      description: data['description'],
      // startDate: data['start_date'],
      startDate: DateTime.parse(data['start_date']),
      time: data['time'],
      endDate: DateTime.parse(data['end_date']),
      location: data['location'],
      // image: data['image']
    );
  }
}
