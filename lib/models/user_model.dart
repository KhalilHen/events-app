import 'package:flutter/material.dart';

import 'package:supabase/supabase.dart';
import '../auth/aut_gate.dart';
import '../auth/auth_service.dart';

class User {
  final String username;
  final String email;
  final String password;

  User({
    required this.username,
    required this.email,
    required this.password,
  });

  ///Maby needed in future
  // factory User.fromMap(Map<String, dynamic> data) {
  //   return User(
  //     username: data['username'],
  //     email: data['email'],
  //     password: data['password'],
  //   );
  // }
}
