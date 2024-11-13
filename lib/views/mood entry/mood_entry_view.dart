import 'package:flutter/material.dart';
import 'package:mood_track/configs/components/custom_button.dart';
import 'package:mood_track/configs/components/custom_dialog_widget.dart';
import 'package:mood_track/configs/components/custom_text_field.dart';
import 'package:mood_track/configs/theme/colors.dart';
import 'package:mood_track/configs/theme/text_theme_style.dart';
import 'package:mood_track/model/mood_emoji.dart';
import 'package:mood_track/utils/dimensions.dart';
import 'package:mood_track/utils/gaps.dart';
import 'package:mood_track/utils/utils.dart';
import 'package:mood_track/view%20model/home/home_view_model.dart';
import 'package:provider/provider.dart';

class MoodEntryView extends StatefulWidget {
  const MoodEntryView({super.key});

  @override
  State<MoodEntryView> createState() => _MoodEntryViewState();
}

class _MoodEntryViewState extends State<MoodEntryView> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    context.read<HomeProvider>().setEmojiList();
    super.initState();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _showLoadingDialog(BuildContext context, String message) {
    CustomDialogWidget.dialogLoading(msg: message, context: context);
  }

  void _showErrorMessage(BuildContext context, String message) {
    Utils.flushBarErrorMessage(message, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Consumer<HomeProvider>(
          builder: (context, homeProvider, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.verticalGapOf(20),
              _buildSectionTitle('How are you feeling today?'),
              Gaps.verticalGapOf(20),
              _buildEmojiGrid(homeProvider),
              Gaps.verticalGapOf(20),
              _buildSectionTitle('Reason For Your Mood?'),
              Gaps.verticalGapOf(20),
              CustomTextFieldWidget(
                controller: _reasonController,
                textInputType: TextInputType.multiline,
                maxLines: 4,
                hintTitle: 'Reason for your mood',
              ),
              Gaps.verticalGapOf(20),
              _buildSubmitButton(homeProvider),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: MediaQuery.of(context).size.height * 0.08,
      backgroundColor: AppColors.primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(40),
          bottomLeft: Radius.circular(40),
        ),
      ),
      title: Text(
        'Your Feeling Today',
        style: AppTextStyles.poppinsMedium(color: AppColors.secondaryColor),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.poppinsNormal(),
    );
  }

  Widget _buildEmojiGrid(HomeProvider homeProvider) {
    return GridView.builder(
      itemCount: homeProvider.listEmoji.length,
      shrinkWrap: true,
      primary: false,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) => _buildEmojiTile(
        homeProvider.listEmoji[index],
        homeProvider,
        index,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 20,
        childAspectRatio: 3 / 2,
      ),
    );
  }

  Widget _buildEmojiTile(
      MoodEmoji moodEmoji, HomeProvider homeProvider, int index) {
    final isSelected = homeProvider.selectedMood
        .toLowerCase()
        .contains(moodEmoji.moodTitle.toLowerCase());

    return GestureDetector(
      onTap: () => homeProvider.setSelectedMood(moodEmoji.moodTitle, index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.appBarColor,
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.appBarColor,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              moodEmoji.moodEmoji,
              style: AppTextStyles.poppinsMedium(fontSize: 30),
            ),
            Text(
              moodEmoji.moodTitle,
              style: AppTextStyles.poppinsNormal(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(HomeProvider homeProvider) {
    return CustomButtonWidget(
      title: 'Submit',
      onPress: () async {
        if (_reasonController.text.isEmpty) {
          _showErrorMessage(context, 'Field can\'t be empty');
        } else {
          _showLoadingDialog(context, 'Adding Your Current Mood');
          await homeProvider
              .addUserCurrentMood(_reasonController.text)
              .then((_) {
            Utils.toastMessage('Added Successfully');
            _reasonController.clear();
            homeProvider.resetReasonController();
          }).whenComplete(() => Navigator.pop(context));
        }
      },
      width: double.infinity,
    );
  }
}
