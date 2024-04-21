import 'package:intl/intl.dart';
import 'package:mood_track/data/firebase_services/firebase_database.dart';
import 'package:mood_track/model/user_model.dart';
import 'package:mood_track/utils/app_constants.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  final String _currentDay = DateFormat('dd MMM, yyyy').format(DateTime.now());
  String get currentDay => _currentDay;

  String _selectedMood = 'Happy';
  String get selectedMood => _selectedMood;

  void setSelectedMood(String newVal) {
    _selectedMood = newVal;
    notifyListeners();
  }

  void formatDate(String date) {}

  Future<void> setUserModel() async {
    final model = await DataServices().getCurrentUserData();
    _userModel = model;
    AppConstants.betProId = _userModel?.betProId ?? '';
    AppConstants.betProPass = _userModel?.betProPassword ?? '';
  }
}
