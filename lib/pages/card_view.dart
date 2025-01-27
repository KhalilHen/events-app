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
      body: Hero(
        tag: event,
        child: Material(
          child: CustomScrollView(
            slivers: [
              sliverAppBar(context),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    eventInfo(context),
                    eventDescription(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      floating: false,
      backgroundColor: Theme.of(context).primaryColor,
      leading: bacKButton(context),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            headerImage(),
            header(),
            headerContent(context),
          ],
        ),
      ),
    );
  }

  Widget bacKButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withAlpha(128),
      ),
      child: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black87,
          )),
    );
  }

  Widget headerImage() {
    return event.image != null
        ? Image.network(
            event.image!,
            fit: BoxFit.cover,
          )
        : Container(
            color: Colors.grey[200],
            child: Icon(
              Icons.event,
              size: 80,
              color: Colors.grey[400],
            ),
          );
  }

  Widget header() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
        Colors.transparent,
        Colors.black.withAlpha(179),
      ])),
    );
  }

  Widget headerContent(BuildContext context) {
    return Positioned(
        left: 16,
        right: 16,
        bottom: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Text(
                event.category ?? "general",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              event.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0, 2),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget eventInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          infoTile(
            context,
            Icons.calendar_month_outlined,
            'Date',
            '${DateFormat('MMM dd').format(event.startDate)} - ${DateFormat('MMM dd, yyyy').format(event.endDate)}',
          ),
          SizedBox(height: 12),
          infoTile(
            context,
            Icons.schedule,
            'Time',
            event.time.substring(0, 5), //Too display only the first 5 digits of the time . In other words 12:00/
          ),
          SizedBox(height: 12),
          infoTile(
            context,
            Icons.location_on,
            'Location',
            event.location,
          ),
        ],
      ),
    );
  }

  Widget infoTile(BuildContext context, IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget eventDescription() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Event description",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: Text(
              event.description,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
                height: 1.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}
