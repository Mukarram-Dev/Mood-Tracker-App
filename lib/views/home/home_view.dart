import 'package:animate_do/animate_do.dart';
import 'package:mood_track/configs/components/custom_text_field.dart';
import 'package:mood_track/configs/theme/colors.dart';
import 'package:mood_track/configs/theme/text_theme_style.dart';
import 'package:mood_track/utils/gaps.dart';
import 'package:mood_track/utils/utils.dart';
import 'package:mood_track/view%20model/home/home_view_model.dart';
import 'package:mood_track/view%20model/report%20provider/report_provider.dart.dart';
import 'package:flutter/material.dart';
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
    Future.delayed(Duration.zero, () {
      _fetchUserData();
    });
  }

  void _fetchUserData() async {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    final reportProvider = Provider.of<ReportProvider>(context, listen: false);
    await provider.setEmojiList();
    await provider.getUserData();
    await reportProvider.getMoodHistory();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: _buildFloatingButton(),
        body: SingleChildScrollView(
          child: FadeIn(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const HomeAppbarWidget(),
                const SizedBox(height: 20),
                _buildBodyWidget(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyWidget(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Recommendation For You',
              style: AppTextStyles.poppinsMedium(),
            ),
            const SizedBox(height: 20),
            _buildContainerSuggestion(context, value),
          ],
        ),
      ),
    );
  }

  Widget _buildContainerSuggestion(
      BuildContext context, HomeProvider provider) {
    if (provider.isActivityLoading) {
      return _shimmerCall(); // Shimmer effect while waiting for data
    } else {
      return _buildGridView(provider);
    }
  }

  Widget _buildFloatingButton() {
    return FloatingActionButton(
      shape: const StadiumBorder(),
      backgroundColor: AppColors.primaryColor,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => _buildAddFeelingDialog(context),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}

Widget _buildGridView(HomeProvider provider) {
  return GridView.builder(
    itemCount: provider.activityList.length,
    shrinkWrap: true,
    primary: false,
    physics: const ClampingScrollPhysics(),
    itemBuilder: (context, index) {
      final activity = provider.activityList[index];
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.appBarColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              offset: const Offset(0, 3),
              blurRadius: 5,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activity.name,
              style: AppTextStyles.poppinsNormal(),
            ),
            Text(
              activity.description,
              style: AppTextStyles.interBody(),
            ),
          ],
        ),
      );
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
    ),
  );
}

Widget _shimmerCall() {
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
      },
    ),
  );
}

Widget _buildAddFeelingDialog(BuildContext context) {
  return Consumer<HomeProvider>(
    builder: (context, value, child) => AlertDialog(
      title: Text(
        'Add New Feeling',
        style: AppTextStyles.poppinsNormal(),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextFieldWidget(
            controller: value.feelingController,
            textInputType: TextInputType.text,
            hintTitle: 'Feeling Name',
          ),
          Gaps.verticalGapOf(10),
          CustomTextFieldWidget(
            controller: value.feelingEmojiController,
            textInputType: TextInputType.text,
            hintTitle: 'Feeling Emoji',
            prefixIcon: Icons.emoji_emotions,
          ),
        ],
      ),
      buttonPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      actions: [
        ElevatedButton(
          child: const Text('Add Feeling'),
          onPressed: () async {
            await value.addEmoji().then((value) {
              Navigator.of(context).pop();
              return Utils.toastMessage('Feeling Added');
            });
          },
        ),
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
