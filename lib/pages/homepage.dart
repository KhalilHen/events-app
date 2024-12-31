import 'package:flutter/material.dart';
import 'package:pt_events_app/auth/auth_service.dart';
import 'package:pt_events_app/auth/aut_gate.dart';
import 'package:supabase/supabase.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final authService = AuthService();
  String? username;

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    final fetchedUsername = await authService.getLoggedInUsername();
    setState(() {
      username = fetchedUsername ?? 'No user logged in';
    });
  }

  void testy() {}

  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;
    final authService = AuthService();
    // final username = AuthService().getLoggedInUsername();
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
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0), // Add padding to give breathing space from the appbar
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Welcome, $username!',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 25),
                Text('Your signed up of featured evens/activities ', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 20),
                Row(
                  // Here comes the list of events that are signed up by the user
                  children: [],
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/events');
                    },
                    child: Text('View Events')),
                // Remove the repeated TextButton widgets
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                setState(() {
                  currentIndex = 0;
                });
              },
              icon: Icon(Icons.home),
            ),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                setState(() {
                  currentIndex = 1;
                });
              },
              icon: Icon(Icons.event),
            ),
            label: 'Events'),
        BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                setState(() {
                  currentIndex = 2;
                });
              },
              icon: Icon(Icons.person),
            ),
            label: 'Profile'),
      ]),
    );
  }
}
