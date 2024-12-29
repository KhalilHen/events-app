import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class AuthService {
  final SupabaseClient supaBase = Supabase.instance.client;

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

  String? getLoggedInUser() {
    final session = supaBase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  String? getLoggedInUserEmail() {
    final session = supaBase.auth.currentSession;
    final user = session?.user;
    // return user?.; //  TODO
  }
}

// extension on GoTrueClient {
//   get api => null;
// }
