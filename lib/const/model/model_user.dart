import 'package:cloud_firestore/cloud_firestore.dart';
import '../enum/enums.dart';
import '../value/enum.dart';

class ModelUser {
  final String uid;
  final String nickname;
  final String email;
  final String phoneNumber;
  final EnumLoginType loginType;
  final bool isAdmin;
  final List<String> favorites;
  final List<String> notify;
  final UserGrade userGrade;

  const ModelUser({
    required this.uid,
    required this.nickname,
    required this.email,
    required this.phoneNumber,
    required this.loginType,
    this.isAdmin = false,
    this.favorites = const [],
    this.notify = const [],
    this.userGrade = UserGrade.guest,
  });

  // fromJson
  factory ModelUser.fromJson(Map<String, dynamic> json) {
    return ModelUser(
      uid: json['uid'],
      nickname: json['nickname'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      loginType: EnumLoginType.values.firstWhere((e) => e.name == json['loginType']),
      isAdmin: json['isAdmin'] ?? false,
      favorites: List<String>.from(json['favorites'] ?? []),
      notify: List<String>.from(json['notify'] ?? []),
      userGrade: UserGrade.values
          .firstWhere((userGrade) => userGrade.name == json['userGrade'] ),
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nickname': nickname,
      'email': email,
      'phoneNumber': phoneNumber,
      'loginType': loginType.name,
      'isAdmin': isAdmin,
      'favorites': favorites,
      'userGrade': userGrade.name,
    };
  }

  // copyWith
  ModelUser copyWith({
    String? uid,
    String? nickname,
    String? email,
    Timestamp? dateCreate,
    int? experienceMonth,
    int? birthYear,
    String? phoneNumber,
    EnumLoginType? loginType,
    int? winPoint,
  }) {
    return ModelUser(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      loginType: loginType ?? this.loginType,
    );
  }
}
