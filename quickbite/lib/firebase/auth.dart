import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Method to get the current user
  Future<User?> getCurrentUser() async {
    return await auth.currentUser;
  }

  // Method to get the current user's ID
  String getCurrentUserId() {
    User? user = auth.currentUser;
    if (user != null) {
      return user.uid; // Returns the UID of the current user
    } else {
      throw Exception('No user is logged in');
    }
  }

  // Sign out method
  Future<void> SignOut() async {
    await auth.signOut();
  }

  // Delete user method
  Future<void> deleteuser() async {
    User? user = auth.currentUser;
    if (user != null) {
      await user.delete();
    }
  }
}
