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

  bool isAvaible = false;
  String usernameError = '';
  Timer? debounce;

  @override
  void initState() {
    super.initState();

    usernameController.addListener(() {
      if (debounce?.isActive ?? false) debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        checkUsernameAvailability(usernameController.text);
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    usernameController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  Future<void> checkUsernameAvailability(String username) async {
    if (username.isEmpty) {
      setState(() {
        usernameError = 'Username cannot be empty';
        isAvaible = false;
      });
      return;
    }
    if (username.length < 3) {
      setState(() {
        usernameError = 'Username must be at least 3 characters';
        isAvaible = false;
      });
      return;
    }
    try {
      final available = await isUsernameAvailable(username);
      setState(() {
        isAvaible = available;
        usernameError = available ? '' : 'This username is already taken';
      });
    } catch (e) {
      setState(() {
        isAvaible = false;
        usernameError = 'An error occurred while checking the username';
      });
      print(e);
    }
    // Call the Supabase function
  }

  Future<bool> isUsernameAvailable(String username) async {
    // if (username.isEmpty) {}

    // final response = await Supabase.instance.client.from('persons').select('username').eq('username', username).execute();
    // final response = await Supabase.instance.client.select('persons').select('username', ).execute();

    try {
      // final response = await Supabase.instance.client.from('persons').select('username').eq('username', username).single();

      //Use mabyeSingle() instead of single() to avoid GET   error when the username is not found in the database
      //
      final response = await Supabase.instance.client.from('persons').select().match({'username': username}).maybeSingle();

      return response == null;
    } catch (e) {
      print('Error: $e');
      throw e;
    }

    final response = await Supabase.instance.client.from('persons').select('persons').execute(); //to test whether it can retrieve the whole table

    print('Response error: ${response.error}');
    print('Full response: $response');

    if (response.error != null) {
      throw Exception("Database error: ${response.error?.message}");
      // return false;
    }

    if (response.data is List && response.data.isEmpty) {
      return true; // Username is available
    }

    return response.data.isEmpty;

    // final response = await supaBase.from('persons').select().eq('username', username).execute();
    // if (response.error != null) {
    //   throw Exception("Database error: ${response.error?.message}");
    // }

    // return response.data == null || response.data!.length == 0;
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
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                    suffixIcon: isAvaible ? Icon(Icons.check, color: Colors.green) : Icon(Icons.error, color: Colors.red),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    } else if (value.length < 3) {
                      return 'Username must be at least 3 characters';
                    } else if (!isAvaible) {
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
