/*
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../const/enum/enums.dart';
import '../../../const/model/model_user.dart';
import '../../../const/service/utils/utils.dart';
import '../../../const/static/global.dart';
import '../../../const/value/colors.dart';
import '../../../const/value/gaps.dart';
import '../../../const/value/keys.dart';
import '../../../const/value/text_style.dart';
import '../../component/button_basic.dart';
import '../../component/dropdown_border.dart';
import '../../component/widget_container.dart';
import '../route_splash.dart';

class RouteAuthProfile extends StatefulWidget {
  final String email;
  final String phoneNumber;
  final String nickname;
  final String uid;
  final EnumLoginType loginType;

  const RouteAuthProfile({
    super.key,
    required this.email,
    required this.phoneNumber,
    required this.nickname,
    required this.uid,
    required this.loginType,
  });

  @override
  State<RouteAuthProfile> createState() => _RouteAuthProfileState();
}

class _RouteAuthProfileState extends State<RouteAuthProfile> {
  late List<String> listYear;
  late List<String> listMonth;
  final ValueNotifier<String?> vnSelectedBirthYear = ValueNotifier(null);
  final ValueNotifier<String?> vnSelectedYear = ValueNotifier(null);
  final ValueNotifier<String?> vnSelectedMonth = ValueNotifier(null);
  final ValueNotifier<String?> vnSelectedSex = ValueNotifier(null);
  final ValueNotifier<String?> vnExpPeriod = ValueNotifier(null);
  int? experienceMonth;
  final ValueNotifier<bool> vnIsCheckAllComplete = ValueNotifier(false);
  final imagePicker = ImagePicker();
  final ValueNotifier<XFile?> vnXFile = ValueNotifier(null);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    makeListDate();
  }

  makeListDate() {
    final thisYear = DateTime.now().year;
    listYear = List.generate(70, (index) => (thisYear - index).toString());
    listMonth = List.generate(12, (index) => (index + 1).toString());
  }

  bool checkAllComplete() {
    final condition1 = vnSelectedSex.value != null;
    final condition2 = vnSelectedBirthYear.value != null;
    final condition3 = experienceMonth != null;
    final condition4 = vnXFile.value != null;
    debugPrint(" condition1 : $condition1 , condition2 : $condition2 , condition3 : $condition3");
    return condition1 && condition2 && condition3 */
