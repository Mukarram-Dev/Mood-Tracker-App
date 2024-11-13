import 'package:flutter/material.dart';
import 'package:mood_track/configs/theme/text_theme_style.dart';
import 'package:mood_track/view%20model/report%20provider/report_provider.dart';
import 'package:mood_track/views/weekly%20report/widget/history_listview.dart';
import 'package:mood_track/views/weekly%20report/widget/top_appbar_widget.dart';
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
    _fetchMonthlyHistory();
  }

  Future<void> _fetchMonthlyHistory() async {
    await Provider.of<ReportProvider>(context, listen: false)
        .getMonthlyMoodHistory(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size(double.infinity, MediaQuery.of(context).size.height * 0.21),
        child: const TopAppbarWidget(title: 'Monthly Report'),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchMonthlyHistory,
        child: Consumer<ReportProvider>(
          builder: (context, reportProvider, child) {
            if (reportProvider.isHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: reportProvider.moodHistoryList.isEmpty
                        ? const SliverFillRemaining(
                            child: Center(
                              child: Text('No mood entries yet.'),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final moodEntry =
                                    reportProvider.moodHistoryList[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (index == 0)
                                      Text(
                                        'Mood History',
                                        style: AppTextStyles.poppinsNormal(),
                                      ),
                                    const SizedBox(height: 10),
                                    HistoryListview(moodHistory: moodEntry),
                                    const SizedBox(height: 20),
                                  ],
                                );
                              },
                              childCount: reportProvider.moodHistoryList.length,
                            ),
                          ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
