import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../const/colors.dart';

class TitleContainer extends StatelessWidget {
  const TitleContainer({
    super.key,
    required this.indexT,
    required this.count,
  });

  final int indexT;
  final int count;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: 80,
      decoration: BoxDecoration(
          color: colorBlue, borderRadius: context.normalBorderRadius),
      child: Center(
          child: Text(
        "$indexT/$count",
        style: context.textTheme.bodyLarge?.copyWith(color: Colors.white),
      )),
    );
  }
}
