import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:mood_track/configs/components/custom_button.dart';
import 'package:mood_track/configs/components/custom_text_field.dart';
import 'package:mood_track/configs/theme/colors.dart';
import 'package:mood_track/configs/theme/text_theme_style.dart';
import 'package:mood_track/utils/gaps.dart';
import 'package:mood_track/utils/utils.dart';
import 'package:mood_track/view%20model/home/home_view_model.dart';
import 'package:mood_track/views/home/bottomsheet/bottomsheet_home.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mood_track/views/home/bottomsheet/bottomsheet_mood.dart';
import 'package:provider/provider.dart';

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
    // await provider.setUserModel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FadeIn(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAppBarWidget(context),
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Recommendation for your mood',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildContainerSuggestion(context),
        ],
      ),
    );
  }

  Widget _buildAppBarWidget(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                ),
                Gaps.horizontalGapOf(5),
                Text(
                  value.currentDay,
                  style: AppTextStyles.poppinSmall(),
                ),
              ],
            ),
            Gaps.verticalGapOf(10),
            ListTile(
              minLeadingWidth: 0,
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                'Hi, ${value.userModel?.username},',
                style: AppTextStyles.poppinsMedium(),
              ),
              subtitle: Text(
                'Welcome Back',
                style: AppTextStyles.interBody(),
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
                  constraints: const BoxConstraints(
                      minWidth: double.infinity, minHeight: 150),
                  enableDrag: true,
                  backgroundColor: Colors.transparent,
                ),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.hintText),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                      child: Icon(
                    Icons.settings,
                    color: AppColors.primaryColor,
                  )),
                ),
              ),
            ),
            Gaps.verticalGapOf(20),
            GestureDetector(
              onTap: () => showModalBottomSheet(
                builder: (context) => const BottomSheetMood(),
                context: context,
                elevation: 10,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                )),
                constraints: const BoxConstraints(
                    minWidth: double.infinity, minHeight: 150),
                enableDrag: true,
                backgroundColor: Colors.transparent,
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.4),
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
                                horizontal: 5, vertical: 5),
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                                child: Icon(
                              Icons.emoji_emotions,
                              color: AppColors.primaryColor,
                            )),
                          ),
                          Gaps.horizontalGapOf(5),
                          Text(
                            'How are you feeling today?',
                            style: AppTextStyles.interBody(),
                          )
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios_sharp)
                    ],
                  ),
                ),
              ),
            ),
            Gaps.verticalGapOf(10),
            GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => _buildAddFeelingDialog(context),
                  );
                },
                child: const Chip(label: Text('Add New Feeling')))
          ],
        ),
      ),
    );
  }

  Widget _buildAddFeelingDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add New Feeling',
        style: AppTextStyles.poppinsNormal(),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextFieldWidget(
            controller: TextEditingController(),
            textInputType: TextInputType.text,
            hintTitle: 'Feeling Name',
          ),
          Gaps.verticalGapOf(10),
          CustomTextFieldWidget(
            controller: TextEditingController(),
            textInputType: TextInputType.text,
            hintTitle: 'Feeling Name',
          ),
        ],
      ),
      buttonPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      actions: [
        ElevatedButton(
          child: const Text('Add Feeling'),
          onPressed: () {
            // Implement your logic here
          },
        ),
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildContainerSuggestion(BuildContext context) {
    return GridView.builder(
      itemCount: 4,
      shrinkWrap: true,
      primary: false,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: const BoxDecoration(
                    color: AppColors.appBarColor, shape: BoxShape.circle),
                child: const Icon(
                  Icons.face_retouching_natural_sharp,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            Text(
              'Meditation',
              style: AppTextStyles.poppinSmall(),
            ),
            Row(
              children: [
                Text(
                  'Meditation',
                  style: AppTextStyles.interSmall(),
                ),
                Gaps.horizontalGapOf(5),
                const Icon(
                  Icons.circle,
                  size: 5,
                ),
                Gaps.horizontalGapOf(5),
                Text(
                  '15 min',
                  style: AppTextStyles.interSmall(),
                ),
              ],
            ),
          ],
        ),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
      ),
    );
  }

  Widget _buildRowDetailWidget(String title, String itemName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.interBody(),
        ),
        Row(
          children: [
            Text(
              itemName,
              style: AppTextStyles.poppinSmall(
                  color: AppColors.primaryColor, fontWeight: FontWeight.bold),
            ),
            IconButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: itemName))
                      .whenComplete(() => Utils.toastMessage('Text Copied'));
                },
                icon: const Icon(Icons.copy)),
          ],
        ),
      ],
    );
  }
}
