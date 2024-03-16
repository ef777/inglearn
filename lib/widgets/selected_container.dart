// ignore_for_file: deprecated_member_use

import 'package:english_learn/const/colors.dart';
import 'package:flutter/material.dart';

class SelectedConteiner extends StatefulWidget {
  const SelectedConteiner(
      {super.key,
      required this.planTitle,
      required this.price,
      required this.isMon,
      required this.selected,
      this.onPressed});
  final String planTitle;
  final double price;
  final bool isMon;
  final bool selected;
  final void Function()? onPressed;

  @override
  State<SelectedConteiner> createState() => _SelectedConteinerState();
}

class _SelectedConteinerState extends State<SelectedConteiner> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.5,
        height: 80,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(2),
            color: Colors.white,
            border: widget.selected
                ? Border.all(width: 2, color: colorBlue)
                : Border.all(
                    width: 0, color: const Color.fromARGB(255, 165, 92, 24))),
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.planTitle,
                style: Theme.of(context).textTheme.button,
              ),
              Center(
                child: widget.isMon
                    ? Text(
                        "₺${widget.price}",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      )
                    : Text(
                        "₺${widget.price}",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
              ),
              // Visibility(
              //   visible: !widget.isMon,
              //   child: Text(
              //     "${widget.price / 12}/aylık",
              //     style: Theme.of(context).textTheme.bodySmall,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
