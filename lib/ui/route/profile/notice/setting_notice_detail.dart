import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../../../const/model/model_notice.dart';
import '../../../../../../../../const/value/colors.dart';
import '../../../../../../../../const/value/text_style.dart';

class SettingNoticeDetail extends StatelessWidget {
  final ModelNotice modelNotice;

  const SettingNoticeDetail({Key? key, required this.modelNotice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '공지사항',
          style: GoogleFonts.anton(
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorGreen900,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬을 위한 설정
          children: [
            Text(
              modelNotice.title,
              style: TS.s20w700(colorGreen900),
              textAlign: TextAlign.start, // 명시적으로 왼쪽 정렬 설정
            ),

            Divider(
              color: colorGreen900,
              thickness: 1,
              indent: 0,
              endIndent: 15,
            ),

            SizedBox(
              height: 10,
            ),

            Text(
              modelNotice.notice,
              style: TS.s14w400(colorGreen900),
              textAlign: TextAlign.start, // 명시적으로 왼쪽 정렬 설정
            ),
          ],
        ),
      ),
    );
  }
}
