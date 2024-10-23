import 'package:flutter/material.dart';

import '../../../const/value/colors.dart';

class BottomSheetShortBar extends StatelessWidget {
  const BottomSheetShortBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 44,
        height: 4,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: colorGray300,
        ),
      ),
    );
  }
}
