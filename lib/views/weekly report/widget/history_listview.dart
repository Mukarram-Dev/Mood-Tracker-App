import 'package:flutter/material.dart';
import 'package:mood_track/configs/theme/colors.dart';
import 'package:mood_track/configs/theme/text_theme_style.dart';
import 'package:mood_track/model/mood_history.dart';

class HistoryListview extends StatelessWidget {
  final MoodHistory moodHistory;
  const HistoryListview({super.key, required this.moodHistory});

  @override
  Widget build(BuildContext context) {
    final dateParts = moodHistory.date.split(' ');

    // Check if the dateParts list is structured correctly to avoid index errors
    final month = dateParts.length > 1 ? dateParts[1].replaceAll(',', '') : '';

    final day = dateParts.isNotEmpty ? dateParts[0] : '';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.appBarColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            offset: const Offset(0, 3),
            blurRadius: 3,
            spreadRadius: 1,
          )
        ],
      ),
      child: ListTile(
        minVerticalPadding: 10,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        minLeadingWidth: 0,
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                month,
                style: AppTextStyles.poppinSmall(
                  color: AppColors.black.withOpacity(0.5),
                  fontSize: 16,
                ),
              ),
              Text(
                day,
                style: AppTextStyles.poppinsNormal(),
              ),
            ],
          ),
        ),
        title: Text(
          moodHistory.feelingName,
          style: AppTextStyles.poppinsNormal(),
        ),
        trailing: Text(
          moodHistory.feelingEmoji,
          style: const TextStyle(
            fontSize: 40,
          ),
        ),
        subtitle: Text(
          moodHistory.reason,
          style: AppTextStyles.interSmall(
            color: AppColors.blackLight,
          ),
        ),
      ),
    );
  }
}
