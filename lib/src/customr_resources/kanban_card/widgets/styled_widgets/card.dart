import 'package:flutter/material.dart';

class AppFlowyGroupCard extends StatelessWidget {
  const AppFlowyGroupCard({
    super.key,
    this.child,
    this.margin = const EdgeInsets.all(4),
    this.decoration = const BoxDecoration(),
    this.boxConstraints = const BoxConstraints(minHeight: 40),
    this.onTap
  });

  final Widget? child;
  final EdgeInsets margin;
  final BoxDecoration decoration;
  final BoxConstraints boxConstraints;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: margin,
        constraints: boxConstraints,
        decoration: decoration,
        child: child,
      ),
    );
  }
}
