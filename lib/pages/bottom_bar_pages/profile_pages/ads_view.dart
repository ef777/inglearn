// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use

import 'package:english_learn/const/colors.dart';
import 'package:flutter/material.dart';

class AdsView extends StatelessWidget {
  const AdsView({key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBlue,
      body: Container(
        width: double.infinity,
        height: 300,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: Colors.white,
        child: Column(
          children: [
            Text(
              "Premium olarak uygulamanın \ntadını çıkar",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            Image.asset(
              "/Users/kemalerkmen/Documents/flutter_projects/english_learn/assets/image/premium.jpeg",
              fit: BoxFit.cover,
              height: 200,
            )
          ],
        ),
      ),
    );
  }
}
