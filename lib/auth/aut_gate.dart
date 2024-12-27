import 'package:flutter/material.dart';
import 'package:pt_events_app/login.dart';
import 'package:pt_events_app/pages/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }
        final session = snapshot.data?.session;
        if (session != null) {
          Future.microtask(() {
            Navigator.pushReplacementNamed(context, '/home');
          });
        } else {
          Future.microtask(() {
            Navigator.pushReplacementNamed(context, '/login');
          });
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
