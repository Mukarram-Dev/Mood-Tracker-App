import 'package:flutter/material.dart';
import 'package:mood_track/configs/theme/text_theme_style.dart';

import 'package:mood_track/view%20model/report%20provider/report_provider.dart.dart';
import 'package:mood_track/views/weekly%20report/widget/history_listview.dart';
import 'package:mood_track/views/weekly%20report/widget/top_appbar_widget.dart';
import 'package:provider/provider.dart';

class WeeklyReportView extends StatefulWidget {
  const WeeklyReportView({super.key});

  @override
  _WeeklyReportViewState createState() => _WeeklyReportViewState();
}

class _WeeklyReportViewState extends State<WeeklyReportView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _fetchWeeklyHistory();
    });
  }

  _fetchWeeklyHistory() async {
    await Provider.of<ReportProvider>(context, listen: false)
        .getWeeklyMoodHistory(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
              Size(double.infinity, MediaQuery.of(context).size.height * 0.21),
          child: const TopAppbarWidget(title: 'Weekly Report')),
      body: RefreshIndicator(
        onRefresh: () async =>
            await Provider.of<ReportProvider>(context, listen: false)
                .getWeeklyMoodHistory(DateTime.now()),
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
                      const SizedBox(height: 20),
                      _buildMoodList(value),
                    ],
                  ),
                );
              }
            },
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
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: value.moodHistoryList.length,
          itemBuilder: (context, index) {
            final moodEntry = value.moodHistoryList[index];
            return HistoryListview(moodHistory: moodEntry);
          },
        ),
      ],
    );
  }
}
