import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pt_events_app/auth/auth_service.dart';
import 'package:pt_events_app/controllers/event_controllers.dart';
import '../models/event_model.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final authService = AuthService();
  String? username;
  final eventController = EventControllers();

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

  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Welcome, $username!',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 25),
                Text('Your signed up or featured events/activities', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 20),
                FutureBuilder<List<Event>>(
                  future: eventController.retrieveUserEvents(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return Text('No events found.');
                    } else if (snapshot.hasData) {
                      final events = snapshot.data!;
                      return SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];
                            return Container(
                              // padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                              padding: EdgeInsets.all(15),

                              child: GestureDetector(
                                onTap: () => null,
                                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExpandedCardView(event: event))),
                                // onTap: () =>  Navigator.pushNamed(context, '/detailedEvent', arguments: event),
                                //  Navigator.pushNamed(context, AppRoutes.event, arguments: event),
                                child: Hero(
                                  // tag: event.id,
                                  tag: event,
                                  // tag: 'test',

                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    color: Colors.white,
                                    elevation: 7,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment.s,
                                        mainAxisSize: MainAxisSize.min,
                                        // Image.asset()
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(20.0), // think this makes it more beautifull

                                                child: InkWell(
                                                  child: Image.network(
                                                    'https://t3.ftcdn.net/jpg/00/72/98/56/360_F_72985661_LU1Xk0YQiPBwOuesuuJgwTn0NPlwP8ob.jpg',
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: 150,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                //Title container
                                                Row(
                                                  children: [
                                                    Text(
                                                      // event['title'] ?? 'No Title',

                                                      event.title, // Access title from the Event object

                                                      // 'Event Title',
                                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  //Date container

                                                  children: [
                                                    //Maby a  invidual  row for time
                                                    Wrap(
                                                      children: [
                                                        // Text(event.startDate ?? 'There is no date found'),
                                                        Icon(
                                                          Icons.calendar_today,
                                                          size: 16,
                                                          color: Color(0xFF007BFF),
                                                        ),
                                                        // const SizedBox(width: 8),
                                                        const SizedBox(width: 3),
                                                        Text(
                                                          // DateFormat('dd-MM-yyyy').format(event.startDate),

                                                          DateFormat('yyyy-MM-dd').format(event.startDate),
                                                        ),
                                                        Text(' - '),
                                                        Text(DateFormat('MM-dd-yyyy').format(event.endDate) // Access endDate from the Event object
                                                            ),

                                                        const SizedBox(width: 8),
                                                      ],
                                                    )
                                                  ],
                                                ),

                                                SizedBox(height: 10),

                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      size: 16,
                                                      color: Color(0xFF007BFF),
                                                    ),
                                                    Text(event.location ?? 'test location'),
                                                  ],
                                                ),
                                                SizedBox(height: 15),

                                                //Actions buttons

                                                // Image.network(' ')
                                              ],
                                            ),
                                          ),
                                          // ElevatedButton(
                                          //   onPressed: () {
                                          //     eventControllers.retrteveEvents(); //Too test whether it correctly retrieves the events
                                          //   },
                                          //   child: Text('View Event'),
                                          // ),
                                        ]
                                        // Image.network(' ')

                                        ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Text('Unexpected error occurred.');
                    }
                  },
                ),
                TextButton(
                    onPressed: () {
                      eventController.retrieveUserEvents();
                    },
                    child: Text('View Events')),
              ],
            ),
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
