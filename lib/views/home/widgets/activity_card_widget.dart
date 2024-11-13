import 'package:flutter/material.dart';
import 'package:mood_track/configs/theme/colors.dart';
import 'package:mood_track/configs/theme/text_theme_style.dart';
import 'package:mood_track/model/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            activity.name,
            style: AppTextStyles.interBody(
              fontWeight: FontWeight.w600,
              color: AppColors.blackLight,
            ),
          ),
          Flexible(
            child: Text(
              activity.description,
              style: AppTextStyles.interSmall(
                fontSize: 14,
                color: AppColors.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
