import 'package:flutter/material.dart';
import '../controllers/event_controllers.dart';
class Event {
  //for now to test first if  title works
  final String title;
  // final String description;
  // final String date;
  // final String time;
  // final String location;
  // final String image;

  Event({
    required this.title,
    // this.description,
    // this.date,
    // this.time,
    // this.location,
    // this.image
  });

  factory Event.fromMap(Map<String, dynamic> data) {
    return Event(
      title: data['title'],
      // description: data['description'],
      // date: data['date'],
      // time: data['time'],
      // location: data['location'],
      // image: data['image']
    );
  }
}
