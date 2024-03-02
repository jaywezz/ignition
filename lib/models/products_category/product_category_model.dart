import 'package:hive_flutter/hive_flutter.dart';
part 'product_category_model.g.dart';

class ProductCategory {
  ProductCategory({
    required success,
    required message,
    required productCategories,
  }) {
    _message = message;
    _success = success;
    _productCategories = productCategories;
  }

  bool? _success;
  String? _message;
  late List<ProductCategoryModel> _productCategories;
  List<ProductCategoryModel> get productCategories => _productCategories;

  ProductCategory.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    if (json['data'] != null) {
      _productCategories = <ProductCategoryModel>[];
      json['data'].forEach((v) {
        _productCategories.add(ProductCategoryModel.fromJson(v));
      });
    }
  }
}

@HiveType(typeId: 2)
class ProductCategoryModel {
  ProductCategoryModel({
    this.id,
    this.name,
    this.parentId,
    this.url,
    this.businessCode,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? parentId;
  @HiveField(3)
  String? url;
  @HiveField(4)
  String? businessCode;
  @HiveField(5)
  int? createdBy;
  @HiveField(6)
  int? updatedBy;
  @HiveField(7)
  String? createdAt;
  @HiveField(8)
  String? updatedAt;

  ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    url = json['url'];
    businessCode = json['business_code'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent_id'] = parentId;
    data['url'] = url;
    data['business_code'] = businessCode;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
