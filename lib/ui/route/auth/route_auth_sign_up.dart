import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tennis_vibe/ui/route/auth/route_auth_sign_up_email.dart';
import '../../../const/enum/enums.dart';
import '../../../const/value/colors.dart';
import '../../../const/value/gaps.dart';
import '../../../const/value/text_style.dart';
import '../../../service/utils/utils.dart';
import '../../component/button_basic.dart';
import '../../component/textfield_border.dart';

class RouteAuthSignUp extends StatefulWidget {
  final String uid;
  final String? nickname;
  final EnumLoginType loginType;
  final String? email;

  const RouteAuthSignUp({
    super.key,
    required this.uid,
    this.nickname,
    required this.loginType,
    this.email,
  });

  @override
  State<RouteAuthSignUp> createState() => _RouteAuthSignUpState();
}

class _RouteAuthSignUpState extends State<RouteAuthSignUp> {
  final TextEditingController tecPhone = TextEditingController();
  final TextEditingController tecPhoneConfirm = TextEditingController();
  final ValueNotifier<bool> vnSignUpButtonEnabled = ValueNotifier(false);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tecPhone.dispose();
    tecPhoneConfirm.dispose();
    vnSignUpButtonEnabled.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('휴대폰 번호'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 상단 여백
                        Gaps.v28,

                        /// 전화번호
                        Text(
                          '휴대폰 번호',
                          style: TS.s14w500(colorGray900),
                        ),
                        Gaps.v10,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFieldBorder(
                                controller: tecPhone,
                                hintText: '휴대폰 번호 ‘-’없이 입력',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                    mask: '###-####-####',
                                    filter: {"#": RegExp(r'[0-9]')},
                                    type: MaskAutoCompletionType.eager,
                                  ),
                                ],
                                onChanged: (value) {
                                  debugPrint("value $value");
                                  vnSignUpButtonEnabled.value = false;
                                },
                                errorText: (tecPhone.text.isEmpty || tecPhone.text.length == 13) ? null : 'Invalid Phone Number format',
                              ),
                            ),
                            Gaps.h8,

                            /// 센드 버튼
                            Expanded(
                              child: ValueListenableBuilder(
                                valueListenable: tecPhone,
                                builder: (context, value, child) {
                                  return ButtonBasic(
                                    title: '인증요청',
                                    colorBg: tecPhone.text.length == 13 ? colorGreen900 : colorPoint700,
                                    onTap: () {
                                      Utils.googlePhoneAuth(tec: tecPhone);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Gaps.v10,
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFieldBorder(
                                controller: tecPhoneConfirm,
                                hintText: '인증번호 입력 ',
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              ),
                            ),
                            Gaps.h8,
                            Expanded(
                              child: ValueListenableBuilder(
                                valueListenable: tecPhoneConfirm,
                                builder: (context, tecPhoneConfirm, child) {
                                  return ButtonBasic(
                                    title: '확인',
                                    colorBg: tecPhoneConfirm.text.isNotEmpty ? colorGreen900 : colorPoint700,
                                    onTap: tecPhoneConfirm.text.isNotEmpty
                                        ? () async {
                                            final authResult = await Utils.googlePhoneAuthConfirm(tecPhoneConfirm.text);
                                            if (authResult) {
                                              vnSignUpButtonEnabled.value = true;
                                            } else {
                                              Utils.toast(desc: '인증번호가 틀렸습니다.');
                                              vnSignUpButtonEnabled.value = false;
                                            }
                                          }
                                        : null,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        Gaps.v10,
                      ],
                    ),
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: vnSignUpButtonEnabled,
                  builder: (context, isButtonEnabled, child) {
                    return ButtonBasic(
                      title: '다음',
                      titleColorBg: colorWhite,
                      colorBg: isButtonEnabled ? colorGreen900 : colorPoint700,
                      onTap: isButtonEnabled
                          ? () {
                              final phoneNumber = tecPhone.text;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RouteAuthSignUpEmail(
                                        phoneNumber: phoneNumber,
                                        email: widget.email,
                                        nickName: widget.nickname,
                                        uid: widget.uid,
                                        loginType: widget.loginType,
                                      )));
                            }
                          : null,
                    );
                  },
                ),
                Gaps.v16,
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatPhoneNumber(String phoneNumber) {
    // 길이가 11이고, 숫자만 포함된 경우에만 형식을 변경
    if (RegExp(r'^\d{11}$').hasMatch(phoneNumber)) {
      // 예: 01012345678 => 010-1234-5678
      return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 7)}-${phoneNumber.substring(7, 11)}';
    } else {
      // 그 외의 경우, 입력값 그대로 반환
      return phoneNumber;
    }
  }

  String getOnlyPhoneNumber() {
    return tecPhone.text.replaceAll('-', '');
  }
}
