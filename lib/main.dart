import 'package:flutter/material.dart';
import 'package:pt_events_app/auth/aut_gate.dart';
import 'package:pt_events_app/login.dart';
import 'package:pt_events_app/pages/forgot_password.dart';
import 'package:pt_events_app/pages/homepage.dart';
import 'package:pt_events_app/pages/sign_up.dart';
import 'package:pt_events_app/routes/routes.dart';
// import 'package:pt_events_app/pages/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // initialRoute: appRoutes.authGate(),

      // home: const SignUp(),
      home: const AuthGate(),
      routes: {
        AppRoutes.authGate: (context) => const AuthGate(),
        AppRoutes.login: (context) => const Login(),
        AppRoutes.home: (context) => const Homepage(),
        AppRoutes.signup: (context) => const SignUp(),
        AppRoutes.forgotPassword: (context) => const ForgotPassword(),
      },
    );
  }
}
