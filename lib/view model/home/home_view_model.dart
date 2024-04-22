import 'package:intl/intl.dart';
import 'package:mood_track/data/db/hive.dart';
import 'package:mood_track/model/mood_emoji.dart';
import 'package:mood_track/model/user_model.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  final String _currentDay = DateFormat('dd MMM, yyyy').format(DateTime.now());
  String get currentDay => _currentDay;

  String _selectedMood = 'Happy';
  String get selectedMood => _selectedMood;

  List<MoodEmoji> _listEmoji = [];
  List<MoodEmoji> get listEmoji => _listEmoji;

  final feelingController = TextEditingController();
  final feelingEmojiController = TextEditingController();

  final hiveService = HiveService();

  void setSelectedMood(String newVal) {
    _selectedMood = newVal;
    notifyListeners();
  }

  void formatDate(String date) {}

  Future<void> setEmojiList() async {
    _listEmoji = await hiveService.getEmojiList();
  }

  Future<void> addEmoji() async {
    await hiveService.addEmoji(
        'key_${feelingController.text.trim()}',
        MoodEmoji(
            moodEmoji: feelingEmojiController.text.trim(),
            moodTitle: feelingController.text.trim()));

    await setEmojiList();
  }
}
