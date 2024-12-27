import 'package:flutter/material.dart';
import 'package:pt_events_app/auth/auth_service.dart';
import 'package:pt_events_app/auth/aut_gate.dart';
import 'package:supabase/supabase.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final getLoggedInUser = AuthService().getLoggedInUser();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Homepage',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Text('Welcome to the Homepage' + getLoggedInUser! ?? 'No user logged in'),
      ),
    );
  }
}
