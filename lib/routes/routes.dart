import 'package:flutter/material.dart ';
import 'package:pt_events_app/auth/aut_gate.dart';
import 'package:pt_events_app/login.dart';
import 'package:pt_events_app/pages/card_view.dart';
import 'package:pt_events_app/pages/homepage.dart';
import 'package:pt_events_app/pages/sign_up.dart';
import 'package:pt_events_app/pages/event.dart';

class AppRoutes {
  static const String authGate = '/auth_gate';
  static const String home = '/homepage';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String event = '/event';
  static const String eventDetails = '/event-details';  

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      authGate: (context) => const AuthGate(),
      home: (context) => Homepage(),
      login: (context) => const Login(),
      signup: (context) => const SignUp(),
      event : (context) =>  EventPage(),
      // eventDetails : (context) =>  ExpandedCardView(event: context,),
// eventDetails: (context) => ExpandedCardView(event: context),

    };
  }
}
