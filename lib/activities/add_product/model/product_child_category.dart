class ProductChildCategory {
  int? status;
  String? message;
  List<Data>? data;

  ProductChildCategory({this.status, this.message, this.data});

  ProductChildCategory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? parentId;
  String? name;
  String? thumbnail;
  String? status;
  String? businessTypeId;
  String? createdAt;
  String? updatedAt;
  String? thumbnailUrl;
  List<SubCategory>? subCategory;

  Data(
      {this.id,
      this.parentId,
      this.name,
      this.thumbnail,
      this.status,
      this.businessTypeId,
      this.createdAt,
      this.updatedAt,
      this.thumbnailUrl,
      this.subCategory});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    thumbnail = json['thumbnail'].toString();
    status = json['status'];
    businessTypeId = json['business_type_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    thumbnailUrl = json['thumbnail_url'];
    if (json['sub_category'] != null) {
      subCategory = <SubCategory>[];
      json['sub_category'].forEach((v) {
        subCategory!.add(new SubCategory.fromJson(v));
      });
    }
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
    if (this.subCategory != null) {
      data['sub_category'] = this.subCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategory {
  int? id;
  String? parentId;
  String? name;
  String? thumbnail;
  String? status;
  String? businessTypeId;
  String? createdAt;
  String? updatedAt;
  String? thumbnailUrl;

  SubCategory(
      {this.id,
      this.parentId,
      this.name,
      this.thumbnail,
      this.status,
      this.businessTypeId,
      this.createdAt,
      this.updatedAt,
      this.thumbnailUrl});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    thumbnail = json['thumbnail'].toString();
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
