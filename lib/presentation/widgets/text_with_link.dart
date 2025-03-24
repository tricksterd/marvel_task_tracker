import 'package:flutter/material.dart';

import '../../application/core/styles.dart';

class TextWithLink extends StatelessWidget {
  const TextWithLink(
      {super.key,
      required this.text,
      required this.linkedText,
      required this.onTap});

  final String text;
  final String linkedText;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: AppTextStyle.linkTextDefault,
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(linkedText, style: AppTextStyle.linkTextActive),
          )
        ],
      ),
    );
  }
}
