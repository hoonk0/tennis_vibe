class ModelNotice {
  final String id;
  final String title;
  final String notice;
  final String date;


  // 생성자
  ModelNotice({
    required this.id,
    required this.title,
    required this.notice,
    required this.date
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'notice': notice,
      'date': date,
    };
  }

  factory ModelNotice.fromJson(Map<String, dynamic> json) {
    return ModelNotice(
      id: json['id'],
      title: json['title'],
      notice: json['notice'],
      date: json['date'],

    );
  }
}
