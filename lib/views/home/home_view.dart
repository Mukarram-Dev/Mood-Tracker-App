import 'package:animate_do/animate_do.dart';
import 'package:mood_track/configs/theme/colors.dart';
import 'package:mood_track/configs/theme/text_theme_style.dart';
import 'package:mood_track/view%20model/home/home_view_model.dart';
import 'package:mood_track/view%20model/report%20provider/report_provider.dart';
import 'package:flutter/material.dart';
import 'package:mood_track/views/home/widgets/activity_card_widget.dart';
import 'package:mood_track/views/home/widgets/add_feeling_dialog.dart';
import 'package:mood_track/views/home/widgets/home_appbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() {
    context.read<HomeProvider>().getUserData();
    context.read<ReportProvider>().getMoodHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFloatingButton(),
      appBar: PreferredSize(
        preferredSize: Size(
          double.infinity,
          MediaQuery.of(context).size.height * 0.22,
        ),
        child: const HomeAppbarWidget(),
      ),
      body: SingleChildScrollView(
        child: FadeIn(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Recommended For You',
                      style: AppTextStyles.poppinsMedium(
                        color: AppColors.blackLight,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildContainerSuggestion(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingButton() {
    return FloatingActionButton(
      shape: const StadiumBorder(),
      backgroundColor: AppColors.primaryColor,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const AddFeelingDialog(),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _buildContainerSuggestion(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return provider.isActivityLoading
        ? _shimmerEffect()
        : _buildActivityGrid(provider);
  }
}

Widget _buildActivityGrid(HomeProvider provider) {
  return GridView.builder(
    itemCount: provider.activityList.length,
    shrinkWrap: true,
    primary: false,
    physics: const ClampingScrollPhysics(),
    itemBuilder: (context, index) {
      final activity = provider.activityList[index];
      return ActivityCard(activity: activity);
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
    ),
  );
}

Widget _shimmerEffect() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
      ),
      itemCount: 5,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return const ShimmerContainer();
      },
    ),
  );
}

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: const SizedBox(
        height: 80,
        width: 40,
      ),
    );
  }
}
