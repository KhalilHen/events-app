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
    final  String fallbackImageUrl = 'https://t3.ftcdn.net/jpg/00/72/98/56/360_F_72985661_LU1Xk0YQiPBwOuesuuJgwTn0NPlwP8ob.jpg';

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
      body: Padding(
        // padding: const EdgeInsets.all(8.0),
        padding: EdgeInsets.only(top: 30),
        child: FutureBuilder<List<Event>>(
            future: eventControllers.retrieveEvents(),
            builder: (context, AsyncSnapshot<List<Event>> snapshot) {
    print('Connection State: ${snapshot.connectionState}');
    print('Has Error: ${snapshot.hasError}');
    print('Has Data: ${snapshot.hasData}');
              if(snapshot.hasData) {

                print('Data length: ${snapshot.data!.length}');

              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');  // Debug print

                // final events = snapshot.data ?? []; // Safe handling if data is null

                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } 
 else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No events available.'));
              }
              // else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              //   return Center(child: Text('No events available.'));
              // }

              // final events = snapshot.data!;
              final events = snapshot.data ?? []; // Safe handling if data is null
              

              return ListView.builder(
         
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  // final  count = eventControllers.retrieveEvents().length;
                  return Container(
                    // padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                    padding: EdgeInsets.all(15),

                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExpandedCardView(event: event))),
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
  borderRadius: BorderRadius.circular(20.0), // For rounded corners
  child: InkWell(
    child:  event.image != null ? Image.network(event.image!)  :  Container(

      height: 200,
      width: double.infinity,
                                color: const Color(0xFF007BFF).withOpacity(0.1),
                                child: Icon(Icons.event, size: 50, color: const Color(0xFF007BFF),),

    ),
    

  ), 
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

                                        // Custom text widget
                                      ),
                                      //   child: Text(
                                      //     // DateTime.now().isBefore(event.startDate)
                                      //     //     ? 'Upcoming'
                                      //     //     : DateTime.now().isAfter(event.endDate)
                                      //     //         ? 'Past'
                                      //     //         : 'Ongoing',

                                      //     style: TextStyle(
                                      //       color: const Color(0xFF007BFF),
                                      //       fontSize: 12,
                                      //       fontWeight: FontWeight.bold,
                                      //     ),
                                      //   ),
                                      // ),
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
                                          Flexible(
                                            child: Text(
                                              // event['title'] ?? 'No Title',

                                              event.title, // Access title from the Event object
                                              // 'Event Title',
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

                                      //Actions buttons
                                      // EventActionButton(event: event, eventId: event.id),
                                      EventActionButton(eventId: event.id),

                                      // Padding(
                                      //   padding: EdgeInsets.all(2),
                                      //   child: ElevatedButton(
                                      //     onPressed: () {
                                      //       eventControllers.participateEvent(event.id);
                                      //     },
                                      //     style: ElevatedButton.styleFrom(
                                      //       backgroundColor: const Color(0xFF007BFF),
                                      //       foregroundColor: Colors.white,
                                      //       minimumSize: const Size(270, 48),
                                      //       shape: RoundedRectangleBorder(
                                      //         borderRadius: BorderRadius.circular(8),
                                      //       ),
                                      //     ),
                                      //     child: Text(
                                      //       // 'Register ',
                                      //       eventControllers.isRegistered(event.id) ? 'Leave Event' : 'Register',

                                      //       style: TextStyle(
                                      //         fontSize: 16,
                                      //         fontWeight: FontWeight.bold,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
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
              );
            }),
      ),

      // Text('Events', style: Theme.of(context).textTheme.titleMedium),

      // Container(
      //   decoration: BoxDecoration(
      //     border: Border.all(color: Color(0xFFE9ECEF), width: 2),
      //     // color: Color(0xFFE9ECEF),
      //   ),
      //   child: Card(
      //     // color: Color(0xFF605B56),
      //     // color: Theme.of(). ,
      //     // color: Theme.of(context).colorScheme.secondary,
      //     // color: Color(0xFFFFC107),

      //     // color: Color(0xFFF8F9FA),
      //     color: Color(0xFFF5F5F5),

      //     elevation: 5,
      //     margin: EdgeInsets.all(10),
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(15),
      //     ),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         // Event Image
      //         ClipRRect(
      //           borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      //           child: Image.network(
      //             'https://source.unsplash.com/600x400/?event',
      //             height: 150,
      //             width: double.infinity,
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //         // Event Info
      //         Padding(
      //           padding: const EdgeInsets.all(15.0),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               // Event Title
      //               Text(
      //                 'Flutter Workshop',
      //                 style: TextStyle(
      //                   fontSize: 18,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //               SizedBox(height: 8),
      //               // Event Date
      //               Row(
      //                 children: [
      //                   Icon(Icons.calendar_today, size: 16, color: Colors.grey),
      //                   SizedBox(width: 5),
      //                   Text(
      //                     'January 15, 2025',
      //                     style: TextStyle(color: Colors.grey),
      //                   ),
      //                 ],
      //               ),
      //               SizedBox(height: 8),
      //               // Event Description
      //               Text(
      //                 'Join us for an exciting workshop on building cross-platform apps with Flutter.',
      //                 style: TextStyle(fontSize: 14, color: Colors.grey[700]),
      //               ),
      //             ],
      //           ),
      //         ),
      //         // Buttons
      //         Padding(
      //           padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               TextButton(
      //                 onPressed: () {},
      //                 child: Text('Details'),
      //                 style: TextButton.styleFrom(
      //                   foregroundColor: Theme.of(context).primaryColor,
      //                 ),
      //               ),
      //               ElevatedButton(
      //                 onPressed: () {},
      //                 child: Text('Join'),
      //                 style: ElevatedButton.styleFrom(
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(10),
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),

      // Card(
      //   elevation: 5,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(15),
      //   ),
      //   shadowColor: Theme.of(context).primaryColor,
      //   child: Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Text(
      //           'Event Title',
      //           style: Theme.of(context).textTheme.titleMedium,
      //         ),
      //         SizedBox(height: 10),
      //         Text(
      //           'Event Description',
      //           style: Theme.of(context).textTheme.titleMedium,
      //         ),
      //         SizedBox(height: 10),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Text(
      //               'Event Date',
      //               style: Theme.of(context).textTheme.titleMedium,
      //             ),
      //             Text(
      //               'Event Location',
      //               style: Theme.of(context).textTheme.titleMedium,
      //             ),
      //           ],
      //         ),
      //         SizedBox(height: 20),
      //         Align(
      //           alignment: Alignment.centerRight,
      //           child: ElevatedButton(
      //             onPressed: () {
      //               eventControllers.retrieveEvents(); // Test whether it correctly retrieves the events
      //             },
      //             child: Text('View Event'),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      // Card(
      //   child: Column(
      //     children: [
      //       // Text('Event 1', style: Theme.of(context).textTheme.titleMedium),
      //       // Text('Event 1 Description', style: Theme.of(context).textTheme.titleMedium),
      //       // Text('Event 1 Date', style: Theme.of(context).textTheme.titleMedium),
      //       // Text('Event 1 Location', style: Theme.of(context).textTheme.titleMedium),

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
}
