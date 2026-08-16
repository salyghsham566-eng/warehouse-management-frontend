import 'dart:typed_data';

class ProfileRegionModel {
  final String name;
  final int? pharmaciesCount;

  const ProfileRegionModel({
    required this.name,
    this.pharmaciesCount,
  });

  factory ProfileRegionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    int? readCount() {
      final dynamic value =
          json['pharmacies_count'] ??
          json['pharmaciesCount'] ??
          json['pharmacy_count'] ??
          json['pharmacyCount'];

      if (value is int) {
        return value;
      }

      if (value is num) {
        return value.toInt();
      }

      return int.tryParse(
        value?.toString() ?? '',
      );
    }

    return ProfileRegionModel(
      name: (
        json['name'] ??
        json['region_name'] ??
        json['regionName'] ??
        ''
      ).toString(),
      pharmaciesCount: readCount(),
    );
  }
}

class ProfileModel {
  final String fullName;

  final String representativeCode;

  final String phone;

  final String email;

  final String role;

  final String accountStatus;

  final String address;

  final List<ProfileRegionModel>
      linkedRegions;

  final List<String> permissions;

  final String? imageUrl;

  final Uint8List? imageBytes;

  const ProfileModel({
    required this.fullName,
    required this.representativeCode,
    required this.phone,
    required this.email,
    required this.role,
    required this.accountStatus,
    required this.address,
    required this.linkedRegions,
    required this.permissions,
    this.imageUrl,
    this.imageBytes,
  });

  factory ProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    String readString(
      List<String> keys, {
      String fallback = '',
    }) {
      for (final key in keys) {
        final dynamic value = json[key];

        if (value != null &&
            value
                .toString()
                .trim()
                .isNotEmpty) {
          return value.toString().trim();
        }
      }

      return fallback;
    }

    List<ProfileRegionModel>
        readRegions() {
      final dynamic raw =
          json['linked_regions'] ??
          json['linkedRegions'] ??
          json['regions'];

      if (raw is! List) {
        return const [];
      }

      return raw
          .whereType<Map>()
          .map(
            (item) =>
                ProfileRegionModel.fromJson(
              Map<String, dynamic>.from(
                item,
              ),
            ),
          )
          .where(
            (region) =>
                region.name
                    .trim()
                    .isNotEmpty,
          )
          .toList();
    }

    List<String> readPermissions() {
      final dynamic raw =
          json['permissions'] ??
          json['available_features'] ??
          json['availableFeatures'];

      if (raw is! List) {
        return const [];
      }

      return raw
          .map(
            (item) {
              if (item is Map) {
                return (
                  item['name'] ??
                  item['label'] ??
                  item['title'] ??
                  ''
                )
                    .toString()
                    .trim();
              }

              return item
                  .toString()
                  .trim();
            },
          )
          .where(
            (item) => item.isNotEmpty,
          )
          .toList();
    }

    final String image =
        readString(
      const [
        'image_url',
        'imageUrl',
        'avatar',
      ],
    );

    return ProfileModel(
      fullName: readString(
        const [
          'full_name',
          'fullName',
          'name',
        ],
      ),

      representativeCode:
          readString(
        const [
          'representative_code',
          'representativeCode',
          'code',
        ],
      ),

      phone: readString(
        const [
          'phone',
          'phone_number',
          'phoneNumber',
        ],
      ),

      email: readString(
        const [
          'email',
        ],
      ),

      role: readString(
        const [
          'role',
        ],
      ),

      accountStatus: readString(
        const [
          'account_status',
          'accountStatus',
          'status',
        ],
      ),

      address: readString(
        const [
          'address',
          'full_address',
          'fullAddress',
        ],
      ),

      linkedRegions:
          readRegions(),

      permissions:
          readPermissions(),

      imageUrl:
          image.isEmpty
              ? null
              : image,
    );
  }

  ProfileModel copyWith({
    String? phone,
    String? email,
    String? imageUrl,
    Uint8List? imageBytes,
  }) {
    return ProfileModel(
      fullName: fullName,

      representativeCode:
          representativeCode,

      phone:
          phone ?? this.phone,

      email:
          email ?? this.email,

      role: role,

      accountStatus:
          accountStatus,

      address: address,

      linkedRegions:
          linkedRegions,

      permissions:
          permissions,

      imageUrl:
          imageUrl ?? this.imageUrl,

      imageBytes:
          imageBytes ?? this.imageBytes,
    );
  }
}