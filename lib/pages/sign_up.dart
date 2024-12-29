import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pt_events_app/auth/aut_gate.dart';
import 'package:pt_events_app/auth/auth_service.dart';
import 'package:pt_events_app/pages/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<bool> isUsernameAvailable(String username) async {
    final response = await Supabase.instance.client.from('persons').select('username').eq('username', username).execute();

    if (response != null) {
      return false;
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
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }

                    return null;
                  },
                  onFieldSubmitted: (value) async {
                    final available = await isUsernameAvailable(value);

                    if (!available) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Username already taken'),
                        ),
                      );
                    }
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
