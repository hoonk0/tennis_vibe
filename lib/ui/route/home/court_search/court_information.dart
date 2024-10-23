import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../const/model/model_court.dart';
import '../../../../../../const/value/colors.dart';
import '../../../../../../const/value/text_style.dart';
import '../../../../const/value/keys.dart';
import '../../../../service/provider/providers.dart';
import 'court_location.dart';

class CourtInformation extends StatefulWidget {
  final String courtId;

  const CourtInformation({super.key, required this.courtId});

  @override
  State<CourtInformation> createState() => _CourtInformationState();
}

class _CourtInformationState extends State<CourtInformation> {
  final ValueNotifier<bool> vnIsFavorite = ValueNotifier(false);

  Future<ModelCourt?> _fetchCourtDetails() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('court').doc(widget.courtId).get();
      if (doc.exists) {
        return ModelCourt.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching court details: $e");
      }
    }
    return null;
  }

  // 주소 앞에 2단어만 나오게 하는 코드
  String _getFirstTwoWords(String input) {
    List<String> words = input.split(' ');
    if (words.length >= 2) {
      return '${words[0]} ${words[1]}';
    } else if (words.length == 1) {
      return words[0];
    } else {
      return ''; // 빈 문자열 반환
    }
  }

  // url 아이콘 기능
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // 전화번호 연결 아이콘 기능
  Future<void> _makePhoneCall(String phoneNumber) async {
    final String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffe8e8e8),
        centerTitle: true,
        title: const Text(
          '코트 정보',
          style: TS.s20w700(colorGreen900),
        ),
      ),
      body: FutureBuilder<ModelCourt?>(
        future: _fetchCourtDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('에러 발생'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('데이터 없음'));
          }

          ModelCourt court = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (court.imagePath.isNotEmpty)
                    Image.network(
                      court.imagePath,
                      fit: BoxFit.cover,
                      height: 30.h,
                    ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(court.name, style: const TS.s20w600(colorGreen900)),
                          SizedBox(width: 10),
                          Transform.translate(
                            offset: const Offset(-10, 0),
                            child: IconButton(
                              onPressed: () {
                                if (userNotifier.value!.favorites.contains(widget.courtId)) {
                                  FirebaseFirestore.instance.collection('user').doc(userNotifier.value!.uid).update({
                                    keyFavorites: FieldValue.arrayRemove([widget.courtId])
                                  });
                                } else {
                                  FirebaseFirestore.instance.collection('user').doc(userNotifier.value!.uid).update({
                                    keyFavorites: FieldValue.arrayUnion([widget.courtId])
                                  });
                                }
                              },
                              icon: ValueListenableBuilder(
                                valueListenable: userNotifier,
                                builder: (context, userMe, child) {
                                  if (userMe == null) {
                                    // userMe가 null인 경우 처리
                                    return Container(); // 예시: 빈 Container를 반환하거나 원하는 처리를 수행하세요.
                                  }
                                  final isMyCourt = userMe.favorites.contains(widget.courtId);
                                  return Icon(
                                    isMyCourt ? Icons.star : Icons.star_border_purple500_sharp,
                                    color: isMyCourt ? colorPrimary200 : colorGreen900,
                                  );
                                },
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(-10, 0),
                            child: IconButton(
                              onPressed: () {
                                if (userNotifier.value!.notify.contains(widget.courtId)) {
                                  FirebaseFirestore.instance.collection('user').doc(userNotifier.value!.uid).update({
                                    'notify': FieldValue.arrayRemove([widget.courtId])
                                  });
                                } else {
                                  FirebaseFirestore.instance.collection('user').doc(userNotifier.value!.uid).update({
                                    'notify': FieldValue.arrayUnion([widget.courtId])
                                  });
                                }
                              },
                              icon: ValueListenableBuilder(
                                valueListenable: userNotifier,
                                builder: (context, userMe, child) {
                                  if (userMe == null) {
                                    // userMe가 null인 경우 처리
                                    return Container(); // 예시: 빈 Container를 반환하거나 원하는 처리를 수행하세요.
                                  }
                                  final isMyCourt = userMe.notify.contains(widget.courtId);
                                  return Icon(
                                    isMyCourt ? Icons.notifications : Icons.notifications_none_outlined,
                                    color: isMyCourt ? colorPrimary200 : colorGreen900,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _getFirstTwoWords(court.location),
                        style: const TS.s14w400(colorGray600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 1,
                    width: 80.w,
                    color: colorGreen900,
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        court.notice,
                        style: const TS.s14w400(colorBlack),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 1,
                    width: 80.w,
                    color: colorGreen900,
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('📰 기본정보', style: TS.s16w400(colorBlack)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        const Text('전화번호', style: TS.s14w400(colorBlack)),
                        IconButton(
                          onPressed: () async {
                            await _makePhoneCall(court.phone);
                          },
                          icon: const Icon(Icons.phone),
                        ),
                        const Text('예약사이트', style: TS.s14w400(colorBlack)),
                        IconButton(
                          onPressed: () async {
                            final url = court.website;
                            await _launchURL(url);
                          },
                          icon: const Icon(Icons.web),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        const Text('주소', style: TS.s14w400(colorBlack)),
                        IconButton(
                          onPressed: () async {
                            final CameraPosition initialPosition = CameraPosition(
                              target: LatLng(court.courtLat, court.courtLng),
                              zoom: 15,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourtLocation(initialPosition: initialPosition),
                              ),
                            );
                          },
                          icon: const Icon(Icons.location_on),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        court.location,
                        style: const TS.s14w400(colorBlack),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
