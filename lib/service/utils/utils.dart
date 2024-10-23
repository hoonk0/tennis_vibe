import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';
import '../../../ui/component/throttler_debouncer.dart';
import 'package:http/http.dart' as http;
import '../../const/value/keys.dart';
import '../../static/global.dart';

class Utils {
  /// 구글 로그인 함수
  static Future<UserCredential?> onGoogleTap() async {
    GoogleSignInAccount? account;
    Fluttertoast.showToast(msg: '  auth trying  \n  wait please  ');

    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      //debugPrint("googleSignIn ${googleSignIn.serverClientId} ${googleSignIn.clientId}");
      account = await googleSignIn.signIn();

      if (account != null) {
        GoogleSignInAuthentication authentication = await account.authentication;

        OAuthCredential googleCredential = GoogleAuthProvider.credential(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken,
        );

        final credential = await FirebaseAuth.instance.signInWithCredential(googleCredential);
        //  debugPrint('로그인 이메일 ${credential.user!.email}');

        if (credential.user != null) {
          // 로그인 성공 시
          Fluttertoast.showToast(msg: '  Google auth success  ');
          Utils.log.i('구글 인증 성공\구글 사용자: ${FirebaseAuth.instance.currentUser}');
          return credential;
        } else {
          return null;
        }
      } else {}
    } on FirebaseAuthException catch (e, s) {
      Utils.log.f('구글 인증 실패\n${e.code}\n$s');
      if (e.code == 'invalid-email') {
        Utils.toast(desc: 'confirm email format');
      } else if (e.code == 'user-disabled') {
        Utils.toast(desc: 'this account is disabled');
      } else if ((e.code == 'user-not-found') || (e.code == 'wrong-password')) {
        Utils.toast(desc: 'confirm password');
      } else if (e.code == 'too-many-requests') {
        Utils.toast(desc: 'too many requests');
      } else {
        Utils.toast(desc: '  Google auth fail  \n  error: ${e.code}  ');
      }
    }
  }


  /* 구글 전화 인증 */
  static Future<void> googlePhoneAuth({
    required TextEditingController tec,
  }) async {
    debugPrint('tec ${tec.text}');
    toast(desc: '인증번호를 요청중입니다.');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+82${tec.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        String errorMessage;
        if (e.code == 'invalid-phone-number') {
          errorMessage = '입력하신 전화번호가 유효하지 않습니다.';
        } else if (e.code == 'too-many-requests') {
          errorMessage = '  요청을 너무 많이 했습니다.  \n  나중에 다시 시도해주세요.  ';
        } else if (e.code == 'quota-exceeded') {
          errorMessage = '  요청 한도가 초과되었습니다.  \n  나중에 다시 시도해주세요.  ';
        } else if (e.code == 'missing-verification-code') {
          errorMessage = '  인증 코드가 없습니다.  \n  인증 코드를 입력해 주세요.  ';
        } else if (e.code == 'session-expired') {
          errorMessage = '  인증 세션이 만료되었습니다.  \n  다시 시도해주세요.  ';
        } else if (e.code == 'captcha-check-failed') {
          errorMessage = '  보안 체크에 실패했습니다.  \n  다시 시도해주세요.  ';
        } else {
          errorMessage = '  휴대폰번호를 다시 입력해주세요.  ';
        }

        toast(desc: errorMessage);
        debugPrint("Phone number verification failed. Code: ${e.code}. Message: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        debugPrint("인증번호가 전송되었습니다. verificationId : $verificationId");
        Global.googlePhoneVerificationId = verificationId;
        toast(desc: '인증번호가 전송되었습니다.');
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  static Future<bool> googlePhoneAuthConfirm(String smsCode) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: Global.googlePhoneVerificationId!, smsCode: smsCode);
      debugPrint(
          "credential ${credential.smsCode} ${credential.verificationId} ${credential.token} ${credential.providerId} ${credential.signInMethod}");
      await FirebaseAuth.instance.signInWithCredential(credential!);
      toast(desc: '인증되었습니다.');
      return true;
    } catch (e, s) {
      debugPrint('인증에러 $e');
      debugPrint('인증에러 $s');
      return false;
    }
  }



  /// 토스트 메세지
  static final log = Logger(printer: PrettyPrinter(methodCount: 1));

  static void toast({
    required String desc,
    int duration = 1000,
    bool hasIcon = false,
  }) {
    Fluttertoast.showToast(msg: desc, gravity: ToastGravity.SNACKBAR);
  }

  static final regExpPw = RegExp(r'.{6,}');

  static Future<bool> logout() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove(keyUid);
    Global.uid = null;
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
      }

      return true;
    } catch (e) {
      Utils.toast(desc: 'Logout fault ${e.toString()}');
      return false;
    }
  }

  static initializeProviders(WidgetRef ref) {}

  static Future<bool> sendEmail(String to, String subject, String content) async {
    final url = Uri.parse('https://asia-northeast3-chater-quiz-book.cloudfunctions.net/sendEmail');

    final response = await http.get(url.replace(queryParameters: {
      'to': to,
      'subject': subject,
      'content': content,
    }));

    if (response.statusCode == 200) {
      print("Email sent successfully.");
      return true;
    } else {
      print("Failed to send email: ${response.statusCode}");
      print("Error: ${response.body}");
      return false;
    }
  }

  static Future<UserCredential?> onAppleTap() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      AuthorizationCredentialAppleID authorizationCredentialAppleID = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
          webAuthenticationOptions: WebAuthenticationOptions(
              clientId: 'gather.appdoggaebi.ios',
              redirectUri: Uri.parse('https://able-tangible-thrill.glitch'
                  '.me/callbacks/sign_in_with_apple')));

      Utils.log.d(
          "authorizationCredentialAppleID 결과 : ${authorizationCredentialAppleID.email}, ${authorizationCredentialAppleID.givenName}, ${authorizationCredentialAppleID.familyName}");

      // Create an `OAuthCredential` from the credential returned by Apple.
      OAuthCredential oauthCredential = OAuthProvider("apple.com").credential(
        idToken: authorizationCredentialAppleID.identityToken,
        accessToken: authorizationCredentialAppleID.authorizationCode,
        rawNonce: rawNonce,
      );

      Utils.log.d("oauthCredential 결과 : ${oauthCredential.idToken}");

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final credential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      if (credential.user != null) {
        // 로그인 성공시
        var showToast = Fluttertoast.showToast(msg: '  Apple login success  ');
        Utils.log.i('애플 로그인 성공\n애플 사용자: ${FirebaseAuth.instance.currentUser}  credential $credential');
        return credential;
      } else {
        // 로그인 실패시
        Fluttertoast.showToast(msg: '  Apple login fail ');
        Utils.log.f('애플 로그인 실패\n credential.user == null');
        return null;
      }
    } on FirebaseAuthException catch (e, s) {
      Fluttertoast.showToast(msg: '  Apple login fail  \n  ${e.code}  ');
      Utils.log.f('애플 로그인 실패\n${e.code}\n$s');
    }
  }

  static String generateNonce([int length = 32]) {
    String charset = 'kr.co.kayple.today_safety@${DateTime.now().millisecondsSinceEpoch}';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  /// 애플 로그인 보안 관련 코드
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// 카카오 로그인 함수
  static Future<String?> onKakaoTap() async {
    FocusManager.instance.primaryFocus?.unfocus();

    Fluttertoast.showToast(msg: '카카오 로그인을 시도중입니다.');

    // [1] 카카오톡이 설치되어있는지 확인
    bool isInstalled;
    try {
      isInstalled = await isKakaoTalkInstalled();
    } catch (e, s) {
      isInstalled = false;
      Utils.log.f('카카오톡이 설치되지 않음\n$e\n$s');
    }

    // [2] 토큰 받기
    // 카카오톡이 설치되어 있으면 token 받고, 설치되어 있지 않으면 계정로그인으로 token 받기
    OAuthToken token;
    if (isInstalled) {
      try {
        token = await UserApi.instance.loginWithKakaoTalk();
        Utils.log.i('카카오톡으로 로그인 성공');
      } catch (e, s) {
        Utils.log.f('카카오톡으로 로그인 실패\n$e\n$s');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (e is PlatformException && e.code == 'CANCELED') {
          Utils.log.f('로그인 취소\ne is PlatformException && e.code == "CANCELED"');
          Utils.toast(desc: '카카로 로그인에 실패했어요\n다른 로그인 방법을 이용해주세요. CANCELED');
        }
        return null;
      }
    }
    // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
    else {
      try {
        token = await UserApi.instance.loginWithKakaoAccount();
      } catch (e, s) {
        Utils.log.f('카카오 계정으로 로그인 실패\n$e\n$s');
        Utils.toast(desc: '카카로 로그인에 실패했어요\n다른 로그인 방법을 이용해주세요');
        return null;
      }
    }
    dynamic kakaoProfile;

    // [3] 카카오 유저정보 가져오기
    try {
      final url = Uri.https('kapi.kakao.com', '/v2/user/me');
      final response = await http.get(
        url,
        headers: {HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'},
      );

      kakaoProfile = json.decode(response.body);
      Utils.log.d('프로필 정보 : ${kakaoProfile.toString()}');
    } catch (e, s) {
      Utils.log.f('카카오 유저정보 가져오기 실패\n$e\n$s');
      Utils.toast(desc: '카카오 유저정보를 가져오는데 실패했어요\n다른 로그인 방법을 이용해주세요');
    }

    // [4] token을 이용하여 파이어베이스에 인증
    try {
      final String uid = 'kakao:${kakaoProfile['id']}';
      return uid;
    } catch (e, s) {
      Utils.toast(desc: '카카오 로그인에 실패하였습니다\n다시 시도해주세요');
      Utils.log.f('카카오 로그인 실패\n$e\n$s');
      return null;
    }
  }

  static final Throttler throttler = Throttler(milliseconds: 200);

  static Future<List<String>> getImgUrlXFile(List<XFile?> listXFile) async {
    debugPrint("22 ${listXFile}");
    List<UploadTask> listUploadTasks = [];
    List<TaskSnapshot> listTaskSnapshot = [];
    List<String> listImgUrls = [];
    final uuid = const Uuid().v4().substring(0, 6);
    debugPrint("55");
    // 서버에 사진 올리는 코드
    listUploadTasks =
        listXFile.mapIndexed<UploadTask>((index, xFile) => FirebaseStorage.instance.ref('사진등록($uuid)/$index').putFile(File(xFile!.path))).toList();
    listTaskSnapshot = await Future.wait(listUploadTasks);
    debugPrint("44");
    // 올라간 사진의 url을 받는 코드
    final futureImgUrls = listTaskSnapshot.map((snapShot) => snapShot.ref.getDownloadURL()).toList();
    listImgUrls = await Future.wait(futureImgUrls);
    debugPrint("33 ${listImgUrls}");
    return listImgUrls;
  }


  static Future<List<String>> getCImgFromListXFile(List<XFile> listXFile) async {
    final int randomNumber = Random().nextInt(1000);
    final List<File?> listFile = listXFile.map((e) => File(e.path)).toList();
    final listBytes = await Future.wait(listFile.map((e) => e!.readAsBytes()));
    listBytes.forEach((element) {
      debugPrint(" 압축 전 MB ${element.length / (1024 * 1024)}");
    });
    final List<Uint8List> listCompressedBytes = await Future.wait(listBytes.map((e) => FlutterImageCompress.compressWithList(e, quality: 50)));
    listCompressedBytes.forEach((element) {
      debugPrint(" 압축 후 MB ${element.length / (1024 * 1024)}");
    });

    String path = '프로필사진/${DateFormat('yyyy-MM-dd HH:mm:ss ${randomNumber}').format(DateTime.now())}_';
    final listUploadTask = listCompressedBytes.mapIndexed(
          (index, element) => FirebaseStorage.instance.ref(path + index.toString()).putData(element),
    );
    List<Future<TaskSnapshot>> listItemTaskFutures = listUploadTask
        .map((uploadTask) => uploadTask.then((taskSnapshot) {
      return taskSnapshot;
    }))
        .toList();
    List<TaskSnapshot> listItemTaskSnapshot = await Future.wait(listItemTaskFutures);

    List<String> listItemImgUrls = [];
    for (TaskSnapshot snapshot in listItemTaskSnapshot) {
      String downloadUrl = await snapshot.ref.getDownloadURL();
      listItemImgUrls.add(downloadUrl);
    }
    return listItemImgUrls;
  }


}


