import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supaBase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmaiPassword(String email, String password) async {
    return await supaBase.auth.signInWithPassword(password: password, email: email);
  }

//Sing up fuction
  Future<AuthResponse> signUpWithEmaiPassword(String email, String password) async {
    return await supaBase.auth.signUp(email: email, password: password);
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
}

// extension on GoTrueClient {
//   get api => null;
// }
