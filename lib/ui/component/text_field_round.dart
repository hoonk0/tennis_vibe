import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../const/value/colors.dart';
import '../../const/value/text_style.dart';



class TextFieldRound extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autoFocus;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final String? suffixText;
  final bool expands;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final FocusNode? focusNode;
  final String? helperText;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle textStyle;
  final TextStyle hintTextStyle;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final Widget? suffix;
  final Widget? prefixIcon;
  final void Function(String)? onSubmitted;
  final Color filledColor;
  final Color boarderColor;
  final Widget? suffixIcon;
  final double circularNumber;
  final bool isCounterShow;
  final TextInputAction? textInputAction;

  const TextFieldRound({
    Key? key,
    this.controller,
    this.onChanged,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.autoFocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType = TextInputType.multiline,
    this.suffixText,
    this.expands = false,
    this.inputFormatters,
    this.enabled = true,
    this.focusNode,
    this.helperText,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    this.textStyle = const TS.s15w500(colorGray50),
    this.hintTextStyle = const TS.s14w400(colorGray500),
    this.textAlign = TextAlign.left,
    this.textAlignVertical = TextAlignVertical.center,
    this.suffix,
    this.prefixIcon,
    this.onSubmitted,
    this.circularNumber = 0,
    this.filledColor = colorGray900,
    this.boarderColor = colorGray800,
    this.suffixIcon,
    this.isCounterShow = false,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      style: textStyle,
      focusNode: focusNode,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      cursorColor: colorPrimary500,
      keyboardType: keyboardType,
      autofocus: autoFocus,
      controller: controller,
      obscureText: obscureText,
      maxLength: maxLength,
      maxLines: maxLines,
      expands: expands,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        suffix: suffix,
        hintText: hintText,
        hintStyle: hintTextStyle,
        isDense: true,
        counterText: isCounterShow ? '${controller?.text.length ?? 0} / $maxLength' : '',
        helperText: helperText,
        helperStyle: const TS.s12w600(colorNeutral600),
        enabled: enabled,
        filled: true,
        fillColor: filledColor,
        errorText: errorText,
        errorStyle: const TS.s12w600(colorError500),
        suffixText: suffixText,
        suffixStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15.0),
        contentPadding: contentPadding,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: boarderColor, width: 1),
          borderRadius:  BorderRadius.all(Radius.circular(circularNumber)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: boarderColor, width: 1),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(circularNumber), // 좌측을 더 둥글게 설정
            right: Radius.circular(circularNumber), // 우측을 더 둥글게 설정
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: boarderColor, width: 1),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(circularNumber), // 좌측을 더 둥글게 설정
            right: Radius.circular(circularNumber), // 우측을 더 둥글게 설정
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: boarderColor, width: 1),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(circularNumber), // 좌측을 더 둥글게 설정
            right: Radius.circular(circularNumber), // 우측을 더 둥글게 설정
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: boarderColor, width: 1),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(circularNumber), // 좌측을 더 둥글게 설정
            right: Radius.circular(circularNumber), // 우측을 더 둥글게 설정
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: boarderColor, width: 1),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(circularNumber),
            right: Radius.circular(circularNumber),
          ),
        ),
        counter: null,
      ),
    );
  }
}
