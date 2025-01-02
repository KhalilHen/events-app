import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      //temporary to
      body: ListView.builder(
        itemCount: 33,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(left: 10, right: 10),
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
                              'data:image/jpeg;base64,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',
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
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Title container
                          Row(
                            children: [
                              Text(
                                'Event Name',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            //Date container
                            children: [
                              //Maby a  invidual  row for time
                              Wrap(
                                children: [Text('mon, 01 Jan  2025'), Text('12:00')],
                              )
                            ],
                          ),

                          SizedBox(height: 10),

                          Row(
                            children: [
                              Text('Event Location'),
                            ],
                          ),
                          SizedBox(height: 15),

                          //Actions buttons

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: null,
                                child: Text('Register'),
                              ),
                              ElevatedButton(onPressed: null, child: Text('More info') //Or Contact not sure yet,
                                  ),
                            ],
                          ),
                          // Image.network(' ')
                        ],
                      ),
                    )
                  ]
                  // Image.network(' ')

                  ),
            ),
          );
        },
      ),
    );
  }
}
