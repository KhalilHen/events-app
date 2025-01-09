import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pt_events_app/auth/aut_gate.dart';
import 'package:pt_events_app/auth/auth_service.dart';
import 'package:pt_events_app/pages/homepage.dart';
import 'package:pt_events_app/pages/sign_up.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'routes/routes.dart  ';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;
  final authService = AuthService();
  bool passwordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> checkUser(BuildContext context, String email, String password, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      try {
        await authService.signInWithEmaiPassword(email, password).then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AuthGate()),
          ).then((_) {
            // Clear the form fields after navigation
            formKey.currentState!.reset();
          });
        }).catchError((e) {
          formKey.currentState!.reset();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid email or password: ' + e.toString()),
            ),
          );
        });
        // await supabase.auth.signInWithOtp(email: email).then((value) {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => AuthGate()),
        //   ).then((_) {
        //     // Clear the form fields after navigation
        //     formKey.currentState!.reset();
        //   });
        // }).catchError((e) {
        //   formKey.currentState!.reset();

        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('Invalid email or password: ' + e.toString()),
        //     ),
        //   );
        // });

        // await AuthService().signInWithEmaiPassword(email, password).then((value) {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => AuthGate()),
        //   ).then((_) {
        //     // Clear the form fields after navigation
        //     formKey.currentState!.reset();
        //   });
        // }).catchError((e) {
        //   formKey.currentState!.reset();

        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('Invalid email or password: ' + e.toString()),
        //     ),
        //   );
        // });
      } on AuthException catch (e) {
        SnackBar(
          content: Text('Something went wrong with the email or password: ' + e.toString()),
        );
      } catch (e) {
        SnackBar(
          content: Text('Something went wrong with the email or password: ' + e.toString()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,

                  decoration: InputDecoration(
                    suffixIcon: IconButton(onPressed: () => setState(() => passwordVisible = !passwordVisible), icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off)),
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: !passwordVisible,

                  // obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Navigate to sign-up screen
                    RichText(
                        text: TextSpan(
                      text: "Forgot Password?",
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamed(context, '/forgot-password'),
                    )),
                    RichText(
                        text: TextSpan(
                      text: "Don't have an account?",
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamed(context, '/signup'),
                    ))
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      checkUser(context, emailController.text, passwordController.text, formKey);
                    }
                  },
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
