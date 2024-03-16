import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class LeanCardWidget extends StatelessWidget {
  const LeanCardWidget({
    super.key,
    required this.title,
    this.color,
    required this.desc,
  });
  final String title;
  final String desc;

  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      height: context.height * .26,
      decoration: BoxDecoration(
          borderRadius: context.normalBorderRadius,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                spreadRadius: 2,
                blurRadius: 10,
                color: Colors.grey.withOpacity(.2))
          ]),
      child: Padding(
        padding: context.paddingLow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.textTheme.titleLarge
                  ?.copyWith(color: color ?? Colors.black),
            ),
            SizedBox(
              height: context.width * .04,
            ),
            Text(
              desc,
              style:
                  context.textTheme.bodyMedium?.copyWith(color: Colors.black54),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
