import 'package:flutter/material.dart';

import '../../const/value/colors.dart';
import '../../const/value/text_style.dart';




class TextFieldBorder extends TextField {
  TextFieldBorder({
    super.onChanged,
    super.controller,
    super.inputFormatters,
    super.focusNode,
    super.keyboardType,
    super.obscureText,
    super.expands,
    super.maxLines,
    super.maxLength,
    super.onSubmitted,
    super.onEditingComplete,
    super.textAlign = TextAlign.left,
    bool super.enabled = true,
    String? hintText,
    Widget? suffix,
    Widget? suffixIcon,
    Widget? prefixIcon,
    Color fillColor = Colors.transparent,
    String? errorText,
    TextStyle? textStyle = const TS.s16w400(colorGray900),
    TextStyle? hintStyle = const TS.s16w400(colorGray500),
    String? suffixText,
    EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    TextStyle? errorTextStyle = const TS.s12w500(colorVolcano500),
    TextAlignVertical super.textAlignVertical = TextAlignVertical.center,
    Color colorBorder = colorGray500,
    Color colorFocused = colorGreen900,
    Color colorBorderError = const Color(0xFFDDE1E6),
    double circularNumber = 10,
    super.key,
  }) : super(
          style: textStyle,
          cursorColor: colorGreen900,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            suffix: suffix,
            hintText: hintText,
            hintStyle: hintStyle,
            isDense: true,
            filled: true,
            counterStyle: const TS.s12w400(colorGray600),
            fillColor: fillColor,
            errorText: errorText,
            errorStyle: errorTextStyle,
            suffixText: suffixText,
            suffixStyle: const TS.s16w400(colorGray900),
            contentPadding: contentPadding,
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorBorder),
              borderRadius: BorderRadius.all(Radius.circular(circularNumber)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorBorderError),
              borderRadius: BorderRadius.all(Radius.circular(circularNumber)),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: colorBorder),
              borderRadius: BorderRadius.all(Radius.circular(circularNumber)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorBorder),
              borderRadius: BorderRadius.all(Radius.circular(circularNumber)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorFocused),
              borderRadius: BorderRadius.all(Radius.circular(circularNumber)),
            ),
          ),
        );
}
