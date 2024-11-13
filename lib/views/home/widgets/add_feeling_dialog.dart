import 'package:flutter/material.dart';
import 'package:mood_track/configs/components/custom_text_field.dart';
import 'package:mood_track/configs/theme/text_theme_style.dart';
import 'package:mood_track/utils/gaps.dart';
import 'package:mood_track/utils/utils.dart';
import 'package:mood_track/view%20model/home/home_view_model.dart';
import 'package:provider/provider.dart';

class AddFeelingDialog extends StatefulWidget {
  const AddFeelingDialog({super.key});

  @override
  State<AddFeelingDialog> createState() => _AddFeelingDialogState();
}

class _AddFeelingDialogState extends State<AddFeelingDialog> {
  final feelingController = TextEditingController();
  final feelingEmojiController = TextEditingController();
  @override
  void dispose() {
    feelingController.dispose();
    feelingEmojiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              controller: feelingController,
              textInputType: TextInputType.text,
              hintTitle: 'Feeling Name',
            ),
            Gaps.verticalGapOf(10),
            CustomTextFieldWidget(
              controller: feelingEmojiController,
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
              await value
                  .addEmoji(
                feelingController.text,
                feelingEmojiController.text,
              )
                  .then((value) {
                Navigator.of(context).pop();
                feelingController.clear();
                feelingEmojiController.clear();
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
}
