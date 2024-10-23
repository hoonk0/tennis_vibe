import 'package:flutter/material.dart';
import '../../const/value/colors.dart';

class ButtonBasic extends StatelessWidget {
  final String title;
  final Color colorBg;
  final Color titleColorBg;
  final double titleFontSize;
  final double width;
  final Color borderColor; // 테두리 색을 위한 필드 추가
  final void Function()? onTap;

  const ButtonBasic({
    required this.title,
    this.colorBg = colorRed,
    this.width = double.infinity,
    this.titleColorBg = colorWhite,
    this.titleFontSize = 18,
    this.borderColor = colorWhite, // 기본 테두리 색을 빨간색으로 설정
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: width,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: colorBg,
          border: Border.all(color: borderColor), // 테두리 색 설정
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: titleFontSize,
              color: titleColorBg,
            ),
          ),
        ),
      ),
    );
  }
}
