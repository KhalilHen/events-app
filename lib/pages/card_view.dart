import 'package:flutter/material.dart';
import 'package:pt_events_app/custom_widgets/event_action_button.dart';
import 'package:pt_events_app/pages/event.dart';
import '../models/event_model.dart';
import 'package:intl/intl.dart';

class ExpandedCardView extends StatelessWidget {
  final Event event;
  const ExpandedCardView({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  //Doesn't appear
                  icon: Icon(Icons.close),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                    shape: WidgetStatePropertyAll(CircleBorder()),
                  ),
                  onPressed: () {
                    // Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventPage()));
                    //Doesn't work.
                  },
                ),
              ),
              Hero(
                tag: event.title,
                child: Material(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Stack(
                        // children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              child: Image.network(
                                // event.imageUrl,
                                'https://t3.ftcdn.net/jpg/00/72/98/56/360_F_72985661_LU1Xk0YQiPBwOuesuuJgwTn0NPlwP8ob.jpg',

                                fit: BoxFit.cover,
                                // fit: BoxFit.fill,
                                // fit: BoxFit.contain,
                                width: double.infinity,
                                height: 350,
                              ),
                            ),
                            Positioned(
                              top: 40,
                              left: 16,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withAlpha(230),
                                      Colors.white.withAlpha(179),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(51),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.arrow_back, color: Colors.black87),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withAlpha(51),
                                      Colors.black.withAlpha(153),
                                      Colors.black.withAlpha(204),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Event Category
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'General',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    // Event Title
                                    Stack(
                                      children: [
                                        Text(
                                          event.title,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                offset: Offset(0.5, 0.5),
                                                blurRadius: 3.0,
                                                color: Colors.black.withAlpha(128),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          event.title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(offset: Offset(-1, -1), color: Colors.black.withAlpha(77)),
                                              Shadow(offset: Offset(1, -1), color: Colors.black.withAlpha(77)),
                                              Shadow(offset: Offset(-1, 1), color: Colors.black.withAlpha(77)),
                                              Shadow(offset: Offset(1, 1), color: Colors.black.withAlpha(77)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Positioned(
                        //   bottom: 0,
                        //   left: 0,
                        //   right: 0,
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        //     decoration: BoxDecoration(
                        //       gradient: LinearGradient(
                        //         begin: Alignment.topCenter,
                        //         end: Alignment.bottomCenter,
                        //         colors: [
                        //           Colors.transparent,
                        //           Colors.black.withAlpha(51),
                        //           Colors.black.withAlpha(153),
                        //           Colors.black.withAlpha(204),
                        //         ],
                        //       ),
                        //     ),
                        //     child: Stack(
                        //       children: [
                        //         Text(
                        //           event.title,
                        //           style: TextStyle(
                        //             color: Colors.black,
                        //             fontSize: 24,
                        //             fontWeight: FontWeight.bold,
                        //             shadows: [
                        //               Shadow(
                        //                 offset: Offset(0.5, 0.5),
                        //                 blurRadius: 3.0,
                        //                 color: Colors.black.withAlpha(128),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //         // Main text with outline
                        //         Text(
                        //           event.title,
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontSize: 24,
                        //             fontWeight: FontWeight.bold,
                        //             shadows: [
                        //               Shadow(
                        //                 offset: Offset(-1, -1),
                        //                 color: Colors.black.withAlpha(77),
                        //               ),
                        //               Shadow(
                        //                 offset: Offset(1, -1),
                        //                 color: Colors.black.withAlpha(77),
                        //               ),
                        //               Shadow(
                        //                 offset: Offset(-1, 1),
                        //                 color: Colors.black.withAlpha(77),
                        //               ),
                        //               Shadow(
                        //                 offset: Offset(1, 1),
                        //                 color: Colors.black.withAlpha(77),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        // Column(
                        //   children: [],
                        // ),
                        Padding(padding: const EdgeInsets.only(top: 10)),

                        Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      size: 24,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                        child: Text(
                                      event.startDate != null ? ' ${DateFormat('dd-MM-yyyy').format(event.startDate)}  ${DateFormat('dd-MM-yyyy').format(event.endDate)} ' : 'No date available',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      size: 24,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                        child: Text(
                                      event.time,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 24,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                        child: Text(
                                      event.location,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Description Container

                        // Padding(padding: const EdgeInsets.all(10.0)),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Event Description',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),

                                // style: Theme.of(context).textTheme.titleMedium,
                              ),
                              SizedBox(height: 10),
                              Text(
                                event.description,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),

                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '---------------------------------------------------------------- ',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        //Addtional information container
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Additional information ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),

                                // style: Theme.of(context).textTheme.titleMedium,
                              ),
                              SizedBox(height: 10),
                              Text(
                                event.description,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),

                        // EventActionButton(eventId: event.id),
                        // EventActionButton(eventId: event.id),
                        // Padding(padding: const EdgeInsets.all(10.0)),
                        // ],

                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(51),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: EventActionButton(eventId: event.id),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
