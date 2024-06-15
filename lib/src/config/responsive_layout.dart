import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive(
      {super.key,
      required this.mobile,
      required this.tablet,
      required this.desktop});

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 850 &&
      MediaQuery.of(context).size.width < 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    if (isDesktop(context)) {
      return desktop;
    } else if (isMobile(context)) {
      return mobile;
    } else {
      return tablet;
    }
  }
}


// class ResponsiveLayout extends StatelessWidget {
//   final Widget mobileBody;
//   final Widget tabletBody;
//   final Widget desktopBody;

//   const ResponsiveLayout({
//     super.key,
//     required this.mobileBody,
//     required this.tabletBody,
//     required this.desktopBody,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         if (constraints.maxWidth < 850) {
//           return mobileBody;
//         } else if (constraints.maxWidth>=850 && constraints.maxWidth <= 1100) {
//           return tabletBody;
//         } else {
//           return desktopBody;
//         }
//       },
//     );
//   }
// }
