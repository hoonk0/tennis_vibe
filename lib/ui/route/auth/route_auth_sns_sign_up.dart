import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../const/enum/enums.dart';
import '../../../const/value/colors.dart';
import '../../../const/value/gaps.dart';
import '../../../const/value/text_style.dart';
import '../../../service/utils/utils.dart';
import '../../component/button_basic.dart';
import '../../component/textfield_border.dart';

class RouteAuthSnsSignUp extends StatelessWidget {
  final String uid;
  final String? nickname;
  final EnumLoginType loginType;
  final String? email;

  RouteAuthSnsSignUp({
    super.key,
    required this.uid,
    this.nickname,
    required this.loginType,
    this.email,
  });

  final TextEditingController tecNickname = TextEditingController();
  final ValueNotifier<bool> vnSignUpButtonEnabled = ValueNotifier(false);

  void _updateSignUpButtonState() {
    vnSignUpButtonEnabled.value = tecNickname.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    if (nickname != null) {
      tecNickname.text = nickname!;
    }
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('회원가입'),
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
                        Gaps.v28,
                        Text(
                          '닉네임',
                          style: TS.s14w500(colorGray900),
                        ),
                        Gaps.v10,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFieldBorder(
                                controller: tecNickname,
                                hintText: '닉네임 입력',
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  _updateSignUpButtonState();
                                },
                                errorText: tecNickname.text.isEmpty ? null : '닉네임을 입력해주세요',
                              ),
                            ),
                            Gaps.h8,
                            Expanded(
                              child: ValueListenableBuilder<bool>(
                                valueListenable: vnSignUpButtonEnabled,
                                builder: (context, isButtonEnabled, child) {
                                  return ButtonBasic(
                                    title: '중복확인',
                                    colorBg: isButtonEnabled ? colorGreen600 : colorGray200,
                                    onTap: isButtonEnabled
                                        ? () {
                                            Utils.toast(desc: '닉네임 중복 확인이 완료되었습니다.');

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
                      titleColorBg: isButtonEnabled ? colorWhite : colorGray500,
                      colorBg: isButtonEnabled ? colorGreen600 : colorGray200,
                      onTap: isButtonEnabled ? () {} : null,
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
}
