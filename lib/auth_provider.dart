import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AUTHProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  AUTHProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;

  bool get isLoggedIn => _user != null;

  Future<void> login(String email, String password) async {
   dynamic userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
   SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setString("UID", userCredential.user!.uid);

  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
