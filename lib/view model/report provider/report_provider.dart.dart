import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mood_track/data/firebase_services/firebase_database.dart';
import 'package:mood_track/model/mood_history.dart';

class ReportProvider extends ChangeNotifier {
  List<MoodHistory> _moodHistoryList = [];
  List<MoodHistory> get moodHistoryList => _moodHistoryList;

  bool _isHistoryLoading = true;
  bool get isHistoryLoading => _isHistoryLoading;

  final _dbService = DataServices();

  double _weeklyAverage = 0.0;
  double get weeklyAverage => _weeklyAverage;

  Future<void> getMoodHistory() async {
    try {
      _isHistoryLoading = true;

      final historyList = await _dbService.getUserMoodHistory();
      _moodHistoryList = historyList;
      await getWeeklyAverageMood();
      _isHistoryLoading = false;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching activity data: $error');
      }
      throw Exception(
          error); // Rethrow the error for higher-level error handling
    } finally {
      _isHistoryLoading = false;
    }
  }

  double calculateAverageMood(DateTime startDate, DateTime endDate) {
    final filteredMoods = _moodHistoryList.where((mood) {
      final date = DateFormat('dd MMM, yyyy - hh:mm a')
          .parse(mood.date, true); // Parse with lenient mode
      return date.isAfter(startDate) && date.isBefore(endDate) ||
          date.isAtSameMomentAs(startDate) ||
          date.isAtSameMomentAs(endDate); // Include dates at the boundaries
    }).toList();
    if (filteredMoods.isEmpty) {
      return 0.0; // Handle no mood entries in the period
    }

    final totalMoodValue =
        filteredMoods.fold(0, (sum, mood) => sum + mood.moodNo);
    return totalMoodValue / filteredMoods.length;
  }

  Future<double> getWeeklyAverageMood() async {
    final today = DateTime.now();
    final startDate = today.subtract(Duration(
        days:
            today.weekday - 1)); // Start from the beginning of the current week
    final endDate = today.add(Duration(
        days: DateTime.daysPerWeek -
            today.weekday)); // End at the end of the current week
    _weeklyAverage = calculateAverageMood(startDate, endDate);
    notifyListeners();
    return _weeklyAverage;
  }

  Map<String, List<int>> calculateWeeklyAverage() {
    // Initialize weekly data map
    Map<String, List<int>> weeklyData = {};

    // Iterate through mood history and calculate weekly averages
    for (var moodEntry in _moodHistoryList) {
      DateTime moodDate =
          DateFormat('dd MMM, yyyy - hh:mm a').parse(moodEntry.date);
      String weekOfYear = DateFormat('ww yyyy').format(moodDate);
      if (!weeklyData.containsKey(weekOfYear)) {
        weeklyData[weekOfYear] = [0, 0]; // mood sum, count
      }
      weeklyData[weekOfYear]![0] += moodEntry.moodNo;
      weeklyData[weekOfYear]![1]++;
    }

    // Calculate average for each week
    weeklyData.forEach((week, data) {
      if (data[1] > 0) {
        weeklyData[week]![0] = (weeklyData[week]![0] / data[1]).round();
      }
    });

    return weeklyData;
  }

  Map<String, List<int>> calculateMonthlyAverage() {
    // Initialize monthly data map
    Map<String, List<int>> monthlyData = {};

    // Iterate through mood history and calculate monthly averages
    for (var moodEntry in _moodHistoryList) {
      DateTime moodDate = DateFormat('dd MMM, yyyy').parse(moodEntry.date);
      String month = DateFormat('MMM yyyy').format(moodDate);
      if (!monthlyData.containsKey(month)) {
        monthlyData[month] = [0, 0]; // mood sum, count
      }
      monthlyData[month]![0] += moodEntry.moodNo;
      monthlyData[month]![1]++;
    }

    // Calculate average for each month
    monthlyData.forEach((month, data) {
      if (data[1] > 0) {
        monthlyData[month]![0] = (monthlyData[month]![0] / data[1]).round();
      }
    });

    return monthlyData;
  }
}
