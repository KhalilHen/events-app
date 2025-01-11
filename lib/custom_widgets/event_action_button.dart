import 'package:flutter/material.dart ';
import 'package:pt_events_app/controllers/event_controllers.dart';

class EventActionButton extends StatefulWidget {
  final int eventId;

  const EventActionButton({Key? key, required this.eventId}) : super(key: key);

  @override
  _EventActionButtonState createState() => _EventActionButtonState();
}

class _EventActionButtonState extends State<EventActionButton> {
  bool? isRegistered;

  final eventController = EventControllers();
  @override
  void initState() {
    super.initState();
    fetchRegistrationStatus();
  }

  Future<void> fetchRegistrationStatus() async {
    final result = await eventController.isRegistered(widget.eventId);
    setState(() {
      isRegistered = result;
    });
  }

  void toggleRegistration() async {
    if (isRegistered == true) {
      await eventController.leaveEvent(widget.eventId);
    } else {
      await eventController.participateEvent(widget.eventId);
    }
    fetchRegistrationStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: ElevatedButton(
        onPressed: isRegistered == null ? null : toggleRegistration,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007BFF),
          foregroundColor: Colors.white,
          minimumSize: const Size(270, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          isRegistered == null
              ? 'Loading...' // Show loading text
              : isRegistered!
                  ? 'Leave Event'
                  : 'Register',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
