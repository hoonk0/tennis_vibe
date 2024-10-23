import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tennis_vibe/ui/route/auth/route_auth_sign_up.dart';
import '../../../const/enum/enums.dart';
import '../../../const/value/colors.dart';
import '../../../const/value/gaps.dart';
import '../../../const/value/keys.dart';
import '../../../service/utils/utils.dart';
import '../route_main.dart';
import '../route_splash.dart';

class RouteAuthLogin extends StatelessWidget {
  const RouteAuthLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: colorWhite,
        body: Column(
          children: [

            SizedBox(
              height: 40.w,
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Image.asset(
                      fit: BoxFit.fill,
                      'assets/images/logo_main.png',
                      width: 70.w,
                    ),
                  ],
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              GestureDetector(
                onTap: () async {
                  final UserCredential? userCredential = await Utils.onGoogleTap();
                  if (userCredential != null) {
                    final uid = userCredential.user!.uid;
                    final userDs =
                    await FirebaseFirestore.instance.collection(keyUser).where(keyEmail, isEqualTo: userCredential.user!.email).get();
                    // 회원가입이 안됨
                    if (userDs.docs.isEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RouteAuthSignUp(
                            uid: uid,
                            email: userCredential.user!.email!,
                            loginType: EnumLoginType.google,
                          ),
                        ),
                      );
                    }
                    // 회원가입이 되어있음
                    else {
                      final pref = await SharedPreferences.getInstance();
                      pref.setString(keyUid, uid);
                      Navigator.of(context)
                          .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const RouteSplash()), (route) => false);
                    }
                  }
                },
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Image.asset(
                    'assets/images/google.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Gaps.h10,
              ///카카오 로그인
              GestureDetector(
                onTap: () async {
                  final String? uid = await Utils.onKakaoTap();
                  if (uid != null) {
                    final userDs = await FirebaseFirestore.instance.collection(keyUser).where(keyUid, isEqualTo: uid).get();
                    // 회원가입이 안됨
                    if (userDs.docs.isEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RouteAuthSignUp(
                            uid: uid,
                            email: null,
                            loginType: EnumLoginType.kakao,
                          ),
                        ),
                      );
                    }
                    // 회원가입이 되어있음
                    else {
                      final pref = await SharedPreferences.getInstance();
                      pref.setString(keyUid, uid);
                      Navigator.of(context)
                          .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const RouteSplash()), (route) => false);
                    }
                  }
                },
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Image.asset(
                    'assets/images/kakao.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ],),
            ///구글 로그인


            Gaps.v20,
            ///로그인 없이 둘러보기
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RouteMain()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  alignment: Alignment.center,
                  child: RichText(
                    text: const TextSpan(
                      text: '로그인 없이 둘러보기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorGray900,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.w,
            ),
          ],
        ),
      ),
    );
  }
}
