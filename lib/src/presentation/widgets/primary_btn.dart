import 'package:flutter/material.dart';
import 'package:task_tracker/src/utils/utils.dart';

class GradientPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? height;
  final List<Color> linearcolors;
  final Color? buttonColor;
  final Color textColor;
  final bool? enableFeedback;
  const GradientPrimaryButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.height = 45,
      this.linearcolors = AppColors.btnBorderGradient,
      this.buttonColor,
      this.enableFeedback = true,
      required this.textColor});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            buttonColor ?? const Color(0x8000CE08),
          ),
          textStyle: MaterialStateProperty.all(TextStyle(color: textColor)),
        ),
        onPressed: !enableFeedback! ? null : onPressed,
        child: Text(
          text,
          style:
              const TextStyle(fontSize: 13.8, color: AppColors.secondaryColour),
        ),
      ),
    );
  }
}
