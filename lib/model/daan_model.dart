

class DaanModel {
  final int id;
  final String name;
  final String slug;
  final String purpose;
  final String productImage;
  final int amount;
  final int productCategoryId;
  final String description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int createdBy;

  DaanModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.purpose,
    required this.productImage,
    required this.amount,
    required this.productCategoryId,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  // Deserialize from JSON
  factory DaanModel.fromJson(Map<String, dynamic> json) {
    return DaanModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      purpose: json['purpose'],
      productImage: json['productImage'],
      amount: json['amount'],
      productCategoryId: json['productCategoryId'],
      description: json['description'],
      isActive: json['isActive'] == 1, // Convert 1 to true
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      createdBy: json['createdBy'],
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'purpose': purpose,
      'productImage': productImage,
      'amount': amount,
      'productCategoryId': productCategoryId,
      'description': description,
      'isActive': isActive ? 1 : 0, // Convert true to 1
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'createdBy': createdBy,
    };
  }
}
