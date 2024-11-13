import 'package:flutter/material.dart';
import 'package:mood_track/configs/routes/routes_name.dart';
import 'package:mood_track/configs/theme/colors.dart';
import 'package:mood_track/configs/theme/text_theme_style.dart';
import 'package:mood_track/utils/app_constants.dart';
import 'package:mood_track/utils/gaps.dart';
import 'package:mood_track/view%20model/home/home_view_model.dart';
import 'package:mood_track/views/home/bottomsheet/bottomsheet_home.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeAppbarWidget extends StatelessWidget {
  const HomeAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
      ),
      child: Consumer<HomeProvider>(
        builder: (context, value, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.date_range_rounded,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
                Gaps.horizontalGapOf(5),
                Text(
                  value.currentDay,
                  style: AppTextStyles.interSmall(
                    color: AppColors.blackLight,
                  ),
                ),
              ],
            ),
            Gaps.verticalGapOf(10),
            _buildListTitleWidget(value, context),
            Gaps.verticalGapOf(20),
            _buildFeelingContainer(context),
          ],
        ),
      ),
    );
  }
}

Widget _shimmerName() {
  return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: const Text('Hi Name,'));
}

Widget _buildFeelingContainer(BuildContext context) {
  return GestureDetector(
    onTap: () => Navigator.pushNamed(context, RouteName.moodEntryRoute),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 5,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.emoji_emotions,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                Gaps.horizontalGapOf(5),
                Text(
                  'How are you feeling today?',
                  style: AppTextStyles.interBody(),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios_sharp)
          ],
        ),
      ),
    ),
  );
}

Widget _buildListTitleWidget(HomeProvider value, BuildContext context) {
  return ListTile(
    leading: const CircleAvatar(
      radius: 30,
      backgroundImage: NetworkImage(
        AppConstants.profilePic,
      ),
    ),
    minLeadingWidth: 0,
    contentPadding: const EdgeInsets.all(0),
    title: value.isUserLoading
        ? _shimmerName()
        : Text(
            'Hi ${value.userModel?.name.split(' ').first}!',
            style: AppTextStyles.poppinsMedium(),
          ),
    subtitle: Row(
      children: [
        Text(
          'Feeling Now',
          style: AppTextStyles.interBody(
            color: AppColors.hintText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gaps.horizontalGapOf(5),
        const Icon(
          Icons.circle,
          size: 10,
          color: AppColors.primaryColor,
        ),
        Gaps.horizontalGapOf(5),
        Text(
          '${value.userModel?.feelingEmoji} ${value.userModel?.userFeeling}',
          style: AppTextStyles.interBody(
            color: AppColors.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
    trailing: GestureDetector(
      onTap: () => showModalBottomSheet(
        builder: (context) => const BottomSheetHome(),
        context: context,
        elevation: 10,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        )),
        constraints:
            const BoxConstraints(minWidth: double.infinity, minHeight: 150),
        enableDrag: true,
        backgroundColor: Colors.transparent,
      ),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                offset: const Offset(0, 3),
                blurRadius: 5,
                spreadRadius: 1,
              )
            ]),
        child: const Center(
            child: Icon(
          Icons.settings,
          color: AppColors.primaryColor,
        )),
      ),
    ),
  );
}
