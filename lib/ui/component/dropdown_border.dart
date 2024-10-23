import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../const/value/colors.dart';
import '../../const/value/text_style.dart';

class DropdownBorder extends DropdownButtonHideUnderline {
  DropdownBorder({
    super.key,
    String? value,
    Widget? hint,
    List<DropdownMenuItem<String>>? items,
    void Function(String?)? onChanged,
    Color colorBg = colorWhite,
  }) : super(
          child: DropdownButton2(
            isExpanded: true,
            value: value,
            hint: hint,
            items: items,
            onChanged: onChanged,
            style: const TS.s16w400(colorBlack),
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
              height: 56,
              decoration: BoxDecoration(
                color: colorBg,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: colorGray400),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              elevation: 0,
              maxHeight: 20.h,
              openInterval: const Interval(0.1, 0.4),
              offset: Offset(0, -4),
              decoration: BoxDecoration(
                color: colorBg,
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: colorGray400),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 56,
              padding: EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
        );
}
