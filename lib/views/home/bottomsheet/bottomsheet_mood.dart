import 'package:flutter/material.dart';
import 'package:mood_track/configs/components/custom_button.dart';
import 'package:mood_track/configs/components/custom_text_field.dart';
import 'package:mood_track/configs/theme/colors.dart';
import 'package:mood_track/configs/theme/text_theme_style.dart';
import 'package:mood_track/model/mood_emoji.dart';
import 'package:mood_track/utils/app_constants.dart';
import 'package:mood_track/utils/dimensions.dart';
import 'package:mood_track/utils/gaps.dart';
import 'package:mood_track/view%20model/home/home_view_model.dart';
import 'package:provider/provider.dart';

class BottomSheetMood extends StatelessWidget {
  const BottomSheetMood({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Consumer<HomeProvider>(
            builder: (context, value, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Gaps.verticalGapOf(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'How are you feeling today?',
                      style: AppTextStyles.poppinsNormal(),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    )
                  ],
                ),
                Gaps.verticalGapOf(20),
                GridView.builder(
                  itemCount: AppConstants.listEmoji.length,
                  shrinkWrap: true,
                  primary: false,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) => _buildEmojiList(
                      context, AppConstants.listEmoji[index], value),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 20,
                    childAspectRatio: 3 / 2,
                  ),
                ),
                Gaps.verticalGapOf(20),
                CustomTextFieldWidget(
                  controller: TextEditingController(),
                  textInputType: TextInputType.multiline,
                  hintTitle: 'Reason for your mood',
                ),
                Gaps.verticalGapOf(20),
                CustomButtonWidget(
                  title: 'Submit',
                  onPress: () {},
                  width: double.infinity,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiList(
      BuildContext context, MoodEmoji listEmoji, HomeProvider value) {
    bool isSelected = value.selectedMood
        .toLowerCase()
        .contains(listEmoji.moodTitle.toLowerCase());
    return GestureDetector(
      onTap: () {
        value.setSelectedMood(listEmoji.moodTitle);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.appBarColor,
          border: Border.all(
              color:
                  isSelected ? AppColors.primaryColor : AppColors.appBarColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              listEmoji.moodEmoji,
              style: AppTextStyles.poppinsMedium(),
            ),
            Text(
              listEmoji.moodTitle,
              style: AppTextStyles.poppinsNormal(),
            ),
          ],
        ),
      ),
    );
  }
}
