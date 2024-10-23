import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tennis_vibe/ui/route/tab/0_tab_home.dart';
import 'package:tennis_vibe/ui/route/tab/1_tab_favorite.dart';
import 'package:tennis_vibe/ui/route/tab/2_tab_profile.dart';

import '../../const/value/colors.dart';
import '../../const/value/gaps.dart';

class RouteMain extends StatefulWidget {
  const RouteMain({super.key});

  @override
  State<RouteMain> createState() => _RouteMainState();
}

class _RouteMainState extends State<RouteMain> {
  final ValueNotifier<int> vnTabIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: vnTabIndex,
      builder: (context, tabIndex, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: tabIndex == 0
              ? Text('홈', style: TextStyle(color: colorGreen900),)
              : tabIndex == 1
              ? Text('선호 코트',style: TextStyle(color: colorGreen900),)
              : Text('프로필',style: TextStyle(color: colorGreen900),),
        ),

        backgroundColor: colorWhite,
        body: SafeArea(
          child: PageView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              if (tabIndex == 0) {
                return TabHome();
              }
              if (tabIndex == 1) {
                return TabFavorite();
              }
              if (tabIndex == 2) {
                return TabProfile();
              }
             ;
            },
            onPageChanged: (value) {
              vnTabIndex.value = value;
            },
          ),
        ),
        bottomNavigationBar: Row(
          children: List.generate(
            3,
                (index) => Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    vnTabIndex.value = index;
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        index == 0
                            ? 'assets/icons/home.png'
                            : index == 1
                            ? 'assets/icons/video.png'
                            : 'assets/icons/person.png',
                        width: 28, // 이미지 너비 (옵션)
                        height: 28, // 이미지 높이 (옵션)
                        fit: BoxFit.cover,
                        color: vnTabIndex.value == index ? colorGreen900 : colorGray900, // 이미지 맞춤 방식 (옵션)
                      ),
                      Gaps.v5,
                      Text(
                        index == 0
                            ? '홈'
                            : index == 1
                            ? '선호 코트'
                            : '프로필',
                        style: TextStyle(
                          color: vnTabIndex.value == index ? colorGreen900 : colorGray900,
                          fontWeight: FontWeight.w400,
                          fontSize: 11, // 글씨 크기 조정
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
