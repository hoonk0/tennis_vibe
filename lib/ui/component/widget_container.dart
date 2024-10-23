import 'package:flutter/material.dart';

class WidgetContainer extends StatelessWidget {
  final Color colorBg;
  final Color colorBorder;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final void Function()? onTap;
  final double? width;
  final double circularNum;
  final Widget? child;
  final double? height;
  final double boarderWidth;
  final Alignment alignment;

  const WidgetContainer({
    this.colorBg = Colors.transparent,
    this.colorBorder = Colors.transparent,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    this.width,
    this.circularNum = 0,
    this.height,
    this.child,
    this.margin,
    this.onTap,
    this.boarderWidth = 1,
    this.alignment = Alignment.center,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: alignment,
        margin: margin,
        height: height,
        width: width,
        padding: padding,
        decoration: BoxDecoration(
          color: colorBg,
          borderRadius: BorderRadius.circular(circularNum),
          border: Border.all(color: colorBorder, width: boarderWidth),
        ),
        child: child,
      ),
    );
  }
}
