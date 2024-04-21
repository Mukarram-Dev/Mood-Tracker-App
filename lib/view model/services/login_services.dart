import 'dart:async';
import 'package:mood_track/configs/routes/routes_name.dart';
import 'package:mood_track/data/firebase_services/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class LoginServices {
  void checkStatusAndLogin(context) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    late String profileStatus;
    await DataServices()
        .getProfileStatus(user?.uid ?? '', (error) => null)
        .then((value) => profileStatus = value);

    if (user != null) {
      Timer(const Duration(seconds: 5), () {
        // Check if the user is still logged in after the timer expires
        if (profileStatus.toLowerCase().contains('pending') ||
            profileStatus.toLowerCase().contains('rejected')) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, RouteName.pendingRoute);
        } else {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, RouteName.bottomNavRoute);
        }
      });
    }
  }
}
