import 'package:flutter/material.dart';
import 'package:pt_events_app/auth/auth_service.dart';
import 'package:pt_events_app/main.dart';

import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_model.dart';

class EventControllers {
  final supabase = Supabase.instance.client;
  // final SupabaseClient supaBase = Supabase.instance.client;
  final authService = AuthService();

  Future<List<Event>> retrieveEvents() async {
    try {
      final response = await supabase.from('events').select().order('high_light', ascending: false);

      debugPrint('Events response received: ${response != null ? 'yes' : 'no'}');

      if (response == null) {
        debugPrint('Error: Response is null');
        return [];
      }

      final events = (response as List<dynamic>).map((data) => Event.fromMap(data as Map<String, dynamic>)).toList();

      debugPrint('Successfully retrieved ${events.length} events');
      return events;
    } catch (e, stackTrace) {
      debugPrint('Error retrieving events: $e');
      debugPrint('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<List<Event>> retrieveUserEvents() async {
    try {
      final userId = await authService.getLoggedInUser();
      if (userId == null) {
        print('User not logged in');
        return [];
      }
      final response = await supabase.from('partcipants').select('event_id').eq('user_id', userId);

      if (response == null || response.isEmpty) {
        print('Error retrieving user events: $response');
        return [];
      }
      print(response);
      // final eventId = response.map((row) => row['event_id'] as int).toList();
      // final eventId = response.map((row) => row['event_id'] as int).toList();
      final eventId = (response as List<dynamic>).map((row) => row['event_id'] as int).toList();

      // final eventData =
      // final eventData = await supabase.from('events').select().eq('id', response); //this should retrieve the events  rows which match  the event_id in the participants table
      // final data = response as List<dynamic>;
      final eventData = await supabase.from('events').select().inFilter('id', eventId);
      print(eventData);

      if (eventData == null || eventData.isEmpty) {
        print("no matching events found");
        return [];
      }

      return (eventData as List<dynamic>).map((data) => Event.fromMap(data as Map<String, dynamic>)).toList();

      // return eventData as List<Event>;

      // return data.map((e) => Event.fromMap(e as Map<String, dynamic>)).toList();

      // return response as List<Event>;
    } catch (e) {
      print('Error retrieving user events: $e');
      return [];
    }
  }

  Future<void> participateEvent(
    int eventId,
  ) async {
    try {
      final userId = await authService.getLoggedInUser();

      // Retrieve the logged-in user's ID
      // final userId = await authService.getLoggedInUser();
      if (userId == null || userId.isEmpty) {
        print('User not logged in');
        return;
      }

      // Insert the user_id and event_id into the participants table
      final response = await supabase.from('partcipants').insert({
        'user_id': userId,
        'event_id': eventId,
      });
      print('Response: ${response.data}');

      if (response.error == null) {
        print('Successfully registered for the event');
      } else {
        print('Error inserting into participants table: ${response.error.message}');
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Error participating in event: $e'),
      // ));
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Error participating in event: $e')),
      );
      print('Error participating in event: $e');
    }
  }

  leaveEvent(
    int eventId,
  ) async {
    try {
      final userId = await authService.getLoggedInUser();
      if (userId == null) {
        debugPrint('User not logged in');
        return;
      }
      final response = await supabase
          .from('partcipants')
          .delete()
          .eq(
            'user_id',
            userId,
          )
          .eq('event_id', eventId);

      if (response != null) {
        debugPrint('Response: ${response.data}');
        if (response.error == null) {
          debugPrint('Successfully left the event');
        } else {
          debugPrint('Error deleting from participants table: ${response.error.message}');
        }
      } else {
        debugPrint('Response is null');
      }
    } catch (e) {
      debugPrint('Error leaving event: $e');
    }
  }

  isRegistered(int eventId) async {
    final userId = await authService.getLoggedInUser();
    if (userId == null) {
      print('User not logged in');
      return false;
    }

    final response = await supabase.from('partcipants').select().eq('user_id', userId).eq('event_id', eventId);

    if (response.isEmpty) {
      print('Error checking if user is registered: $response');
      return false;
    }

    return true;
  }
}
