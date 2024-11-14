import 'package:flutter/material.dart';
import 'package:mood_track/configs/theme/colors.dart';
import 'package:mood_track/configs/theme/text_theme_style.dart';
import 'package:mood_track/utils/gaps.dart';
import 'package:mood_track/view%20model/report%20provider/report_provider.dart';
import 'package:provider/provider.dart';

class TopAppbarWidget extends StatelessWidget {
  final String title;
  const TopAppbarWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 100,
            left: 100,
            child: Consumer<ReportProvider>(
              builder: (context, value, child) {
                final isMonthOrWeek = title.split(' ').first;
                final moodAverage =
                    isMonthOrWeek.toLowerCase().contains('weekly')
                        ? value.weeklyAverage
                        : value.monthlyAverage;

                return Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.blackLight,
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: AppColors.primaryColor,
                        child: CircleAvatar(
                          radius: 40,
                          child: moodAverage.isEmpty
                              ? const CircularProgressIndicator()
                              : Text(
                                  moodAverage,
                                  style: AppTextStyles.poppinsNormal(
                                    color: AppColors.black,
                                    fontSize: 50,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Gaps.verticalGapOf(20),
                    Text(
                      'Your $isMonthOrWeek Mood',
                      style: AppTextStyles.poppinsMedium(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            top: 60,
            left: 16,
            child: Text(
              title,
              style: AppTextStyles.poppinsMedium(
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
