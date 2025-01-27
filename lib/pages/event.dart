import 'package:flutter/material.dart';
import 'package:pt_events_app/auth/auth_service.dart';
import 'package:pt_events_app/custom_widgets/event_action_button.dart';
import 'package:pt_events_app/pages/card_view.dart';

import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/event_controllers.dart';
import '../routes/routes.dart';

import '../models/event_model.dart';
import 'package:intl/intl.dart';

class EventPage extends StatefulWidget {
  EventPage({Key? key}) : super(key: key);

  // final  eventModel = Event();

  // String get title => eventModel.title;

  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<EventPage> {
  final String fallbackImageUrl = 'https://t3.ftcdn.net/jpg/00/72/98/56/360_F_72985661_LU1Xk0YQiPBwOuesuuJgwTn0NPlwP8ob.jpg';

  int currentIndex = 1;
  final eventControllers = EventControllers();
  // late Future<List<Map<String, dynamic>>> retrieveEvents;
  // late Future<List<Event>>? retrieveEvents; // Make it nullable
  late Future<List<Event>> retrieveEvents;
  final authService = AuthService();
  @override
  void initState() {
    super.initState();
    eventControllers.retrieveEvents();
    // retrieveEvents = eventControllers.retrieveEvents(); // Initialize the future
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Logout',
            color: Colors.white,
            onPressed: () {
              authService.signOut(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<List<Event>>(
          future: eventControllers.retrieveEvents(),
          builder: (context, AsyncSnapshot<List<Event>> snapshot) {
            print('Connection State: ${snapshot.connectionState}');
            print('Has Error: ${snapshot.hasError}');
            print('Has Data: ${snapshot.hasData}');
            if (snapshot.hasData) {
              print('Data length: ${snapshot.data!.length}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}'); // Debug print

              // final events = snapshot.data ?? []; // Safe handling if data is null

              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No events available.'));
            }
            // else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //   return Center(child: Text('No events available.'));
            // }

            // final events = snapshot.data!;
            final events = snapshot.data ?? []; // Safe handling if data is null

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                // final  count = eventControllers.retrieveEvents().length;
                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExpandedCardView(event: event))),
                    // onTap: () =>  Navigator.pushNamed(context, '/detailedEvent', arguments: event),
                    //  Navigator.pushNamed(context, AppRoutes.event, arguments: event),
                    child: Hero(
                      // tag: event.id,
                      tag: event,
                      // tag: 'test',

                      child: Card(
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                        elevation: 4,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.s,
                            mainAxisSize: MainAxisSize.min,
                            // Image.asset()
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Stack(children: [
                                  eventImage(event),
                                  eventStatus(event),
                                  eventCategory(event),
                                ]),
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: customText(event.startDate, event.endDate),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Title container
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            event.title,
                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
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

                                    EventActionButton(eventId: event.id),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/homepage');
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

  Widget customText(DateTime startDate, DateTime endDate) {
    String status;
    if (DateTime.now().isBefore(startDate)) {
      status = 'Upcoming';
    } else if (DateTime.now().isAfter(endDate)) {
      status = 'Past';
    } else {
      status = 'Ongoing';
    }
    return Text(
      status,
      style: TextStyle(
        color: const Color(0xFF007BFF),
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget eventImage(Event event) {
    return event.image != null
        ? Image.network(
            event.image!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          )
        : Container(
            height: 200,
            width: double.infinity,
            color: Theme.of(context).primaryColor.withAlpha(24),
            child: Icon(
              Icons.event,
              size: 64,
              color: Theme.of(context).primaryColor,
            ),
          );
  }

  Widget eventStatus(Event event) {
    return Positioned(
        top: 16,
        right: 16,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
          child: Text(
            customText(event.startDate, event.endDate) as String,
            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ));
  }

  Widget eventCategory(Event event) {
    return Positioned(
        bottom: 16,
        left: 16,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            event.category ?? "No category",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }
}
