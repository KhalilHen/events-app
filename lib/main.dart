import 'package:flutter/material.dart';
import 'package:pt_events_app/auth/aut_gate.dart';
import 'package:pt_events_app/auth/styles/theme.dart';
import 'package:pt_events_app/login.dart';
import 'package:pt_events_app/pages/event.dart';
import 'package:pt_events_app/pages/forgot_password.dart';
import 'package:pt_events_app/pages/homepage.dart';
import 'package:pt_events_app/pages/sign_up.dart';
import 'package:pt_events_app/pages/test.dart';
import 'package:pt_events_app/routes/routes.dart';
// import 'package:pt_events_app/pages/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://lhytubtnsyzovyfrsqpm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxoeXR1YnRuc3l6b3Z5ZnJzcXBtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUzMTI0NzMsImV4cCI6MjA1MDg4ODQ3M30.N0_6Mk-r5H49vE26j7vze6NmezIqcclA0EPAlNaS0xs',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final appRoutes = AppRoutes();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
        primaryColor: ThemeColors.primaryColor,
        scaffoldBackgroundColor: ThemeColors.background,
        colorScheme: ColorScheme.light(
          primary: ThemeColors.primaryColor,
          secondary: ThemeColors.secondaryColor,
          surface: ThemeColors.background,
        ),
        textTheme: TextTheme(
          // headlineMedium: TextStyle(color: ThemeColors.textPrimary),
          titleMedium: TextStyle(color: ThemeColors.textPrimary),
          bodyMedium: TextStyle(color: ThemeColors.textSecondary),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // initialRoute: appRoutes.authGate(),

      // home: const SignUp(),
      // home: const AuthGate(),
      home: Homepage(), //Tempory to  test things out
      // home: EventPage(), //Temporarily while working on the  events page
      routes: {
        AppRoutes.authGate: (context) => const AuthGate(),
        AppRoutes.login: (context) => const Login(),
        AppRoutes.home: (context) => Homepage(),
        AppRoutes.signup: (context) => const SignUp(),
        AppRoutes.forgotPassword: (context) => const ForgotPassword(),
        AppRoutes.event: (context) => EventPage(),
      },
    );
  }
}
