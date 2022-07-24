import '../../home_page/model/HomeModel.dart';

class SubChildCategoryWithProductModel {
  int? status;
  String? message;
  List<ChildCategories>? childCategories;
  List<ProductData>? products;

  SubChildCategoryWithProductModel(
      {this.status, this.message, this.childCategories, this.products});

  SubChildCategoryWithProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['child_categories'] != null) {
      childCategories = <ChildCategories>[];
      json['child_categories'].forEach((v) {
        childCategories!.add(new ChildCategories.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = <ProductData>[];
      json['products'].forEach((v) {
        products!.add(new ProductData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.childCategories != null) {
      data['child_categories'] =
          this.childCategories!.map((v) => v.toJson()).toList();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChildCategories {
  int? id;
  String? parentId;
  String? name;
  String? thumbnail;
  String? status;
  String? businessTypeId;
  String? createdAt;
  String? updatedAt;
  String? thumbnailUrl;

  ChildCategories(
      {this.id,
      this.parentId,
      this.name,
      this.thumbnail,
      this.status,
      this.businessTypeId,
      this.createdAt,
      this.updatedAt,
      this.thumbnailUrl});

  ChildCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    thumbnail = json['thumbnail'];
    status = json['status'];
    businessTypeId = json['business_type_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    thumbnailUrl = json['thumbnail_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['name'] = this.name;
    data['thumbnail'] = this.thumbnail;
    data['status'] = this.status;
    data['business_type_id'] = this.businessTypeId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['thumbnail_url'] = this.thumbnailUrl;
    return data;
  }
}
