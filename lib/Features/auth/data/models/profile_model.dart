class ProfileModel {
  final String username;
  final String fullName;
  final String phone;
  final String role;
  final String accountStatus;
  final String address;
  final String governorate;
  final String birthDate;
  final bool canEditUsername;
  final String? imageUrl;

  const ProfileModel({
    required this.username,
    required this.fullName,
    required this.phone,
    required this.role,
    required this.accountStatus,
    required this.address,
    required this.governorate,
    required this.birthDate,
    required this.canEditUsername,
    this.imageUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      accountStatus: json['accountStatus'] ?? '',
      address: json['address'] ?? '',
      governorate: json['governorate'] ?? '',
      birthDate: json['birthDate'] ?? '',
      canEditUsername: json['canEditUsername'] ?? false,
      imageUrl: json['imageUrl'],
    );
  }

  ProfileModel copyWith({
    String? username,
    String? phone,
    String? address,
    String? governorate,
    String? birthDate,
    String? imageUrl,
  }) {
    return ProfileModel(
      username: username ?? this.username,
      fullName: fullName,
      phone: phone ?? this.phone,
      role: role,
      accountStatus: accountStatus,
      address: address ?? this.address,
      governorate: governorate ?? this.governorate,
      birthDate: birthDate ?? this.birthDate,
      canEditUsername: canEditUsername,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
