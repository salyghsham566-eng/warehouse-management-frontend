class PharmacyModel {
  final int? id;
  final String name;
  final String branch;
  final String area;
  final String address;
  final double dueAmount;
  final String image;

  const PharmacyModel({
    this.id,
    required this.name,
    required this.branch,
    required this.area,
    required this.address,
    required this.dueAmount,
    required this.image,
  });

  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    return PharmacyModel(
      id: _parseNullableInt(json['id']),
      name: json['name']?.toString() ?? '',
      branch:
          (json['branch'] ?? json['branch_name'])?.toString() ?? '',
      area: json['area']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      dueAmount: _parseDouble(
        json['due_amount'] ?? json['dueAmount'],
      ),
      image:
    (
      json['image'] ??
      json['image_url'] ??
      json['imageUrl']
    )?.toString() ??
    '',
    );
  }

  /// الشكل الذي سنرسله أو نتفق عليه مع الباك.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'branch': branch,
      'area': area,
      'address': address,
      'due_amount': dueAmount,
      'image': image,
    };
  }

  /// نبقيه مؤقتًا بالشكل القديم حتى لا ينكسر الكود الحالي.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'branch': branch,
      'area': area,
      'address': address,
      'dueAmount': dueAmount,
      'image': image,
    };
  }
}

int? _parseNullableInt(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value.toString());
}

double _parseDouble(dynamic value) {
  if (value == null) {
    return 0;
  }

  if (value is double) {
    return value;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString()) ?? 0;
}