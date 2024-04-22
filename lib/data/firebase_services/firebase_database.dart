import 'dart:async';
import 'package:mood_track/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DataServices {
  User? currentUser;
  final _authService = FirebaseAuth.instance;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  DataServices() {
    currentUser = _authService.currentUser;
  }

  Future<void> createUser({
    required Map<String, dynamic> data,
    required String userId,
    required Function(String error) onError,
  }) async {
    try {
      await _dbRef
          .child('Users')
          .child(userId)
          .set(data)
          .onError((error, stackTrace) => onError(error.toString()));
    } catch (error) {
      onError(error.toString());
    }
  }

  Future<void> addUserCurrentFeeling({
    required Map<String, dynamic> data,
    required String userId,
    required String dateTime,
    required Function(String error) onError,
    required Function() onSuccess,
  }) async {
    try {
      await _dbRef
          .child('Users')
          .child(userId)
          .child('user_moods')
          .child(dateTime)
          .set(data)
          .onError((error, stackTrace) => onError(error.toString()));

      onSuccess();
    } catch (error) {
      onError(error.toString());
    }
  }

  Future<void> updateUser(
    String uid,
    Map<String, String> data,
    Function() onSuccess,
    Function(String error) errorCallback,
  ) async {
    try {
      final dbRef = _dbRef.child("Users").child(uid);
      dbRef
          .update(data)
          .onError((error, stackTrace) => errorCallback(error.toString()));

      onSuccess();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

// Method to fetch user data from the Realtime Database
  Future<UserModel?> getCurrentUserData() async {
    try {
      // Get the current user's UID
      final String uid = _authService.currentUser?.uid ?? '';

      // Fetch the user data from the Realtime Database
      final event = await _dbRef.child("Users").child(uid).once();

      // Check if data exists
      if (event.snapshot.value != null) {
        // Parse the fetched data into a User object
        UserModel user = UserModel.fromMap(Map<String, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>));
        return user;
      } else {
        return null; // User data not found
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
