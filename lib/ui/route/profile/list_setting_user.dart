/*
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tennisreminder/main_screen/home/splash_screen.dart';
import 'package:tennisreminder/main_screen/my_page/setting/setting_detail/court_manager/setting_manager_court.dart';
import 'package:tennisreminder/main_screen/my_page/setting/setting_detail/setting_contact_manager.dart';
import 'package:tennisreminder/main_screen/my_page/setting/setting_detail/notice/setting_notice.dart';
import 'package:tennisreminder/const/color.dart';

import '../../../const/text_style.dart';

class ListSettingUser extends StatelessWidget {
  const ListSettingUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('SETTING', style: TS.s20w700(colorGreen900)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            leading: Image.asset(
              'assets/images/logo_courtvibe.png', // 이미지 경로
              width: 100,
              height: 100,
            ),
            title: const Text('로그인 화면 구현'),
            onTap: () {
              // 로그인 화면 구현
            },
          ),
          const SizedBox(height: 5),
          Container(
            height: 10,
            color: colorGreen900,
          ),
          const SizedBox(height: 5),
          ListTile(
            leading: const Icon(Icons.person, color: colorGreen900),
            title: const Text('개인정보'),
            /*
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingMyPage()),
              );
            },

            */
          ),
          const SizedBox(height: 5),
          Container(
            height: 2,
            width: 100.w,
            color: colorGray600,
          ),
          const SizedBox(height: 5),
          ListTile(
            leading: const Icon(Icons.notifications, color: colorGreen900),
            title: const Text('공지사항'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingNotice()),
              );
            },
          ),
          const SizedBox(height: 5),
          Container(
            height: 2,
            width: 100.w,
            color: colorGray600,
          ),
          const SizedBox(height: 5),

          ListTile(
            leading: const Icon(Icons.contact_support_rounded, color: Colors.green),
            title: const Text('고객센터'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('고객센터'),
                    content: const Text('연락하세요'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('확인'),
                      ),
                    ],
                  );
                },
              );
            },
          ),

          const SizedBox(height: 5),
          Container(
            height: 2,
            width: 100.w,
            color: colorGray600,
          ),
          const SizedBox(height: 5),
          ListTile(
            title: const Text('로그아웃'),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '로그아웃 하시겠습니까?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff333333),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            '지금 로그아웃하시겠어요?',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff7b796f),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final pref = await SharedPreferences.getInstance();
                                  pref.remove('uid');
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => RouteSplash()), (route) => false);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: colorWhite,
                                  backgroundColor: colorGray300,
                                  // 텍스트 색상
                                  textStyle: const TextStyle(fontSize: 16),
                                  // 텍스트 스타일
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 60),
                                  // 버튼 내부 패딩
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), // 버튼의 모서리를 둥글게 만듦
                                  ),
                                ),
                                child: const Text('취소'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                 //   MaterialPageRoute(builder: (context) => const LoginScreen()),
                                  ); // 바텀 시트 닫기
                                  // 로그아웃 처리
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: colorWhite,
                                  backgroundColor: colorGreen900,
                                  // 텍스트 색상
                                  textStyle: const TextStyle(fontSize: 16),
                                  // 텍스트 스타일
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 60),
                                  // 버튼 내부 패딩
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), // 버튼의 모서리를 둥글게 만듦
                                  ),
                                ),
                                child: const Text('로그아웃'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 5),
          Container(
            height: 2,
            width: 100.w,
            color: colorGray600,
          ),
          const SizedBox(height: 5),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings, color: colorGreen900),
            title: const Text('관리자 페이지'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingManagerCourt()),
              );
            },
          ),
          const SizedBox(height: 5),
          Container(
            height: 2,
            width: 100.w,
            color: colorGray600,
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
*/