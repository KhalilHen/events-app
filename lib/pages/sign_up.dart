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

  // bool isNameAvaible = false;
  bool? isNameAvaible;
  bool? isEmailAvailable;
  String usernameError = '';
  Timer? usernameDebounce;
  Timer? emailDebounce;

  @override
  void initState() {
    super.initState();

    usernameListener(usernameController, checkUsernameAvailability);
    // authService.emailListener(emailController, checkEmailAvailability);
    emailListener(emailController, checkEmailAvailability);
  }

  void usernameListener(TextEditingController usernameController, Function(String) checkUsernameAvailability) {
    usernameController.addListener(() {
      if (usernameDebounce?.isActive ?? false) usernameDebounce?.cancel();
      usernameDebounce = Timer(const Duration(milliseconds: 500), () {
        final username = usernameController.text;
        if (username.length > 3 && authService.isValidUsername(username)) {
          checkUsernameAvailability(usernameController.text);
        } else {
          setState(() {
            isNameAvaible = false;
          });
        }
      });
    });
  }

  emailListener(TextEditingController emailController, Function(String) checkEmailAvailability) {
    emailController.addListener(() {
      if (emailDebounce?.isActive ?? false) emailDebounce?.cancel();

      emailDebounce = Timer(const Duration(milliseconds: 2000), () {
        final email = emailController.text;
        if (authService.isValidEmail(email)) {
          checkEmailAvailability(email);
        } else {
          setState(() {});
        }
        checkEmailAvailability(emailController.text);
      });
    });
  }

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
    // if (email.isEmpty || email.length < 3) {
    //   setState(() {
    //     isEmailAvailable = false;
    //   });
    //   return;
    // }

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
        title: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.white),
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
                const Text(
                  'Sign  up!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email),
                    suffixIcon: isEmailAvailable == null
                        ? null
                        : isEmailAvailable!
                            ? const Icon(Icons.check, color: Colors.green)
                            : const Icon(Icons.error, color: Colors.red),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (value != null && !value.contains('@')) {
                      return 'Please enter a valid email';
                    } else if (isEmailAvailable == false) {
                      return 'This email is already taken';
                    } else if (usernameError.isNotEmpty) {
                      return usernameError;
                    }

                    // else if ()

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                    // suffixIcon: isNameAvaible ? Icon(Icons.check, color: Colors.green) : Icon(Icons.error, color: Colors.red),

                    suffixIcon: isNameAvaible == null
                        ? null
                        : isNameAvaible!
                            ? const Icon(Icons.check, color: Colors.green)
                            : const Icon(Icons.error, color: Colors.red),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    } else if (value.length < 3) {
                      return 'Username must be at least 3 characters';
                    } else if (isNameAvaible == false) {
                      return 'Username already taken';
                    } else if (usernameError.isNotEmpty) {
                      return usernameError;
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: const OutlineInputBorder(),
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password ',
                    hintText: 'Enter your password',
                    suffixIcon: IconButton(onPressed: () => setState(() => passwordVisible = !passwordVisible), icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off)),
                    border: const OutlineInputBorder(),
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // checkUser(context, emailController.text, passwordController.text, formKey);

                      // try {
                      authService.signUpWithEmaiPassword(
                        emailController.text,
                        passwordController.text,
                        usernameController.text,
                      );
                      //TODO Investigate this later it currently sents the user to homepage instead of login
                      Navigator.pushReplacementNamed(context, '/login');
                      // }

                      //  catch (e) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content: Text('Invalid email or password: ' + e.toString()),
                      //     ),
                      //   );
                      //   print(e);
                      //   formKey.currentState!.reset();
                      // }

                      // print('Email: ${emailController.text}');
                      // print('Password: ${passwordController.text}');
                    }
                  },
                  child: Text('Sign up!'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
