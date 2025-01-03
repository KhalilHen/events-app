import 'package:flutter/material.dart';
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
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(CircleBorder()),
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
                        ClipRRect(
                          borderRadius: BorderRadius.only(
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
                        // Column(
                        //   children: [],
                        // ),
                        Text(
                          event.title,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(padding: const EdgeInsets.only(left: 5)),
                            //Row container for date,  time
                            Icon(
                              Icons.calendar_today,
                              size: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              // event.startDate,
                              DateFormat('dd-MM-yyyy').format(event.startDate),

                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),

                            Icon(
                              Icons.minimize,
                              size: 15,
                            ),
                            // Text(
                            //   ' - ',
                            //   style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            //   // DateForm(event.startDate)
                            // ),
                            Text(
                              DateFormat('dd-MM-yyyy').format(event.endDate),

                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              // DateForm(event.startDate)
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(padding: const EdgeInsets.only(left: 5)),
                            Icon(
                              Icons.access_time,
                              size: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('16:00 - 18:00', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        //Description Container

                        // Padding(padding: const EdgeInsets.all(10.0)),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: [
                              Text(
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),

                        // Button containers

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Add your onPressed code here!
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              child: Text(
                                'Join Event',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     // Add your onPressed code here!
                            //   },
                            //   style: ElevatedButton.styleFrom(
                            //     primary: Colors.red,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(18.0),
                            //     ),
                            //     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            //   ),
                            //   child: Text(
                            //     'Cancel',
                            //     style: TextStyle(fontSize: 16),
                            //   ),
                            // ),
                          ],
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
                        //Location Container
                        const Column(
                          children: [
                            Row(
                              children: [
                                Padding(padding: const EdgeInsets.only(left: 5)),
                                Icon(
                                  Icons.location_on,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Location:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(padding: const EdgeInsets.only(left: 5)),
                                Text(' Amsterdam Centraal', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              ],
                            ),

                            //TODO Mabye in the future here a Google maps/Apple maps intergration
                          ],
                        ),
                        Padding(padding: const EdgeInsets.only(top: 60)),
                        //Addtional information container
                        Column(
                          children: [
                            Center(
                              child: Text(
                                'Additional Information',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            const Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  spacing: 8.0,
                                  runSpacing: 4.0,
                                  children: [
                                    Text(
                                      'lorem ipsum dolor sit amet  ',
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // ],
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
