import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../../../const/model/model_court.dart';
import '../../../../../../../../const/value/colors.dart';
import '../../../../../../../../const/value/text_style.dart';
import '../../../../service/utils/utils.dart';

class NewCourtRegister extends StatefulWidget {
  const NewCourtRegister({super.key});

  @override
  State<NewCourtRegister> createState() => _NewCourtRegisterState();
}

class _NewCourtRegisterState extends State<NewCourtRegister> {
  TextEditingController tecLocation = TextEditingController();
  TextEditingController tecPhone = TextEditingController();
  TextEditingController tecWebsite = TextEditingController();
  TextEditingController tecNotice = TextEditingController();
  TextEditingController tecInformation = TextEditingController();
  TextEditingController tecName = TextEditingController();
  TextEditingController tecLat = TextEditingController();
  TextEditingController tecLng = TextEditingController();
  XFile? selectedXFile;
  String _imagePath = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    selectedXFile = await picker.pickImage(source: ImageSource.gallery);

    if (selectedXFile != null) {
      setState(() {
        _imagePath = selectedXFile!.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 코트 등록_관리자'), // 앱바 제목
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Select Image'), // 이미지 선택 버튼
              ),
              if (_imagePath.isNotEmpty)
                Image.file(
                  File(_imagePath),
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),

              const Text('테니스장명'), // 제목 입력 레이블
              TextField(
                controller: tecName,
                style: const TS.s14w400(colorBlack),
              ), // 선택된 이미지 미리보기

              const Text('주소'), // 제목 입력 레이블
              TextField(
                controller: tecLocation,
                style: const TS.s14w400(colorBlack),
              ), // 제목 입력 필드

              const Text('전화번호'), // 가격 입력 레이블
              TextField(
                controller: tecPhone,
                style: const TS.s14w400(colorBlack),
                keyboardType: TextInputType.number, // 숫자 키패드 활성화
              ),

              const Text('예약사이트 바로가기'), // 제목 입력 레이블
              TextField(
                controller: tecWebsite,
                style: const TS.s14w400(colorBlack),
              ), // 제목 입력 필드// 가격 입력 필드

              const Text('안내사항'), // 내용 입력 레이블
              TextField(
                controller: tecNotice,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TS.s14w400(colorBlack),
              ),

              const Text('코트 정보'), // 내용 입력 레이블
              TextField(
                controller: tecInformation,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TS.s14w400(colorBlack),
              ),

              const Text('위도'), // 내용 입력 레이블
              TextField(
                controller: tecLat,
                maxLines: null,
                keyboardType: TextInputType.number,
                style: const TS.s14w400(colorBlack),
              ),

              const Text('경도'), // 내용 입력 레이블
              TextField(
                controller: tecLng,
                maxLines: null,
                keyboardType: TextInputType.number,
                style: const TS.s14w400(colorBlack),
              ),

              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () async {
                  final id = const Uuid().v4();
                  List<String> listImgUrl = [];

                  // 이미지가 선택된 경우에만 업로드
                  if (selectedXFile != null) {
                    listImgUrl = await Utils.getImgUrlXFile([selectedXFile]);
                    debugPrint("listImgUrl $listImgUrl");
                  }

                  ModelCourt modelCourt = ModelCourt(
                    id: id,
                    name: tecName.text,
                    location: tecLocation.text,
                    information: tecInformation.text,
                    phone: tecPhone.text,
                    notice: tecNotice.text,
                    website: tecWebsite.text,
                    imagePath: listImgUrl.isNotEmpty ? listImgUrl.first : '', // 이미지 경로 설정
                    courtLng: double.tryParse(tecLng.text) ?? 0.0,
                    courtLat: double.tryParse(tecLat.text) ?? 0.0,
                  );

                  await FirebaseFirestore.instance.collection('court').doc(modelCourt.id).set(modelCourt.toJson());
                  Navigator.pop(context, modelCourt);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    tecWebsite.dispose();
    tecName.dispose();
    tecInformation.dispose();
    tecNotice.dispose();
    tecPhone.dispose();
    tecLocation.dispose();
    tecLng.dispose();
    tecLat.dispose();
    super.dispose();
  }
}
