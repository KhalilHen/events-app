import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AuthService {
  final SupabaseClient supaBase = Supabase.instance.client;
  Timer? usernameDebounce;
  Timer? emailDebounce;

  Future<AuthResponse> signInWithEmaiPassword(String email, String password) async {
    return await supaBase.auth.signInWithPassword(password: password, email: email);
  }

  // Future<bool> isUsernameAvailable(String username) async {
  //   final response = await Supabase.instance.client.from('persons').select('username').eq('username', username).execute();

  //   if (response != null) {
  //     return false;
  //   }
  //   return response.data.isEmpty;
  //   // final response = await supaBase.from('persons').select().eq('username', username).execute();
  //   // if (response.error != null) {
  //   //   throw Exception("Database error: ${response.error?.message}");
  //   // }

  //   // return response.data == null || response.data!.length == 0;
  // }

//Sing up fuction
  Future<AuthResponse?> signUpWithEmaiPassword(String email, String password, String username) async {
    try {
      final response = await supaBase.auth.signUp(
        email: email,
        password: password,
        data: {
          'displayName': username,
        },
      );

      if (response.user != null) {
        final userId = response.user!.id;
        final insertResponse = await supaBase.from('persons').insert({
          'id': userId,
          'email': email,
          'username': username,
        });

        //TODO Fix that  there is a notification for the user that the account has been created successfully
        SnackBar(content: Text('User created successfully'));

        if (insertResponse.error != null) {
          throw Exception("Database error: ${insertResponse.error?.message}");
        }
        print("User created successfully");
      }

      return response;
    } on AuthException catch (e) {
      print(e.message);
    } catch (e) {
      print(e);

      throw Exception("Error during signup: $e");
    }
  }

  //Sign out function
  Future<void> signOut() async {
    await supaBase.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    //It sent's a  reset  password email but not yet working
    return await supaBase.auth.resetPasswordForEmail(email);
  }

  Future<String?> getLoggedInUsername() async {
    final session = supaBase.auth.currentSession;
    final userId = session?.user.id; 

    if (userId == null) {
      print('No authenticated user found.');
      return null; 
    }

    print('Authenticated User ID: $userId');

    // Query the persons table using the user's UUID
    final response = await supaBase
        .from('persons')
        .select('username') 
        .eq('id', userId) 
        .maybeSingle(); 

    if (response == null) {
      print('No matching person found for user ID: $userId');
      return null; 
    }


    final username = response['username'] as String?;
    print('Username: $username');
    return username;
  }

  // String? getLoggedInUserEmail() {
  //   final session = supaBase.auth.currentSession;
  //   final user = session?.user;
  //   // return user?.; //  TODO
  // }

  Future<bool> isUsernameAvailable(String username) async {
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
    // if (username.isEmpty) {}

    // final response = await Supabase.instance.client.from('persons').select('username').eq('username', username).execute();
    // final response = await Supabase.instance.client.select('persons').select('username', ).execute();
  }

  Future<bool> isEmailAvailable(String email) async {
    try {
      final response = await Supabase.instance.client.from('persons').select().match({'email': email}).maybeSingle();

      return response == null;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  void usernameListener(TextEditingController usernameController, Function(String) checkUsernameAvailability) {
    usernameController.addListener(() {
      if (usernameDebounce?.isActive ?? false) usernameDebounce?.cancel();
      usernameDebounce = Timer(const Duration(milliseconds: 500), () {
        checkUsernameAvailability(usernameController.text);
      });
    });
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidUsername(String username) {
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,}$');
    return usernameRegex.hasMatch(username);
  }
}
