
//! CategoryModel
class CategoryModel {
  final int? id;
  final String? name;
  final String? imageUrl;
  final int? businessId;
  final String? shortCode;
  final int? parentId;
  final int? createdBy;
  final int? woocommerceCatId;
  final String? categoryType;
  final String? description;
  final String? slug;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final List<CategoryModel>? subCategories;

  CategoryModel({
    this.id,
    this.name,
    this.businessId,
    this.imageUrl,
    this.shortCode,
    this.parentId,
    this.createdBy,
    this.woocommerceCatId,
    this.categoryType,
    this.description,
    this.slug,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.subCategories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      imageUrl: json['image'] as String?,
      businessId: json['business_id'] as int?,
      shortCode: json['short_code'] as String?,
      parentId: json['parent_id'] as int?,
      createdBy: json['created_by'] as int?,
      woocommerceCatId: json['woocommerce_cat_id'] as int?,
      categoryType: json['category_type'] as String?,
      description: json['description'] as String?,
      slug: json['slug'] as String?,
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      subCategories: (json['sub_categories'] as List<dynamic>?)
          ?.map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'business_id': businessId,
      'short_code': shortCode,
      'parent_id': parentId,
      'created_by': createdBy,
      'woocommerce_cat_id': woocommerceCatId,
      'category_type': categoryType,
      'description': description,
      'slug': slug,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'sub_categories': subCategories?.map((x) => x.toJson()).toList(),
    };
  }
}
