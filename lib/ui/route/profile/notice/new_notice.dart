import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../../../const/model/model_notice.dart';
import '../../../../../../../../const/value/colors.dart';
import '../../../../../../../../const/value/text_style.dart';


class NewNoticeRegister extends StatefulWidget {
  const NewNoticeRegister({super.key});

  @override
  State<NewNoticeRegister> createState() => _NewNoticeRegisterState();
}

class _NewNoticeRegisterState extends State<NewNoticeRegister> {
  TextEditingController tecTitle = TextEditingController();
  TextEditingController tecNotice = TextEditingController();
  TextEditingController tecDate = TextEditingController();
  bool _areAllFieldsFilled = false;

  @override
  void initState() {
    super.initState();
    tecTitle.addListener(_checkFields);
    tecNotice.addListener(_checkFields);
    tecDate.addListener(_checkFields);
  }

  void _checkFields() {
    setState(() {
      _areAllFieldsFilled = tecTitle.text.isNotEmpty &&
          tecNotice.text.isNotEmpty &&
          tecDate.text.isNotEmpty;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항 추가_관리자'),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Text('제목'), // 제목 입력 레이블
              TextField(
                controller: tecTitle,
                style: const TS.s14w400(colorBlack),
              ),// 선택된 이미지 미리보기

              const Text('내용'), // 제목 입력 레이블
              TextField(
                controller: tecNotice,
                style: const TS.s14w400(colorBlack),
              ), // 제목 입력 필드

              const Text('날짜'), // 가격 입력 레이블
              TextField(
                controller: tecDate,
                style: const TS.s14w400(colorBlack),
              ),

              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () async {
                  if (_areAllFieldsFilled) {
                    final id = const Uuid().v4();
                    ModelNotice modelNotice = ModelNotice(
                      id: id,
                      title: tecTitle.text,
                      notice: tecNotice.text,
                      date: tecDate.text,

                    );
                    await FirebaseFirestore.instance.collection('notice').doc(modelNotice.id).set(modelNotice.toJson());
                    Navigator.pop(context, modelNotice);
                  }else{
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('입력 오류'),
                          content: const Text('모든 필드를 작성해주세요.'),
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
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
