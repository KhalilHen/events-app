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
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerImage(),
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
}
