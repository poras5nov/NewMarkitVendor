import 'package:market_vendor_app/activities/home_page/model/HomeModel.dart';

class AllprodcutModel {
  int? status;
  String? message;
  List<ProductData>? data;

  AllprodcutModel({this.status, this.message, this.data});

  AllprodcutModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        data!.add(new ProductData.fromJson(v));
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
  int? vendorId;
  int? categoryId;
  int? subCategoryId;
  int? childCategoryId;
  String? isPopular;
  String? isTaxable;
  String? hsnNo;
  String? taxValue;
  String? sameSayDelivery;
  String? deliveryDay;
  int? brandId;
  String? name;
  String? description;
  Null? fullDescription;
  String? images;
  String? inStock;
  String? attributeIds;
  String? createdAt;
  String? updatedAt;
  String? image;
  List<Variations>? variations;
  Category? category;
  AttributeName? brand;
  List<Specification>? specification;

  Data(
      {this.id,
      this.vendorId,
      this.categoryId,
      this.subCategoryId,
      this.childCategoryId,
      this.isPopular,
      this.isTaxable,
      this.hsnNo,
      this.taxValue,
      this.sameSayDelivery,
      this.deliveryDay,
      this.brandId,
      this.name,
      this.description,
      this.fullDescription,
      this.images,
      this.inStock,
      this.attributeIds,
      this.createdAt,
      this.updatedAt,
      this.image,
      this.variations,
      this.category,
      this.brand,
      this.specification});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    childCategoryId = json['child_category_id'];
    isPopular = json['is_popular'];
    isTaxable = json['is_taxable'];
    hsnNo = json['hsn_no'];
    taxValue = json['tax_value'];
    sameSayDelivery = json['same_say_delivery'];
    deliveryDay = json['delivery_day'];
    brandId = json['brand_id'];
    name = json['name'];
    description = json['description'];
    fullDescription = json['full_description'];
    images = json['images'];
    inStock = json['in_stock'];
    attributeIds = json['attribute_ids'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    if (json['variations'] != null) {
      variations = <Variations>[];
      json['variations'].forEach((v) {
        variations!.add(new Variations.fromJson(v));
      });
    }
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    brand = json['brand'] != null
        ? new AttributeName.fromJson(json['brand'])
        : null;
    if (json['specification'] != null) {
      specification = <Specification>[];
      json['specification'].forEach((v) {
        specification!.add(new Specification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['child_category_id'] = this.childCategoryId;
    data['is_popular'] = this.isPopular;
    data['is_taxable'] = this.isTaxable;
    data['hsn_no'] = this.hsnNo;
    data['tax_value'] = this.taxValue;
    data['same_say_delivery'] = this.sameSayDelivery;
    data['delivery_day'] = this.deliveryDay;
    data['brand_id'] = this.brandId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['full_description'] = this.fullDescription;
    data['images'] = this.images;
    data['in_stock'] = this.inStock;
    data['attribute_ids'] = this.attributeIds;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    if (this.variations != null) {
      data['variations'] = this.variations!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.brand != null) {
      data['brand'] = this.brand!.toJson();
    }
    if (this.specification != null) {
      data['specification'] =
          this.specification!.map((v) => v.toJson()).toList();
    }
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
  Null? rejectReason;
  String? images;
  String? createdAt;
  String? updatedAt;
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
      this.createdAt,
      this.updatedAt,
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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
  int? productId;
  String? createdAt;
  String? updatedAt;
  AttributeName? attributeName;

  Attribute(
      {this.id,
      this.productVariationId,
      this.attributeId,
      this.attributeValue,
      this.productId,
      this.createdAt,
      this.updatedAt,
      this.attributeName});

  Attribute.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productVariationId = json['product_variation_id'];
    attributeId = json['attribute_id'];
    attributeValue = json['attribute_value'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    attributeName = json['attribute_name'] != null
        ? new AttributeName.fromJson(json['attribute_name'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_variation_id'] = this.productVariationId;
    data['attribute_id'] = this.attributeId;
    data['attribute_value'] = this.attributeValue;
    data['product_id'] = this.productId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.attributeName != null) {
      data['attribute_name'] = this.attributeName!.toJson();
    }
    return data;
  }
}

class AttributeName {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  AttributeName({this.id, this.name, this.createdAt, this.updatedAt});

  AttributeName.fromJson(Map<String, dynamic> json) {
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

class Category {
  int? id;
  Null? parentId;
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
