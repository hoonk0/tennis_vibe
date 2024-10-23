import 'package:flutter/material.dart';

import '../../const/value/colors.dart';
import '../../const/value/text_style.dart';

class CustomContainerProfileList extends StatelessWidget {
  final void Function()? onTap;
  final String title;

  const CustomContainerProfileList({
    this.onTap,
    required this.title,
    super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // Row의 자식들을 양쪽 끝으로 배치
          children: [
            Text(
              title,
              style: TS.s16w600(colorGray800),
            ),
            Image.asset(
              'assets/icons/arrow_right.png',
              width: 16, // 이미지 너비 (옵션)
              height: 16, // 이미지 높이 (옵션)
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
