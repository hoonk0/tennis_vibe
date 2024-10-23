import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tennis_vibe/ui/route/auth/route_auth_sign_up_nickname.dart';
import '../../../const/enum/enums.dart';
import '../../../const/value/colors.dart';
import '../../../const/value/gaps.dart';
import '../../../const/value/text_style.dart';
import '../../component/button_basic.dart';
import '../../component/textfield_border.dart';

class RouteAuthSignUpEmail extends StatefulWidget {
  final String phoneNumber;
  final String? email;
  final String? nickName;
  final String uid;
  final EnumLoginType loginType;

  const RouteAuthSignUpEmail({
    super.key,
    required this.phoneNumber,
    this.email,
    this.nickName,
    required this.uid,
    required this.loginType,
  });

  @override
  State<RouteAuthSignUpEmail> createState() => _RouteAuthSignUpEmailState();
}

class _RouteAuthSignUpEmailState extends State<RouteAuthSignUpEmail> {
  final TextEditingController tecEmail = TextEditingController();
  final ValueNotifier<bool> vnSignUpButtonEnabled = ValueNotifier(false);

  final regExpEmail = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initEmail();
  }

  Future<void> initEmail() async {
    if (widget.email != null) {
      tecEmail.text = widget.email!;
    }
    WidgetsBinding.instance.endOfFrame.then((value) {
      _updateSignUpButtonState();
    });
  }

  // 이메일 형식
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('이메일 인증'),
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

                        /// 이메일
                        Text(
                          '이메일',
                          style: TS.s14w500(colorGray900),
                        ),
                        Gaps.v10,
                        TextFieldBorder(
                          controller: tecEmail,
                          hintText: '이메일 입력',
                          keyboardType: TextInputType.emailAddress,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')), // 공백 입력 방지
                          ],
                          onChanged: (value) {
                            _updateSignUpButtonState();
                          },
                          errorText: tecEmail.text.isEmpty || regExpEmail.hasMatch(tecEmail.text) ? null : 'Invalid Email format',
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
                      colorBg: isButtonEnabled ? colorGreen900 : colorGray200,
                      onTap: isButtonEnabled
                          ? () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RouteAuthSignUpNickname(
                                        email: tecEmail.text,
                                        phoneNumber: widget.phoneNumber,
                                        nickname: widget.nickName,
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

  void _updateSignUpButtonState() {
    final allFieldsFilled = tecEmail.text.isNotEmpty;
    final isEmailValid = regExpEmail.hasMatch(tecEmail.text);

    vnSignUpButtonEnabled.value = allFieldsFilled && isEmailValid;
  }
}
