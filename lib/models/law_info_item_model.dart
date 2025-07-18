import 'package:equatable/equatable.dart';
import 'category_model.dart';

class LawInfoItemModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final String? moreDescription;
  final String? image;
  final String slug;
  final int categoryId;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CategoryModel? category;

  const LawInfoItemModel({
    required this.id,
    required this.name,
    required this.description,
    this.moreDescription,
    this.image,
    required this.slug,
    required this.categoryId,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.category,
  });

  factory LawInfoItemModel.fromJson(Map<String, dynamic> json) {
    return LawInfoItemModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      moreDescription: json['more_description'] as String?,
      image: json['image'] as String?,
      slug: json['slug'] as String,
      categoryId: json['category_id'] as int,
      isActive: json['is_active'] as bool,
      sortOrder: json['sort_order'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      category:
          json['category'] != null
              ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'more_description': moreDescription,
      'image': image,
      'slug': slug,
      'category_id': categoryId,
      'is_active': isActive,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'category': category?.toJson(),
    };
  }

  LawInfoItemModel copyWith({
    int? id,
    String? name,
    String? description,
    String? moreDescription,
    String? image,
    String? slug,
    int? categoryId,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    CategoryModel? category,
  }) {
    return LawInfoItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      moreDescription: moreDescription ?? this.moreDescription,
      image: image ?? this.image,
      slug: slug ?? this.slug,
      categoryId: categoryId ?? this.categoryId,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    moreDescription,
    image,
    slug,
    categoryId,
    isActive,
    sortOrder,
    createdAt,
    updatedAt,
    category,
  ];
}
