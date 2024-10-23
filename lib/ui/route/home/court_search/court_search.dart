import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../../const/model/model_court.dart';
import '../../../../../../const/value/colors.dart';
import 'court_information.dart';


class CourtSearch extends StatefulWidget {
  const CourtSearch({Key? key}) : super(key: key);

  @override
  _CourtSearchState createState() => _CourtSearchState();
}

class _CourtSearchState extends State<CourtSearch> {
  TextEditingController tceSearch = TextEditingController(); // 검색어 입력을 받는 컨트롤러
  List<ModelCourt> _courts = []; // 전체 코트 목록
  List<ModelCourt> _filteredCourts = []; // 필터링된 코트 목록

  @override
  void initState() {
    super.initState();
    _fetchCourts(); // 화면이 처음 로드될 때 코트 데이터를 가져옴
  }

  Future<void> _fetchCourts() async {
    // Firestore에서 코트 데이터를 가져오는 함수
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('court').get();
    _courts = querySnapshot.docs.map((doc) => ModelCourt.fromJson(doc.data() as Map<String, dynamic>)).toList();
    setState(() {
      _filteredCourts = _courts; // 초기에는 모든 코트를 필터링 목록에 넣음
    });
  }

  void _filterCourts(String query) {
    // 검색어를 기반으로 코트 목록을 필터링하는 함수
    List<ModelCourt> filteredCourts = _courts.where((court) {
      return court.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      _filteredCourts = filteredCourts; // 필터링된 목록을 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height:50),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: tceSearch,
              decoration: InputDecoration(
                labelText: '검색',
                labelStyle: TextStyle(color: colorGreen900),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0), // 둥근 모서리 추가
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0), // 둥근 모서리 추가
                  borderSide: BorderSide(
                    color: colorGreen900, // 기본 상태 테두리 색상
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0), // 둥근 모서리 추가
                  borderSide: BorderSide(
                    color: colorGreen900, // 포커스 상태 테두리 색상
                    width: 2.0,
                  ),
                ),
                suffixIcon: Icon(Icons.search),

                fillColor: Colors.white, // 검색창 배경색 변경
              ),
              onChanged: (query) {
                _filterCourts(query); // 검색어가 변경될 때마다 필터링
              },
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: Offset(0, -20),
              child: ListView.builder(
                itemCount: _filteredCourts.length, // 필터링된 코트의 개수
                itemBuilder: (context, index) {
                  ModelCourt court = _filteredCourts[index];
                  // location 문자열을 공백을 기준으로 두 단어까지만 출력
                  List<String> locationWords = court.location.split(' ');
                  String shortLocation = locationWords.length > 1
                      ? locationWords.sublist(0, 2).join(' ')
                      : court.location;
                  return ListTile(
                    title: Text(court.name),
                    subtitle: Text(shortLocation),
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => CourtInformation(courtId: _courts[index].id),
                      ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    tceSearch.dispose(); // 컨트롤러 해제
    super.dispose();
  }
}
