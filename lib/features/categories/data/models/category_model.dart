import 'package:quiz_app/features/categories/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    super.imageUrl,
    super.color,
  });

  factory CategoryModel.fromMap( Map<String, Object?> map ) {
    return CategoryModel(
      id: map['id'] as int,
      name: map['name'] as String,
      imageUrl: map['image_url'] as String?,
      color: map['color'] as String?,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'color': color,
    };
  }
}