import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pt_events_app/auth/aut_gate.dart';
import 'package:pt_events_app/auth/auth_service.dart';
import 'package:pt_events_app/pages/homepage.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final confirmPasswordController = TextEditingController();
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
      await AuthService().signInWithEmaiPassword(email, password).then((value) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign  up!',
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
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (value != null && !value.contains('@')) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(onPressed: () => setState(() => passwordVisible = !passwordVisible), icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off)),
                  ),
                  obscureText: !passwordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password ',
                    hintText: 'Enter your password',
                    suffixIcon: IconButton(onPressed: () => setState(() => passwordVisible = !passwordVisible), icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off)),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: !passwordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value != passwordController.text) {
                      return 'Passwords do not match';
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
                      recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamed(context, '/forgot password'),
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
                      // checkUser(context, emailController.text, passwordController.text, formKey);

                      try {
                        authService.signUpWithEmaiPassword(
                          emailController.text,
                          passwordController.text,
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid email or password: ' + e.toString()),
                          ),
                        );
                        print(e);
                      }

                      // print('Email: ${emailController.text}');
                      // print('Password: ${passwordController.text}');
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
