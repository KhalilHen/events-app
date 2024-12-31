import 'package:flutter/material.dart';


import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class  EventControllers {
final supabase = Supabase.instance.client;
  // final SupabaseClient supaBase = Supabase.instance.client;




  retrieveEvents() {
    
    // return await supabase.from('events').select().execute();
  }
}