/*&& condition4*//*
;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v30,
              GestureDetector(
                onTap: () async {
                  XFile? photo = await imagePicker.pickImage(source: ImageSource.gallery);
                  if (photo != null) {
                    vnXFile.value = photo;
                  }
                  vnIsCheckAllComplete.value = checkAllComplete();
                },
                child: Center(
                  child: ValueListenableBuilder(
                    valueListenable: vnXFile,
                    builder: (context, xFile, child) {
                      if (xFile == null) {
                        return Image.asset('assets/images/person_edit.png', width: 100);
                      } else {
                        return ClipOval(
                          child: Image.file(
                            File(xFile.path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              Gaps.v20,
              const Text('성별', style: TS.s14w500(colorGray900)),
              Gaps.v5,
              ValueListenableBuilder(
                valueListenable: vnSelectedSex,
                builder: (context, selectedSex, child) {
                  return Row(
                    children: [
                      Expanded(
                        child: WidgetContainer(
                          onTap: () {
                            vnSelectedSex.value = '남성';
                            vnIsCheckAllComplete.value = checkAllComplete();
                          },
                          circularNum: 4,
                          colorBg: colorWhite,
                          colorBorder: selectedSex == '남성' ? colorGreen600 : colorGray400,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('남성', style: TS.s15w500(colorGray900)),
                              Icon(Icons.check, color: selectedSex == '남성' ? colorGreen600 : colorGray200),
                            ],
                          ),
                        ),
                      ),
                      Gaps.h10,
                      Expanded(
                        child: WidgetContainer(
                          onTap: () {
                            vnSelectedSex.value = '여성';
                            vnIsCheckAllComplete.value = checkAllComplete();
                          },
                          circularNum: 4,
                          colorBg: colorWhite,
                          colorBorder: selectedSex == '여성' ? colorGreen600 : colorGray400,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('여성', style: TS.s15w500(colorGray900)),
                              Icon(Icons.check, color: selectedSex == '여성' ? colorGreen600 : colorGray200),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Gaps.v20,
              const Text('출생년도', style: TS.s14w500(colorGray900)),
              Gaps.v5,
              ValueListenableBuilder(
                valueListenable: vnSelectedBirthYear,
                builder: (context, selectedBirthYear, child) {
                  return DropdownButtonHideUnderline(
                    child: DropdownBorder(
                      value: selectedBirthYear,
                      hint: const Text(
                        '연도 선택',
                        style: TS.s16w400(colorGray600),
                      ),
                      items: listYear
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Row(
                                children: [
                                  Text('$e년', style: const TS.s16w400(colorBlack)),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        vnSelectedBirthYear.value = value;
                        vnIsCheckAllComplete.value = checkAllComplete();
                      },
                    ),
                  );
                },
              ),
              Gaps.v20,
              const Text('테니스 구력', style: TS.s14w500(colorGray900)),
              Gaps.v5,
              Row(
                children: [
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: vnSelectedYear,
                      builder: (context, selectedYear, child) {
                        return DropdownButtonHideUnderline(
                          child: DropdownBorder(
                            value: selectedYear,
                            hint: const Text(
                              '연도 선택',
                              style: TS.s16w400(colorGray600),
                            ),
                            items: listYear
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Row(
                                      children: [
                                        Text('$e년', style: const TS.s16w400(colorBlack)),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              vnSelectedYear.value = value;
                              if (vnSelectedMonth.value != null && vnSelectedYear.value != null) {
                                final year = int.parse(vnSelectedYear.value!);
                                final month = int.parse(vnSelectedMonth.value!);
                                WidgetsBinding.instance.endOfFrame.then((value) {
                                  experienceMonth = getTotalMonths(year, month);
                                  debugPrint("experienceMonth $experienceMonth");
                                  vnExpPeriod.value = formatToYearMonth(experienceMonth!);
                                  vnIsCheckAllComplete.value = checkAllComplete();
                                });
                              }

                              vnIsCheckAllComplete.value = checkAllComplete();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Gaps.h10,
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: vnSelectedMonth,
                      builder: (context, selectedMonth, child) {
                        return DropdownButtonHideUnderline(
                          child: DropdownBorder(
                            value: selectedMonth,
                            hint: const Text(
                              '월 선택',
                              style: TS.s16w400(colorGray600),
                            ),
                            items: listMonth
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Row(
                                      children: [
                                        Text('$e월', style: const TS.s16w400(colorBlack)),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              vnSelectedMonth.value = value;
                              if (vnSelectedMonth.value != null && vnSelectedYear.value != null) {
                                final year = int.parse(vnSelectedYear.value!);
                                final month = int.parse(vnSelectedMonth.value!);
                                WidgetsBinding.instance.endOfFrame.then((value) {
                                  experienceMonth = getTotalMonths(year, month);
                                  vnExpPeriod.value = formatToYearMonth(experienceMonth!);
                                  vnIsCheckAllComplete.value = checkAllComplete();
                                });
                              }

                              vnIsCheckAllComplete.value = checkAllComplete();
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              Gaps.v10,
              ValueListenableBuilder(
                valueListenable: vnExpPeriod,
                builder: (context, expPeriod, child) {
                  if (expPeriod != null) {
                    return Row(
                      children: [
                        SvgPicture.asset('assets/svg/warning_mark.svg', width: 12),
                        Gaps.h4,
                        Text('테니스 구력은 총 $expPeriod 입니다.', style: const TS.s12w500(colorRed)),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                  ;
                },
              ),
              const Expanded(child: Gaps.v1),
              ValueListenableBuilder(
                valueListenable: vnIsCheckAllComplete,
                builder: (context, isCheckAllComplete, child) {
                  return ButtonBasic(
                    title: '가입완료',
                    titleColorBg: isCheckAllComplete ? colorWhite : colorGray500,
                    colorBg: isCheckAllComplete ? colorGreen600 : colorGray200,
                    onTap: () async {
                      */
/*if (vnXFile.value == null) {
                        Utils.toast(desc: '프로필 사진을 등록해주세요.');
                        return;
                      }*//*

                      if (vnSelectedSex.value == null) {
                        Utils.toast(desc: '성별을 선택해주세요.');
                        return;
                      }

                      if (vnSelectedBirthYear.value == null) {
                        Utils.toast(desc: '출생년도를 선택해주세요.');
                        return;
                      }

                      if (experienceMonth == null) {
                        Utils.toast(desc: '테니스 구력을 선택해주세요.');
                        return;
                      }
                      Utils.toast(desc: '잠시만 기다려주세요');

                      List<String> listImgUrl = [];
                      if (vnXFile.value != null) {
                        listImgUrl = await Utils.getCImgFromListXFile([vnXFile.value!]);
                      }
                      final modelUser = ModelUser(
                        uid: widget.uid,
                        nickname: widget.nickname,
                        dateCreate: Timestamp.now(),
                        experienceMonth: experienceMonth!,
                        birthYear: int.parse(vnSelectedBirthYear.value!),
                        phoneNumber: widget.phoneNumber,
                        email: widget.email,
                        loginType: widget.loginType,
                      );
                      pref!.setString(keyUid, modelUser.uid);
                      await FirebaseFirestore.instance.collection(keyUser).doc(modelUser.uid).set(modelUser.toJson());
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const RouteSplash()), (route) => false);
                    },
                  );
                },
              ),
              Gaps.v16,
            ],
          ),
        ),
      ),
    );
  }

  int getTotalMonths(int selectedYear, int selectedMonth) {
    final currentYear = DateTime.now().year;
    final currentMonth = DateTime.now().month;

    int totalYears = currentYear - selectedYear;
    int totalMonths = totalYears * 12 + (currentMonth - selectedMonth);

    return totalMonths;
  }

  String formatToYearMonth(int totalMonths) {
    int years = totalMonths ~/ 12;
    int months = totalMonths % 12;

    if (years > 0 && months > 0) {
      return '$years년 $months개월';
    } else if (years > 0) {
      return '$years년';
    } else {
      return '$months개월';
    }
  }
}
*/
