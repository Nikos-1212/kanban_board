import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GeneralNavigator {
  final BuildContext context;
  final Widget page;
  final BlocProvider? blocProvider;

  GeneralNavigator(
      {required this.context, required this.page, this.blocProvider});

  Future<dynamic> navigate() async {
    return await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => _buildPage()),
    );
  }

  void replaceNavigate() {
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => _buildPage(),
      ),
    );
  }

  void pushAndRemove() {
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => _buildPage()),
        (route) => false);
  }

  Future<dynamic> fadeNavigate() {
    return Navigator.push(
      context,
      FadeNavigation(builder: (BuildContext context) => _buildPage()),
    );
  }

  Future<dynamic> navigateFromLeft() async {
    return await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => _buildPage(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  Future<dynamic> navigateFromRight() async {
    return await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => _buildPage(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  void navigateFromTop() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => _buildPage(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, -1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  void navigateFromBottom() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => _buildPage(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildPage() {
    return blocProvider == null ? page : blocProvider!;
  }
}

class FadeNavigation<T> extends PageRouteBuilder<T> {
  FadeNavigation({required WidgetBuilder builder})
      : super(
          pageBuilder: (_, __, ___) => builder(_),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
}

// class GeneralNavigator {
//   final BuildContext context;
//   final Widget page;
//   final BlocProvider? blocProvider;

//   GeneralNavigator({required this.context, required this.page,this.blocProvider});

//   Future<dynamic> navigate() async {
//     return await Navigator.push(
//       context,
//       CupertinoPageRoute(builder: (context) => page),
//     );
//   }

//   void replaceNavigate() {
//     Navigator.of(context).pushReplacement(
//       CupertinoPageRoute(
//         builder: (context) => page,
//       ),
//     );
//   }

//   void pushAndRemove() {
//     Navigator.pushAndRemoveUntil(context,
//         CupertinoPageRoute(builder: (context) => page), (route) => false);
//   }

//   Future<dynamic> fadeNavigate() {
//     return Navigator.push(
//       context,
//       FadeNavigation(builder: (BuildContext context) => page),
//     );
//   }

//   Future<dynamic> navigateFromLeft() async {
//     return await Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (_, __, ___) => page,
//         transitionsBuilder: (_, animation, __, child) {
//           return SlideTransition(
//             position: Tween<Offset>(
//               begin: const Offset(-1.0, 0.0),
//               end: Offset.zero,
//             ).animate(animation),
//             child: child,
//           );
//         },
//       ),
//     );
//   }

//   Future<dynamic> navigateFromRight() async {
//     return await Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (_, __, ___) => page,
//         transitionsBuilder: (_, animation, __, child) {
//           return SlideTransition(
//             position: Tween<Offset>(
//               begin: const Offset(1.0, 0.0),
//               end: Offset.zero,
//             ).animate(animation),
//             child: child,
//           );
//         },
//       ),
//     );
//   }

//   void navigateFromTop() {
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (_, __, ___) => page,
//         transitionsBuilder: (_, animation, __, child) {
//           return SlideTransition(
//             position: Tween<Offset>(
//               begin: const Offset(0.0, -1.0),
//               end: Offset.zero,
//             ).animate(animation),
//             child: child,
//           );
//         },
//       ),
//     );
//   }

//   void navigateFromBottom() {
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (_, __, ___) => page,
//         transitionsBuilder: (_, animation, __, child) {
//           return SlideTransition(
//             position: Tween<Offset>(
//               begin: const Offset(0.0, 1.0),
//               end: Offset.zero,
//             ).animate(animation),
//             child: child,
//           );
//         },
//       ),
//     );
//   }
// }

// class FadeNavigation<T> extends PageRouteBuilder<T> {
//   FadeNavigation({required WidgetBuilder builder})
//       : super(
//           pageBuilder: (_, __, ___) => builder(_),
//           transitionsBuilder: (_, animation, __, child) {
//             return FadeTransition(opacity: animation, child: child);
//           },
//           transitionDuration: const Duration(milliseconds: 400),
//         );
// }
