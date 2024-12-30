import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pt_events_app/auth/aut_gate.dart';
import 'package:pt_events_app/auth/auth_service.dart';
import 'package:pt_events_app/pages/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final authService = AuthService();
  bool passwordVisible = false;

  bool isNameAvaible = false;
  bool isEmailAvailable = false;
  String usernameError = '';
  Timer? usernameDebounce;
  Timer? emailDebounce;

  @override
  void initState() {
    super.initState();

    authService.usernameListener(usernameController, checkUsernameAvailability);
    authService.emailListener(emailController, checkEmailAvailability);
  }

  // usernameListener() {
  //   usernameController.addListener(() {
  //     if (usernameDebounce?.isActive ?? false) usernameDebounce?.cancel();
  //     usernameDebounce = Timer(const Duration(milliseconds: 500), () {
  //       checkUsernameAvailability(usernameController.text);
  //     });
  //   });
  // }

  // emailListener() {
  //   emailController.addListener(() {
  //     if (emailDebounce?.isActive ?? false) emailDebounce?.cancel();
  //     emailDebounce = Timer(const Duration(milliseconds: 500), () {
  //       checkEmailAvailability(emailController.text);
  //     });
  //   });
  // }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    usernameController.dispose();
    usernameDebounce?.cancel();
    emailDebounce?.cancel();
    super.dispose();
  }

  Future<void> checkUsernameAvailability(String username) async {
    if (username.isEmpty || username.length < 3) {
      setState(() {
        isNameAvaible = false;
      });
      return;
    }

    try {
      final available = await authService.isUsernameAvailable(username);
      setState(() {
        isNameAvaible = available;
      });
    } catch (e) {
      setState(() {
        isNameAvaible = false;
        usernameError = 'An error occurred while checking the username';
      });
      print(e);
    }
  }

  Future<void> checkEmailAvailability(String email) async {
    if (email.isEmpty || email.length < 3) {
      setState(() {
        isEmailAvailable = false;
      });
      return;
    }

    try {
      final available = await authService.isEmailAvailable(email);
      setState(() {
        isEmailAvailable = available;
      });
    } catch (e) {
      setState(() {
        isEmailAvailable = false;
        usernameError = 'An error occurred while checking the username';
      });
      print(e);
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
                    suffixIcon: isEmailAvailable ? Icon(Icons.check, color: Colors.green) : Icon(Icons.error, color: Colors.red),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (value != null && !value.contains('@')) {
                      return 'Please enter a valid email';
                    } else if (!isEmailAvailable) {
                      return 'This email is already taken';
                    } else if (usernameError.isNotEmpty) {
                      return usernameError;
                    }

                    // else if ()

                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                    suffixIcon: isNameAvaible ? Icon(Icons.check, color: Colors.green) : Icon(Icons.error, color: Colors.red),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    } else if (value.length < 3) {
                      return 'Username must be at least 3 characters';
                    } else if (!isNameAvaible) {
                      return 'Username already taken';
                    } else if (usernameError.isNotEmpty) {
                      return usernameError;
                    }

                    return null;
                  },
                  // onFieldSubmitted: (value) async {
                  //   final available = await isUsernameAvailable(value);

                  //   if (!available) {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(
                  //         content: Text('Username already taken'),
                  //       ),
                  //     );
                  //   }
                  // },
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // checkUser(context, emailController.text, passwordController.text, formKey);

                      try {
                        authService.signUpWithEmaiPassword(
                          emailController.text,
                          passwordController.text,
                          usernameController.text,
                        );

                        Navigator.pushReplacementNamed(context, '/login');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid email or password: ' + e.toString()),
                          ),
                        );
                        print(e);
                        formKey.currentState!.reset();
                      }

                      // print('Email: ${emailController.text}');
                      // print('Password: ${passwordController.text}');
                    }
                  },
                  child: Text('Sign up!'),
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

extension on PostgrestFilterBuilder<PostgrestList> {
  execute() {}
}
