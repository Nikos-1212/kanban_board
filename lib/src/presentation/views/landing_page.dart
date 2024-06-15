import 'dart:math' as math;
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:task_tracker/src/config/themes.dart';
import 'package:task_tracker/src/utils/utils.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
    required this.nextScreen,
  });

  final Widget nextScreen;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      duration: 1800,
      splash: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ManageTheme.lightTheme.cardColor,
              ManageTheme.lightTheme.primaryColor
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Transform.rotate(
                angle: -119.78,
                child: CustomPaint(
                  painter: LetterFPainter(
                      color: ManageTheme.lightTheme.primaryColor,
                      strokeWidth: 2),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    nextScreen;
                    // Add navigation logic here
                  },
                  child: const Text(AppConst.continueBtn,
                      style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ],
        ),
      ),
      splashIconSize: double.infinity,
      screenFunction: () async {
        return nextScreen;
      },
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}

class LetterFPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double rotationAngle; // Angle in degrees

  LetterFPainter(
      {this.color = Colors.blue,
      this.strokeWidth = 2.0,
      this.rotationAngle = 60.0});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double halfStrokeWidth = strokeWidth / 2;

    final double circleRadius = math.min(width, height) / 3.2;
    final Offset circleCenter = Offset(width / 2, height / 2);

    final Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Path path = Path();

    // Draw circle
    canvas.drawCircle(
      circleCenter,
      circleRadius,
      paint,
    );

    // Calculate the position of the letter "F" to center it in the circle
    final double fWidth = circleRadius * 0.6;
    final double fHeight = circleRadius * 1.0;

    final double fTop = circleCenter.dy - fHeight / 2;
    final double fBottom = circleCenter.dy + fHeight / 2;
    final double fLeft = circleCenter.dx - fWidth / 2;
    final double fRight = circleCenter.dx + fWidth / 2;

    // Save the current canvas state
    canvas.save();

    // Apply rotation transformation
    canvas.translate(circleCenter.dx, circleCenter.dy);
    canvas.rotate(math.pi / 180 * rotationAngle); // Convert to radians
    canvas.translate(-circleCenter.dx, -circleCenter.dy);

    // Draw vertical line of the F
    path.moveTo(fLeft, fTop);
    path.lineTo(fLeft, fBottom);

    // Draw horizontal lines of the F
    path.moveTo(fLeft, fTop);
    path.lineTo(fRight, fTop);

    path.moveTo(fLeft, circleCenter.dy);
    path.lineTo(fRight, circleCenter.dy);

    // Restore the canvas state
    canvas.restore();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
