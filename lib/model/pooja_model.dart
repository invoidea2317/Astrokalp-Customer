class PoojaModel {
  final int id;
  final String name; // Non-nullable with default ''
  final String slug; // Non-nullable with default ''
  final String features; // Non-nullable with default ''
  final String purpose; // Non-nullable with default ''
  final String pujaDate; // Non-nullable with default ''
  final int astroId;
  final String productImage; // Non-nullable with default ''
  final int productCategoryId;
  final int amount;
  final String? description; // Nullable
  final int isActive;
  final String createdAt; // Non-nullable with default ''
  final String updatedAt; // Non-nullable with default ''
  final int createdBy;

  PoojaModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.features,
    required this.purpose,
    required this.pujaDate,
    required this.astroId,
    required this.productImage,
    required this.productCategoryId,
    required this.amount,
    this.description, // Allow null
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  factory PoojaModel.fromJson(Map<String, dynamic> json) {
    return PoojaModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '', // Default empty string
      slug: json['slug'] ?? '', // Default empty string
      features: json['features'] ?? '', // Default empty string
      purpose: json['purpose'] ?? '', // Default empty string
      pujaDate: json['puja_date'] ?? '', // Default empty string
      astroId: json['astro_id'] ?? 0,
      productImage: json['productImage'] ?? '', // Default empty string
      productCategoryId: json['productCategoryId'] ?? 0,
      amount: json['amount'] ?? 0,
      description: json['description'], // Allow null
      isActive: json['isActive'] ?? 0,
      createdAt: json['created_at'] ?? '', // Default empty string
      updatedAt: json['updated_at'] ?? '', // Default empty string
      createdBy: json['createdBy'] ?? 0,
    );
  }
}
