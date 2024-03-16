import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../const/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    this.onPressed,
    this.height,
    this.width,
    this.color,
    this.focusNode,
  });
  final String title;
  final void Function()? onPressed;
  final double? height;
  final double? width;
  final Color? color;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height ?? 50,
        width: width ?? double.infinity,
        child: ElevatedButton(
            focusNode: focusNode,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: context.normalBorderRadius),
              backgroundColor: color ?? colorBlue,
            ),
            onPressed: onPressed,
            child: Text(title)));
  }
}
