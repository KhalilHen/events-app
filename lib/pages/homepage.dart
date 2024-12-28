import 'package:flutter/material.dart';
import 'package:pt_events_app/auth/auth_service.dart';
import 'package:pt_events_app/auth/aut_gate.dart';
import 'package:supabase/supabase.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});
  final authService = AuthService();
  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;

    final getLoggedInUser = AuthService().getLoggedInUser();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Homepage',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                authService.signOut();
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      // body: SingleChildScrollView(
      //   child: Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text('Welcome to the Homepage' + getLoggedInUser! ?? 'No user logged in'))),
      // ),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome ' + (getLoggedInUser ?? 'No user logged in'), style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 20),
              Text('Your signed up of featured evens/activities ', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 20),
              Row(
                // Here comes the list of events that are signed up by the user
                children: [],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ]),
    );
  }
}
