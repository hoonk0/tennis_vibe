import 'package:flutter/material.dart';
import '../../../const/value/colors.dart';
import '../../../const/value/gaps.dart';
import '../../../const/value/text_style.dart';
import '../../../service/utils/utils.dart';
import '../../component/custom_divider.dart';
import '../../component/button_basic.dart';
import '../../component/textfield_border.dart';

class RouteProfileEditMyInfoSns extends StatefulWidget {
  const RouteProfileEditMyInfoSns({super.key});

  @override
  State<RouteProfileEditMyInfoSns> createState() => _RouteProfileEditMyInfoSnsState();
}

class _RouteProfileEditMyInfoSnsState extends State<RouteProfileEditMyInfoSns> {
  final TextEditingController tecNickName = TextEditingController();
  final ValueNotifier<bool> vnSignUpButtonEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    tecNickName.addListener(_updateSignUpButtonState);
  }

  @override
  void dispose() {
    tecNickName.dispose();
    vnSignUpButtonEnabled.dispose();
    super.dispose();
  }

  void _updateSignUpButtonState() {
    vnSignUpButtonEnabled.value = tecNickName.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('내 정보 수정'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gaps.v16,

                      /// 상단
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Stack(
                                alignment: Alignment.bottomRight, // Aligns the pencil icon at the bottom right
                                children: [
                                  // Background image
                                  Image.asset(
                                    'assets/images/profile.png',
                                    fit: BoxFit.fitWidth,
                                    height: 70,
                                  ),
                                  // White circle with red border and pencil icon
                                  Positioned(
                                    right: 0, // Move further right (adjust as needed)
                                    bottom:0, // Move further down (adjust as needed)
                                    child: Container(
                                      width: 24, // Diameter of the circle
                                      height: 24, // Diameter of the circle
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white, // Background color of the circle
                                        border: Border.all(
                                          color: colorGray500, // Red border color
                                          width: 1, // Border width
                                        ),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          'assets/icons/pencil.png',
                                          width: 16, // Icon width
                                          height: 16, // Icon height
                                          color: colorGray500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gaps.v30,
                            Text(
                              '이메일',
                              style: TS.s14w500(colorGray900),
                            ),
                            Gaps.v10,
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              decoration: BoxDecoration(
                                color: colorGray200,
                                borderRadius: BorderRadius.all(Radius.circular(1)),
                              ),
                              child: Text(
                                'asdf123@naver.com',
                                style: TS.s16w400(colorGray600),
                              ),
                            ),
                            Gaps.v16 ,
                            Text(
                              '닉네임',
                              style: TS.s14w500(colorGray900),
                            ),
                            Gaps.v10,
                            TextFieldBorder(
                              controller: tecNickName,
                              hintText: '홍길동',
                            ),
                          ],
                        ),
                      ),

                      /// 구분선
                      CustomDivider(
                        margin: EdgeInsets.only(top: 20, bottom: 25),
                        color: colorGray200,
                        height: 10,
                      ),

                      /// 하단
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SNS 로그인 계정',
                              style: TS.s14w500(colorGray900),
                            ),
                            Gaps.v16,
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/google.png',
                                  fit: BoxFit.fitWidth,
                                  height: 20,
                                  width: 20,
                                ),
                                Gaps.h10,
                                Text(
                                  '구글 계정으로 로그인됨',
                                  style: TS.s16w600(colorGray900),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ValueListenableBuilder<bool>(
                  valueListenable: vnSignUpButtonEnabled,
                  builder: (context, vnSignUpButtonEnabled, child) {
                    return ButtonBasic(
                      title: '저장',
                      titleColorBg: vnSignUpButtonEnabled ? colorWhite : colorGray500,
                      colorBg: vnSignUpButtonEnabled ? colorGreen600 : colorRed,
                      onTap: vnSignUpButtonEnabled ? _saveNickName : null,
                    );
                  },
                ),
              ),
              Gaps.v16,
            ],
          ),
        ),
      ),
    );
  }

  void _saveNickName() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (tecNickName.text.isEmpty) {
      return;
    }

    // 현재 화면을 닫고 난 후 다이얼로그를 표시
    Navigator.of(context).pop();

    Utils.toast(desc: '내 정보가 저장되었습니다.');
  }


}
