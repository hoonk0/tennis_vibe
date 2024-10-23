import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../const/model/model_court.dart';
import '../../../const/model/model_user.dart';
import '../../../const/value/colors.dart';
import '../../../const/value/gaps.dart';
import '../../../const/value/text_style.dart';
import '../../../service/provider/providers.dart';
import '../home/court_map/neartby_courts_map.dart';
import '../home/court_search/court_information.dart';
import '../home/court_search/court_search.dart';

class TabHome extends StatefulWidget {
  const TabHome({super.key});

  @override
  State<TabHome> createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> {
  late List<ModelCourt> modelCourts;
  StreamSubscription? streamSub;

  @override
  void initState() {
    super.initState();
    modelCourts = []; // 데이터를 담을 리스트 초기화
    _fetchCourtData(); // Firestore에서 데이터 가져오기
    streamMe();
    _loadNearbyCourts(); // 근처 코트 데이터 로드
  }
  Future<void> streamMe() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString('uid');

    if (userId == null) {
      debugPrint("userId가 null입니다.");
      return; // null이면 바로 종료
    }

    streamSub = FirebaseFirestore.instance
        .collection('member')
        .doc(userId)
        .snapshots()
        .listen((event) {
      final data = event.data();
      if (data != null) {
        final ModelUser newModelMember = ModelUser.fromJson(data);
        userNotifier.value = newModelMember;
        debugPrint("유저정보 업데이트 ${userNotifier.value!.toJson()}");
      } else {
        debugPrint("Firestore 문서 데이터가 null입니다.");
      }
    }, onError: (error) {
      debugPrint("Firestore 오류 발생: $error");
    });
  }


  Future<void> _fetchCourtData() async {
    // 시작시간
    final now = DateTime.now();
    debugPrint("시작시간 $now");
    final courtSnapshot = await FirebaseFirestore.instance.collection('court').get();
    final List<ModelCourt> fetchedModelCourts = courtSnapshot.docs.map((doc) {
      final data = doc.data();
      return ModelCourt.fromJson(data);
    }).toList();
    // 경과시간
    final elapsed = DateTime.now().difference(now);
    debugPrint("경과시간 $elapsed");

    // 1. 현재 위젯트리를 dispose 안되게 하는 방법
    // 2. final courtSnapshot = await FirebaseFirestore.instance.collection('court').get();를 끝마치고서 이 위젯트리로 오게
    // 3. Widget Tree에 살아있을때만 실행
    debugPrint("mounted $mounted");
    if (mounted) {
      setState(() {
        modelCourts = fetchedModelCourts;
      });
    } else {
      debugPrint("위젯트리 죽음");
    }
  }

  Future<void> _loadNearbyCourts() async {
    // TODO: 근처 코트 데이터를 로드하고 화면에 표시하는 기능 구현
    // 여기에 코드를 추가하세요.
  }

  @override
  void dispose() {
    debugPrint("UserHome dispose");
    // TODO: implement dispose
    super.dispose();
    streamSub?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CourtSearch()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: colorWhite,
                    border: Border.all(color: colorGreen900, width: 2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16.0),
                        child: Text(
                          '원하는 코트를 검색하세요.',
                          style: TS.s13w500(colorGray900),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Gaps.v20,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '주변 코트 검색하기',
                    style: TS.s14w700(colorGray900),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CourtSearch()),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                    color: colorGray900,
                  ),
                ],
              ),
              SizedBox(
                height: 150,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1,
                  ),
                  itemCount: modelCourts.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        final watchModelCourt = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CourtInformation(
                                courtId: modelCourts[index].id,
                              )),
                        );

                        if (watchModelCourt != null) {
                          setState(() {
                            modelCourts[index] = watchModelCourt;
                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: modelCourts[index].imagePath.isNotEmpty
                                  ? Image.network(
                                modelCourts[index].imagePath,
                                fit: BoxFit.cover,
                              )
                                  : const Icon(Icons.image),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  modelCourts[index].name,
                                  style: const TS.s12w600(colorBlack),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Gaps.v20,

              Row(
                children: [
                  Text(
                    'NEARBY 5KM',
                    style: TS.s14w700(colorGray900),
                  ),
                ],
              ),

              Gaps.v10,
              // `NearbyCourtsMap`을 Expanded로 감싸기
              const SizedBox(
                height: 300, // 원하는 높이로 설정 가능
                child: NearbyCourtsMap(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
