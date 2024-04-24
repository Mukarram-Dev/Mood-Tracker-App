import 'package:flutter/material.dart';
import 'package:mood_track/configs/theme/colors.dart';
import 'package:mood_track/configs/theme/text_theme_style.dart';
import 'package:mood_track/view%20model/report%20provider/report_provider.dart.dart';
import 'package:provider/provider.dart';

class MonthlyReportView extends StatefulWidget {
  const MonthlyReportView({super.key});

  @override
  State<MonthlyReportView> createState() => _MonthlyReportViewState();
}

class _MonthlyReportViewState extends State<MonthlyReportView> {
  @override
  void initState() {
    super.initState();
    Provider.of<ReportProvider>(context, listen: false).getMoodHistory();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Monthly Mood Report',
            style: AppTextStyles.poppinsMedium(),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async =>
              await Provider.of<ReportProvider>(context, listen: false)
                  .getMoodHistory(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Consumer<ReportProvider>(
              builder: (context, value, child) {
                if (value.isHistoryLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMoodList(value),
                        const SizedBox(height: 20),
                        _buildAverageMood(),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodList(ReportProvider value) {
    if (value.moodHistoryList.isEmpty) {
      return const Center(
        child: Text('No mood entries yet.'),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mood History',
          style: AppTextStyles.poppinsNormal(),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: value.moodHistoryList.length,
          itemBuilder: (context, index) {
            final moodEntry = value.moodHistoryList[index];
            return Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.white,
                        child: Text(
                          moodEntry.feelingEmoji,
                          style: AppTextStyles.interHeading(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        moodEntry.feelingName,
                        style: AppTextStyles.poppinsNormal(),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    moodEntry.reason,
                    style: AppTextStyles.interBody(),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(moodEntry.date),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAverageMood() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          'Average Mood for the Month',
          style: AppTextStyles.poppinsNormal(),
        ),
        const SizedBox(height: 10),
        Consumer<ReportProvider>(
          builder: (context, value, child) => Text(
            'Average Mood: ${value.weeklyAverage.toStringAsFixed(1)}',
            style:
                AppTextStyles.interBody(), // You can adjust the style as needed
          ),
        ),
      ],
    );
  }
}