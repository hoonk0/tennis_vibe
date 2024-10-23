class ModelContact {
  final String id;
  final String title;
  final String notice;
  final String content;


  // 생성자
  ModelContact({
    required this.id,
    required this.title,
    required this.notice,
    required this.content
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'notice': notice,
      'content': content,
    };
  }

  factory ModelContact.fromJson(Map<String, dynamic> json) {
    return ModelContact(
      id: json['id'],
      title: json['title'],
      notice: json['notice'],
      content: json['content'],

    );
  }
}
