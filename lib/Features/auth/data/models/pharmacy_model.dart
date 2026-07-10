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
      id: json["id"],
      name: json["name"]?.toString() ?? "",
      branch: json["branch"]?.toString() ?? "",
      area: json["area"]?.toString() ?? "",
      address: json["address"]?.toString() ?? "",
      dueAmount: double.tryParse(
            (json["dueAmount"] ?? json["due_amount"] ?? 0).toString(),
          ) ??
          0,
      image: json["image"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "branch": branch,
      "area": area,
      "address": address,
      "dueAmount": dueAmount,
      "image": image,
    };
  }
}