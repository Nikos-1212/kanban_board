import 'package:flutter/material.dart';
import 'package:task_tracker/src/utils/utils.dart';

class InlinError extends StatelessWidget {
  const InlinError({super.key, required this.errorMessage});
  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style: TextStyle(
          fontSize: 11, color: AppColors.errorColour.withOpacity(0.7)),
      textAlign: TextAlign.left,
    );
  }
}
