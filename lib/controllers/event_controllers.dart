import 'package:flutter/material.dart';
import 'package:pt_events_app/auth/auth_service.dart';

import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_model.dart';

class EventControllers {
  final supabase = Supabase.instance.client;
  // final SupabaseClient supaBase = Supabase.instance.client;
  final authService = AuthService();
  Future<List<Event>> retrieveEvents() async {
    try {
      // final response = await supabase.from('events').select().execute();
      // final response = await supabase.from('events').select<List<Map<String, dynamic>>>(); //this doesn't work
      final response = await supabase.from('events').select();
      // final response = await supabase.from('events').select<List<Map<String, dynamic>>>('*');

      print(response);

      // if (response != null)
      if (response == null) {
        print('Error retrieving events: ${response}');
        return [];
      }

      final data = response as List<dynamic>;
      print('Events retrieved successfully: ${data.length} items');

      print(data);
      // return data.map((event) => event as Map<String, dynamic>).toList();
      // return data.map((e) => e.fromMap(e as Map<String, dynamic>)).toList();
      // return data.map((event) => Event.fromMap(event)).toList();

      return data.map((e) => Event.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error retrieving events: $e');
      return [];
    }
  }

  Future<void> participateEvent(int eventId) async {
    try {
      // Retrieve the logged-in user's ID
      final userId = await authService.getLoggedInUser();

      if (userId == null) {
        print('User not logged in');
        return; // Exit the function if the user is not logged in
      }

      print('User logged in with ID: $userId');

      // Insert the user_id and event_id into the participants table
      final response = await supabase.from('participants').insert({
        'user_id': userId,
        'event_id': eventId,
      });

      if (response.error == null) {
        print('Successfully registered for the event');
      } else {
        print('Error inserting into participants table: ${response.error.message}');
      }
    } catch (e) {
      final userId = await authService.getLoggedInUser();

      print(eventId); //this works
      print(userId); // works also normally

      print('Error participating in event: $e');
      // print(userId);
      print(eventId);
    }
  }
}
