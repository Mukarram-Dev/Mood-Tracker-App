import 'dart:async';
import 'package:mood_track/model/user_model.dart';
import 'package:mood_track/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DataServices {
  User? currentUser;
  final _authService = FirebaseAuth.instance;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  DataServices() {
    currentUser = _authService.currentUser;
  }

  Future<void> createUser(
      {required Map<String, dynamic> data,
      required String userId,
      required Function(String error) onError}) async {
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

  Future<String> getProfileStatus(
      String uid, Function(String error) errorCallBack) async {
    try {
      final res = _dbRef
          .child("Users")
          .child(uid)
          .child('profileStatus')
          .once()
          .then((value) => value.snapshot.value.toString())
          .onError((error, stackTrace) => errorCallBack(error.toString()));
      return res;
    } catch (e) {
      Utils.toastMessage(e.toString());
      throw Exception(e);
    }
  }

  Future<void> depositMoney({
    required Map<String, dynamic> data,
    required Function(String error) onError,
    required Function() onSuccess,
  }) async {
    try {
      await _dbRef
          .child('Users')
          .child(currentUser?.uid ?? '')
          .child('deposit')
          .push()
          .set(data)
          .onError((error, stackTrace) => onError(error.toString()));
      onSuccess();
    } catch (error) {
      onError(error.toString());
    }
  }

  Future<void> withdrawMoney(
      {required Map<String, dynamic> data,
      required Function(String error) onError}) async {
    try {
      await _dbRef
          .child('Users')
          .child(currentUser?.uid ?? '')
          .child('withdraw')
          .push()
          .set(data)
          .onError((error, stackTrace) => onError(error.toString()));
    } catch (error) {
      onError(error.toString());
    }
  }

  Future<DatabaseEvent> getPaymentDetails(
      String paymentMethod, Function(String error) errorCallBack) async {
    try {
      final res =
          _dbRef.child("Payment Method").child(paymentMethod).once().onError(
                (error, stackTrace) => errorCallBack(error.toString()),
              );
      return res;
    } catch (e) {
      Utils.toastMessage(e.toString());
      throw Exception(e);
    }
  }

  // Method to fetch user data from the Realtime Database
  Future<List<DataSnapshot>> getDepositHistory() async {
    try {
      final String uid = _authService.currentUser?.uid ?? '';
      final event =
          await _dbRef.child("Users").child(uid).child('deposit').once();

      List<DataSnapshot> depositSnapshots = [];

      await Future.forEach(event.snapshot.children, (element) {
        depositSnapshots.add(element);
      });

      return depositSnapshots;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<DataSnapshot>> getWithdrawHistory() async {
    try {
      final String uid = _authService.currentUser?.uid ?? '';
      final event =
          await _dbRef.child("Users").child(uid).child('withdraw').once();

      List<DataSnapshot> withdrawSnapshots = [];

      await Future.forEach(event.snapshot.children, (element) {
        withdrawSnapshots.add(element);
      });

      return withdrawSnapshots;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateItem(
      String itemId, String newName, String newDescription) async {
    final itemRef = _dbRef.child(itemId);
    await itemRef.update({
      'name': newName,
      'description': newDescription,
    });
  }

  Future<void> deleteItem(String itemId) async {
    final itemRef = _dbRef.child(itemId);
    await itemRef.remove();
  }
}
