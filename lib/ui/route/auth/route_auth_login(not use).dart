/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tennisreminder/ui/route/auth/start/login_tool/google.dart';
import '../../../const/model/model_member.dart';
import '../../../const/service/provider/providers.dart';
import '../../../const/value/colors.dart';
import '../../../const/value/gaps.dart';
import '../route_main.dart';

class RouteAuthLogin extends StatefulWidget {
  const RouteAuthLogin({super.key});

  @override
  _RouteAuthLoginState createState() => _RouteAuthLoginState();
}

class _RouteAuthLoginState extends State<RouteAuthLogin> {
  final TextEditingController tecId = TextEditingController();
  final TextEditingController tecPw = TextEditingController();

  @override
  void initState() {
    super.initState();
    tecId.addListener(_validateInput);
    tecPw.addListener(_validateInput);

*/
/*
    WidgetsBinding.instance.endOfFrame.then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MainScreen(selectedIndex: 0)));
    });

 *//*


//디버깅용 로그인 화면 스킵 코드
  }

  @override
  void dispose() {
    tecId.dispose();
    tecPw.dispose();
    super.dispose();
  }

  void _validateInput() {
    setState(() {
    });
  }

  Future<void> signInWithKakao() async {
    if (await isKakaoTalkInstalled()) {
      try {
        debugPrint("카카오 로그인 0");
        await UserApi.instance.loginWithKakaoTalk();
        debugPrint("카카오 로그인 1");
        await _handleKakaoLogin();
      } catch (error) {
        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          await _handleKakaoLogin();
        } catch (error) {}
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        await _handleKakaoLogin();
      } catch (error) {}
    }
  }

  Future<void> _handleKakaoLogin() async {
    // 사용자 정보 가져오기
    User user = await UserApi.instance.me();
    String email = user.kakaoAccount?.email ?? '';
    String nickname = user.kakaoAccount?.profile?.nickname ?? '';
    final userId = user.id;
    final userDs = await FirebaseFirestore.instance.collection('member').doc(userId.toString()).get();
    // 이미 회원인 경우
    if (!userDs.exists) {
      // ModelMember 생성 및 Firestore에 저장
      ModelMember newUser = ModelMember(
        id: user.id.toString(),
        memberid: email,
        pw: '',
        // 카카오톡 로그인에서는 pw 사용하지 않음
        name: nickname,
        phone: '',
        location: '',
        email: email,
      );
      await _saveUserToFirestore(newUser);
      userNotifier.value = newUser;
    }
    // 이미 회원인 경우
    else {
      userNotifier.value = ModelMember.fromJson(userDs.data()!);
    }
    final pref = await SharedPreferences.getInstance();
    pref.setString('uid', userId.toString());
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const RouteMain(),
      ),
    );
  }

  Future<void> _saveUserToFirestore(ModelMember user) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('member').doc(user.id).set(user.toJson());
  }

*/
/*
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

*//*

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
            const SizedBox(height: 100),

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
                      width: 60.w,
                    ),

                    */
/*
                    Container(
                      margin: const EdgeInsets.only(left: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'ID',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: colorGreen900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              controller: tecId,
                              style: const TextStyle(
                                fontSize: 16,
                                color: colorGreen900,
                              ),
                              decoration: const InputDecoration(
                                hintText: '아이디 입력하세요',
                                hintStyle: TextStyle(
                                  color: colorGreen900,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'PW',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: colorGreen900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              obscureText: true,
                              controller: tecPw,
                              style: const TextStyle(
                                fontSize: 16,
                                color: colorGreen900,
                              ),
                              decoration: const InputDecoration(
                                hintText: '비밀번호를 입력하세요',
                                hintStyle: TextStyle(
                                  color: colorGreen900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  *//*



                  ],
                ),
              ),
            ),



            */
/*
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen(selectedIndex: 0)),
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
                        color: colorGreen900,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            *//*


            Gaps.v20,

*/
/*
            Center(
              child: TextButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationButton()),
                  );
                },
                child: const Text("알림"),
              ),
            ),
*//*


            GestureDetector(
              onTap: () async {
                UtilsLogin.onGoogleTap(context);
                */
/*final userCredential = await UtilsLogin.onGoogleTap();
                debugPrint("구글 로그인 성공 ${userCredential!.user!.uid}");
                final modelMember = ModelMember(
                  id: userCredential.user!.uid,
                  memberid: ,
                  pw: pw,
                  name: name,
                  phone: phone,
                  location: location,
                  email: userCredential.user!.email!,);
                FirebaseFirestore.instance.collection('member').doc(modelMember.id).set(modelMember.toJson());*//*

              },
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/google_login.png',
                    fit: BoxFit.fill,
                    height: 12.w,
                    width: 50.w,
                  ),
                ],
              ),
            ),

            Gaps.v10,

            GestureDetector(
              onTap: () {
                signInWithKakao();
              },
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/kakao_login_large_wide.png',
                    fit: BoxFit.fill,
                    height: 12.w,
                    width: 50.w,
                  ),
                ],
              ),
            ),

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

            const SizedBox(height: 100),

*/
/*
            SizedBox(
              height: 20.w,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NewMember(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorGreen900,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          '회원가입',
                          style: TextStyle(color: colorWhite),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            *//*


            */
/*
            SizedBox(
              height: 20.w,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () async {
                          // id가 비어있는지, pw 비어있는지 확인
                          // id가 있는 여부 확인
                          // 없으면 없다고 메세지
                          // 있으면 비밀번호 확인
                          // 비밀번호 틀리면 틀렸다고 메세지
                          // 맞으면 로그인
                          final id = tecId.text;
                          final pw = tecPw.text;
                          if (id.isEmpty || pw.isEmpty) {
                            Fluttertoast.showToast(msg: '아이디와 비밀번호를 입력하세요.');
                            return;
                          }
                          final idQs = await FirebaseFirestore.instance.collection('member').where('memberid', isEqualTo: id).get();
                          if (idQs.docs.isEmpty) {
                            Fluttertoast.showToast(msg: '일치하는 아이디가 없습니다.');
                            return;
                          }
                          final targetModelUser = ModelMember.fromJson(idQs.docs.first.data()); // 내 정보
                          if (pw != targetModelUser.pw) {
                            Fluttertoast.showToast(msg: '비밀번호가 일치하지 않습니다.');
                            return;
                          }
                          userNotifier.value = targetModelUser;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const MainScreen(
                                    selectedIndex: 0,
                                  )));
                          // 여기서 로그인
                        }, //_isInputValid ? _login : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isInputValid ? colorGreen900 : colorGray300,
                          fixedSize: const Size(360, 56),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                        child: const Text(
                          '로그인',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: colorWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            *//*

          ],
        ),
      ),
    );
  }
}
*/
