import 'package:flutter/material.dart';
import 'package:mood_track/configs/theme/colors.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isObsecureText;
  final TextInputType textInputType;
  final String hintTitle;
  final String? Function(String?)? validator;
  final String? errorText;
  final Color borderColor;
  final IconData? prefixIcon;
  final Function(String)? onFieldSubmitted;
  final int? maxLines;

  const CustomTextFieldWidget({
    super.key,
    required this.controller,
    this.isObsecureText = false,
    required this.textInputType,
    required this.hintTitle,
    this.validator,
    this.errorText,
    this.borderColor = const Color(0xffa90084),
    this.onFieldSubmitted,
    this.prefixIcon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(18),
      color: AppColors.primaryColor.withOpacity(0.1),
      child: TextFormField(
          controller: controller,
          maxLines: maxLines,
          obscureText: isObsecureText,
          validator: validator,
          keyboardType: textInputType,
          onSaved: (value) {
            controller.text = value!;
          },
          textInputAction: TextInputAction.done,
          cursorColor: AppColors.primaryColor,
          decoration: InputDecoration(
            hintText: hintTitle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            hintStyle: const TextStyle(
              letterSpacing: 1.0,
              fontFamily: 'Inter',
            ),
            prefixIcon: Icon(prefixIcon),
            fillColor: AppColors.primaryColor.withOpacity(0.1),
            filled: true,
          )),
    );
  }
}
