import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pt_events_app/auth/auth_service.dart';
import 'package:pt_events_app/controllers/event_controllers.dart';
import 'package:pt_events_app/pages/card_view.dart';
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
           style: TextStyle(color: Colors.white)
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
                        tooltip: 'Logout',

              onPressed: () {
                authService.signOut(context);
              },
              icon: Icon(Icons.logout)),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $username!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 20),
              Text(
                'Your Events',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<Event>>(
                  future: eventController.retrieveUserEvents(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No events found.'));
                    }
        
                    final events = snapshot.data!;
                    return SizedBox(
                      height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return Container(
                            width: 300, // Fixed width for each card
                            padding: EdgeInsets.only(right: 16),
                            child: GestureDetector(
                                                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExpandedCardView(event: event))),
                      
                              child: Hero(
                            tag: event,
                      
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 7,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15),
                                        ),
                                        child:  
                                    event.image != null ? Image.network(event.image!)  :  Container(
                                
                                      height: 150,
                                      width: double.infinity,
                                        color: const Color(0xFF007BFF).withOpacity(0.1),
                                        child: Icon(Icons.event, size: 50, color: const Color(0xFF007BFF),),
                                
                                    ), 
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              event.title,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_today,
                                                  size: 16,
                                                  color: Color(0xFF007BFF),
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    '${DateFormat('yyyy-MM-dd').format(event.startDate)} - ${DateFormat('MM-dd-yyyy').format(event.endDate)}',
                                                    style: TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  size: 16,
                                                  color: Color(0xFF007BFF),
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    event.location ?? 'No location',
                                                    style: TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsets.all(16),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            eventController.leaveEvent(event.id);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF007BFF),
                                            foregroundColor: Colors.white,
                                            // minimumSize: Size(270, 48),
                                                                                      minimumSize: Size(double.infinity, 48),

                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Leave the event ',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ), 
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
        
            ],
          ),
        
        ),
      ),
      // child: Padding(
      //   padding: const EdgeInsets.only(top: 50.0),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     children: [
      //       Text(
      //         'Welcome, $username!',
      //         style: Theme.of(context).textTheme.titleMedium,
      //       ),
      //       SizedBox(height: 25),
      //       Text('Your signed up or featured events/activities', style: Theme.of(context).textTheme.titleMedium),
      //       SizedBox(height: 20),

      //       TextButton(
      //           onPressed: () {
      //             eventController.retrieveUserEvents();
      //           },
      //           child: Text('View Events')),
      //     ],
      //   ),
      // ),

      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
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
       
          ]),
    );
  }
}
