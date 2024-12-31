import 'package:flutter/material.dart';

import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/event_controllers.dart';
import '../routes/routes.dart';

class Event extends StatefulWidget {
  Event({Key? key}) : super(key: key);

  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  int currentIndex = 1;
  final eventControllers = EventControllers();
  @override
  void initState() {
    super.initState();
    eventControllers.retrieveEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events', style: Theme.of(context).textTheme.titleMedium),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Events', style: Theme.of(context).textTheme.titleMedium),
              Padding(padding: EdgeInsets.all(10)),
              Card(
                child: Column(
                  children: [
                    Text('Event 1', style: Theme.of(context).textTheme.titleMedium),
                    Text('Event 1 Description', style: Theme.of(context).textTheme.titleMedium),
                    Text('Event 1 Date', style: Theme.of(context).textTheme.titleMedium),
                    Text('Event 1 Location', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/home');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/event');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/profile');
                break;
            }
          },
          items: [
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
