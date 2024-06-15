import 'package:flutter/material.dart';
import 'package:task_tracker/src/utils/utils.dart';
import 'package:lottie/lottie.dart';

import 'gradient_background.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        image: Appimages.background,
        child: Center(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              AppColors.primaryColour,
              BlendMode.srcIn,
            ),
            child: Lottie.asset(
              Appimages.construction,
            ),
          ),
        ),
      ),
    );
  }
}
