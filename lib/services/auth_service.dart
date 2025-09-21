import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // A method to sign in with email and password
  Future<UserCredential?> login(
      String email, String password, BuildContext context) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // DEBUGGING TIP: If login fails, check your Firebase project settings.
      // Make sure "Email/Password" sign-in is enabled in the Firebase Console
      // under Authentication > Sign-in method.
      _showErrorSnackBar(context, e.code);
      return null;
    } catch (e) {
      debugPrint('Login Error: ${e.toString()}');
      _showErrorSnackBar(context, 'An unexpected error occurred.');
      return null;
    }
  }

  // A method to sign up with email and password, now accepts a 'name' parameter
  Future<UserCredential?> signUp(
      String email, String password, BuildContext context, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update the user's profile with the provided name
      await userCredential.user?.updateDisplayName(name);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // DEBUGGING TIP: If sign-up fails, check your Firebase project settings.
      // Make sure "Email/Password" sign-in is enabled in the Firebase Console
      // under Authentication > Sign-in method.
      _showErrorSnackBar(context, e.code);
      return null;
    } catch (e) {
      debugPrint('Sign Up Error: ${e.toString()}');
      _showErrorSnackBar(context, 'An unexpected error occurred.');
      return null;
    }
  }

  // A method to sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  void _showErrorSnackBar(BuildContext context, String errorCode) {
    String message;
    switch (errorCode) {
      case 'user-not-found':
        message = 'No user found for that email.';
        break;
      case 'wrong-password':
        message = 'Wrong password provided for that user.';
        break;
      case 'email-already-in-use':
        message = 'The email address is already in use by another account.';
        break;
      case 'weak-password':
        message = 'The password provided is too weak.';
        break;
      default:
        message = 'An error occurred. Please try again.';
        break;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
