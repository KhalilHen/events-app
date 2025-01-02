import 'package:flutter/material.dart';

import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_model.dart';

class EventControllers {
  final supabase = Supabase.instance.client;
  // final SupabaseClient supaBase = Supabase.instance.client;

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
}

extension on PostgrestFilterBuilder<PostgrestList> {
  execute() {}
}
