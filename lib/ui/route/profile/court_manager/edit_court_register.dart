import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../../../const/model/model_court.dart';
import '../../../../../../../../const/value/colors.dart';
import '../../../../../../../../const/value/text_style.dart';
import '../../../../service/utils/utils.dart';

class EditCourtRegister extends StatefulWidget {
  final ModelCourt modelCourt;

  const EditCourtRegister({super.key, required this.modelCourt});

  @override
  State<EditCourtRegister> createState() => _EditCourtRegisterState();
}

class _EditCourtRegisterState extends State<EditCourtRegister> {
  late TextEditingController tecLocation;
  late TextEditingController tecPhone;
  late TextEditingController tecWebsite;
  late TextEditingController tecNotice;
  late TextEditingController tecInformation;
  late TextEditingController tecName;
  late TextEditingController tecLat;
  late TextEditingController tecLng;
  String _imagePath = '';

  @override
  void initState() {
    super.initState();

    tecLocation = TextEditingController(text: widget.modelCourt.location);
    tecPhone = TextEditingController(text: widget.modelCourt.phone);
    tecWebsite = TextEditingController(text: widget.modelCourt.website);
    tecNotice = TextEditingController(text: widget.modelCourt.notice);
    tecInformation = TextEditingController(text: widget.modelCourt.information);
    tecName = TextEditingController(text: widget.modelCourt.name);
    tecLat = TextEditingController(text: widget.modelCourt.courtLat.toString());
    tecLng = TextEditingController(text: widget.modelCourt.courtLng.toString());

    tecLocation.addListener(_checkFields);
    tecPhone.addListener(_checkFields);
    tecWebsite.addListener(_checkFields);
    tecNotice.addListener(_checkFields);
    tecInformation.addListener(_checkFields);
    tecName.addListener(_checkFields);
    tecLat.addListener(_checkFields);
    tecLng.addListener(_checkFields);

    // Initialize _imagePath with the current image path from modelCourt
    _imagePath = widget.modelCourt.imagePath;
  }

  void _checkFields() {
    setState(() {});
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final List<String> listImgUrl = await Utils.getImgUrlXFile([pickedImage]);
      setState(() {
        _imagePath = listImgUrl.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('코트 정보 수정'), // 앱바 제목 수정
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('이미지 선택'), // 이미지 선택 버튼
              ),
              if (_imagePath.isNotEmpty)
                Image.network(
                  _imagePath,
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

              const Text('전화번호'), // 전화번호 입력 레이블
              TextField(
                controller: tecPhone,
                style: const TS.s14w400(colorBlack),
                keyboardType: TextInputType.phone, // 숫자 키패드 활성화
              ),

              const Text('예약사이트 바로가기'), // 웹사이트 입력 레이블
              TextField(
                controller: tecWebsite,
                style: const TS.s14w400(colorBlack),
              ), // 웹사이트 입력 필드

              const Text('안내사항'), // 안내사항 입력 레이블
              TextField(
                controller: tecNotice,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TS.s14w400(colorBlack),
              ),

              const Text('코트 정보'), // 코트 정보 입력 레이블
              TextField(
                controller: tecInformation,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TS.s14w400(colorBlack),
              ),

              const Text('위도'), // 위도 입력 레이블
              TextField(
                controller: tecLat,
                keyboardType: TextInputType.numberWithOptions(decimal: true), // 숫자 키패드 활성화
                style: const TS.s14w400(colorBlack),
              ),

              const Text('경도'), // 경도 입력 레이블
              TextField(
                controller: tecLng,
                keyboardType: TextInputType.numberWithOptions(decimal: true), // 숫자 키패드 활성화
                style: const TS.s14w400(colorBlack),
              ),

              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('저장'), // 저장 버튼 텍스트 추가
                onPressed: () async {
                  if (_validateInputs()) {
                    ModelCourt updatedCourt = ModelCourt(
                      id: widget.modelCourt.id,
                      name: tecName.text,
                      location: tecLocation.text,
                      information: tecInformation.text,
                      phone: tecPhone.text,
                      notice: tecNotice.text,
                      website: tecWebsite.text,
                      imagePath: _imagePath, // 업데이트된 이미지 경로 사용
                      courtLng: double.parse(tecLng.text),
                      courtLat: double.parse(tecLat.text),
                    );
                    await FirebaseFirestore.instance
                        .collection('court')
                        .doc(widget.modelCourt.id)
                        .update(updatedCourt.toJson());
                    Navigator.pop(context, updatedCourt);
                  } else {
                    _showErrorDialog();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateInputs() {
    try {
      double.parse(tecLat.text);
      double.parse(tecLng.text);
      return true;
    } catch (e) {
      return false;
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('입력 오류'),
        content: const Text('위도와 경도는 숫자여야 합니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
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
