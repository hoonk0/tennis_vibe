import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tennis_vibe/ui/route/profile/notice/setting_notice_detail.dart';
import '../../../../../../../../const/model/model_notice.dart';
import '../../../../../../../../const/value/colors.dart';
import '../../../../../../const/value/enum.dart';
import '../../../../service/provider/providers.dart';
import 'new_notice.dart';

class SettingNotice extends StatefulWidget {
  const SettingNotice({Key? key}) : super(key: key);

  @override
  State<SettingNotice> createState() => _SettingNoticeState();
}

class _SettingNoticeState extends State<SettingNotice> {
  late List<ModelNotice> modelNotices;

  @override
  void initState() {
    super.initState();
    modelNotices = [];
    _fetchModelNotice();
  }

  Future<void> _fetchModelNotice() async {
    final noticeSnapshot = await FirebaseFirestore.instance.collection('notice').get();
    final List<ModelNotice> fetchedModelNotices = noticeSnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return ModelNotice.fromJson(data);
    }).toList();

    setState(() {
      modelNotices = fetchedModelNotices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffe8e8e8),
        automaticallyImplyLeading: false,
        title: Text(
        'Notice',
        style: GoogleFonts.anton(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            color: colorGreen900,
            fontSize: 24,
          ),
        ),
      ),

        centerTitle: true,
        actions: [
          /*
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewNoticeRegister()),
              );
              if (result == true) {
                _fetchModelNotice();
              }
            },
            icon: const Icon(Icons.add),
          ),*/

          ValueListenableBuilder(
            valueListenable: userNotifier,
            builder: (context, userMe, child) {
              if (userMe != null && userMe.userGrade == UserGrade.admin) {
                return IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NewNoticeRegister()),
                    );
                    if (result == true) {
                      _fetchModelNotice();
                    }
                  },
                  icon: const Icon(Icons.add),
                );
              } else {
                return Container();
              }
            },
          ),

          //관리자만 접근가능으로 세팅 필요
        ],
      ),
      body: Column(
        children: [

          Expanded(
            child: modelNotices.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: modelNotices.length,
              itemBuilder: (context, index) {
                final notice = modelNotices[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingNoticeDetail(modelNotice: notice),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                        title: Text(
                          notice.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: colorGreen900),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text(
                              '날짜: ${notice.date}',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: colorGreen900),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: colorGreen900,
                        thickness: 1,
                        indent: 15,
                        endIndent: 15,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
