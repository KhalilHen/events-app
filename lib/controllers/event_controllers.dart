import 'package:flutter/material.dart';

import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventControllers {
  final supabase = Supabase.instance.client;
  // final SupabaseClient supaBase = Supabase.instance.client;

  retrieveEvents() async {
    final response = await supabase.from('events').select().select();

    if (response == null) {
      print('Error retrieving events: ${response}');
      return [];
    }
    print('Events retrieved successfully ${response}');
    return response;
  }
}
