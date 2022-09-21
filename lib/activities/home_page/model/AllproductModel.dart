import 'package:market_vendor_app/activities/home_page/model/HomeModel.dart';

class AllprodcutModel {
  int? status;
  String? message;
  Data? data;

  AllprodcutModel({this.status, this.message, this.data});

  AllprodcutModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? currentPage;
  List<ProductData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Data(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        data!.add(new ProductData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'].toString();
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'].toString();
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Category {
  int? id;
  dynamic parentId;
  String? name;
  String? thumbnail;
  String? status;
  String? businessTypeId;
  String? createdAt;
  String? updatedAt;
  String? thumbnailUrl;

  Category(
      {this.id,
      this.parentId,
      this.name,
      this.thumbnail,
      this.status,
      this.businessTypeId,
      this.createdAt,
      this.updatedAt,
      this.thumbnailUrl});

  Category.fromJson(Map<String, dynamic> json) {
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

class Brand {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Brand({this.id, this.name, this.createdAt, this.updatedAt});

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Specification {
  int? id;
  int? productId;
  String? name;
  String? value;
  int? forFilter;
  String? createdAt;
  String? updatedAt;

  Specification(
      {this.id,
      this.productId,
      this.name,
      this.value,
      this.forFilter,
      this.createdAt,
      this.updatedAt});

  Specification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    name = json['name'];
    value = json['value'];
    forFilter = json['for_filter'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['value'] = this.value;
    data['for_filter'] = this.forFilter;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Variations {
  int? id;
  int? productId;
  int? basicPrice;
  int? offerPrice;
  int? quantity;
  String? status;
  String? rejectReason;
  String? images;
  String? defaultVariationImage;
  String? createdAt;
  String? updatedAt;
  String? defaultVImage;
  List<Attribute>? attribute;

  Variations(
      {this.id,
      this.productId,
      this.basicPrice,
      this.offerPrice,
      this.quantity,
      this.status,
      this.rejectReason,
      this.images,
      this.defaultVariationImage,
      this.createdAt,
      this.updatedAt,
      this.defaultVImage,
      this.attribute});

  Variations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    basicPrice = json['basic_price'];
    offerPrice = json['offer_price'];
    quantity = json['quantity'];
    status = json['status'];
    rejectReason = json['reject_reason'];
    images = json['images'];
    defaultVariationImage = json['default_variation_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    defaultVImage = json['default_v_image'];
    if (json['attribute'] != null) {
      attribute = <Attribute>[];
      json['attribute'].forEach((v) {
        attribute!.add(new Attribute.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['basic_price'] = this.basicPrice;
    data['offer_price'] = this.offerPrice;
    data['quantity'] = this.quantity;
    data['status'] = this.status;
    data['reject_reason'] = this.rejectReason;
    data['images'] = this.images;
    data['default_variation_image'] = this.defaultVariationImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['default_v_image'] = this.defaultVImage;
    if (this.attribute != null) {
      data['attribute'] = this.attribute!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attribute {
  int? id;
  int? productVariationId;
  int? attributeId;
  String? attributeValue;
  int? unitId;
  int? productId;
  String? createdAt;
  String? updatedAt;
  Unit? unit;
  Brand? attributeName;

  Attribute(
      {this.id,
      this.productVariationId,
      this.attributeId,
      this.attributeValue,
      this.unitId,
      this.productId,
      this.createdAt,
      this.updatedAt,
      this.unit,
      this.attributeName});

  Attribute.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productVariationId = json['product_variation_id'];
    attributeId = json['attribute_id'];
    attributeValue = json['attribute_value'];
    unitId = json['unit_id'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    unit = json['unit'] != null ? new Unit.fromJson(json['unit']) : null;
    attributeName = json['attribute_name'] != null
        ? new Brand.fromJson(json['attribute_name'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_variation_id'] = this.productVariationId;
    data['attribute_id'] = this.attributeId;
    data['attribute_value'] = this.attributeValue;
    data['unit_id'] = this.unitId;
    data['product_id'] = this.productId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.unit != null) {
      data['unit'] = this.unit!.toJson();
    }
    if (this.attributeName != null) {
      data['attribute_name'] = this.attributeName!.toJson();
    }
    return data;
  }
}

class Unit {
  int? id;
  int? attributeId;
  String? name;
  String? value;
  String? createdAt;
  String? updatedAt;

  Unit(
      {this.id,
      this.attributeId,
      this.name,
      this.value,
      this.createdAt,
      this.updatedAt});

  Unit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributeId = json['attribute_id'];
    name = json['name'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['attribute_id'] = this.attributeId;
    data['name'] = this.name;
    data['value'] = this.value;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
