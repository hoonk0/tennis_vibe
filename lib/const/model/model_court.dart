class ModelCourt {
  final String id;
  final String name;
  final String imagePath;
  final String location;
  final String phone;
  final String website;
  final String notice;
  final String information;
  final double courtLat;
  final double courtLng;

  // 생성자
  ModelCourt({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.location,
    required this.phone,
    required this.website,
    required this.notice,
    required this.information,
    required this.courtLat,
    required this.courtLng,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'location': location,
      'phone': phone,
      'website': website,
      'notice': notice,
      'information': information,
      'courtLat': courtLat,
      'courtLng': courtLng,
    };
  }

  factory ModelCourt.fromJson(Map<String, dynamic> json) {
    return ModelCourt(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imagePath: json['imagePath'] ?? '',
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      notice: json['notice'] ?? '',
      information: json['information'] ?? '',
      courtLat: json['courtLat'] != null ? double.parse(json['courtLat'].toString()) : 0.0,
      courtLng: json['courtLng'] != null ? double.parse(json['courtLng'].toString()) : 0.0,
    );
  }

}
