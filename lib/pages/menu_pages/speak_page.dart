import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class SpeakPage extends StatelessWidget {
  const SpeakPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Konuşma Grubu'),
      ),
      body: Padding(
        padding: context.paddingMedium,
        child: const SpeakPageWidget(),
      ),
    );
  }
}

class SpeakPageWidget extends StatelessWidget {
  const SpeakPageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.paddingLow,
      height: context.height * .55,
      decoration: BoxDecoration(
          borderRadius: context.normalBorderRadius,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                spreadRadius: 2,
                blurRadius: 10,
                color: Colors.grey.withOpacity(.2))
          ]),
      child: Column(
        children: [
          Image.asset("assets/image/img_speak2.png"),
          SizedBox(
            height: context.width * .04,
          ),
          Text(
            "Konuşma Gruplarına Katıl",
            style: context.textTheme.titleLarge?.copyWith(
              color: Colors.orange,
            ),
          ),
          SizedBox(
            height: context.width * .04,
          ),
          Text(
            "Konuşma gruplarına katıl hem eğlen hem öğren.Yeni insanlarla tanış birebir pratik yap.Aşşağıdaki link’e tıklayarak konuşma grubuna katılabilirsin",
            style:
                context.textTheme.bodyMedium?.copyWith(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: context.width * .04,
          ),
          Text(
            "http//link.discord/konusmagruplarıquiz.com",
            style:
                context.textTheme.bodyMedium?.copyWith(color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: context.width * .04,
          ),
          // CustomButton(
          //   onPressed: () {},
          //   title: "Katıl",
          //   height: 40,
          //   width: 120,
          // )
        ],
      ),
    );
  }
}
