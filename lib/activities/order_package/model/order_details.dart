class OrderDetails {
  int? status;
  String? message;
  OrdersData? data;

  OrderDetails({this.status, this.message, this.data});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new OrdersData.fromJson(json['data']) : null;
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

class OrdersData {
  int? id;
  int? userId;
  int? vendorId;
  int? businessId;
  dynamic riderId;
  int? addressId;
  dynamic promoCode;
  String? tax;
  int? discount;
  String? subTotal;

  String? totalAmount;
  String? paymentType;
  String? orderNumber;
  String? orderDate;
  dynamic deliveryDate;
  String? deliveryCharge;
  String? paymentId;
  VendorJson? vendorJson;
  BusinessJson? businessJson;
  dynamic riderJson;
  dynamic riderAcceptTime;
  AddressJson? addressJson;
  String? status;
  String? declinedReason;
  dynamic reasonId;
  String? createdAt;
  String? updatedAt;
  String? liveStatus;
  dynamic cancelReason;
  VendorJson? user;
  String? picked_image;
  String? delivery_image;
  String? packed_image;
  String? cancel_by_user;
  String? cancel_description;
  List<Products>? products;
  CancelReason? cancel_reason;

  OrdersData(
      {this.id,
      this.userId,
      this.vendorId,
      this.businessId,
      this.riderId,
      this.addressId,
      this.promoCode,
      this.tax,
      this.discount,
      this.subTotal,
      this.totalAmount,
      this.paymentType,
      this.orderNumber,
      this.orderDate,
      this.deliveryDate,
      this.deliveryCharge,
      this.paymentId,
      this.vendorJson,
      this.businessJson,
      this.riderJson,
      this.riderAcceptTime,
      this.addressJson,
      this.status,
      this.declinedReason,
      this.reasonId,
      this.createdAt,
      this.updatedAt,
      this.liveStatus,
      this.cancelReason,
      this.user,
      this.picked_image,
      this.delivery_image,
      this.packed_image,
      this.cancel_by_user,
      this.cancel_description,
      this.cancel_reason,
      this.products});

  OrdersData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    businessId = json['business_id'];
    riderId = json['rider_id'];
    addressId = json['address_id'];
    promoCode = json['promo_code'];
    tax = json['tax'].toString();
    discount = json['discount'];
    subTotal = json['sub_total'].toString();
    totalAmount = json['total_amount'].toString();
    paymentType = json['payment_type'];
    orderNumber = json['order_number'];
    orderDate = json['order_date'];
    deliveryDate = json['delivery_date'];
    deliveryCharge = json['delivery_charge'];
    paymentId = json['payment_id'];
    vendorJson = json['vendor_json'] != null
        ? new VendorJson.fromJson(json['vendor_json'])
        : null;
    businessJson = json['business_json'] != null
        ? new BusinessJson.fromJson(json['business_json'])
        : null;
    riderJson = json['rider_json'];
    riderAcceptTime = json['rider_accept_time'];
    addressJson = json['address_json'] != null
        ? new AddressJson.fromJson(json['address_json'])
        : null;
    status = json['status'];
    declinedReason = json['declined_reason'].toString();
    reasonId = json['reason_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    liveStatus = json['live_status'];
    cancelReason = json['cancel_reason'];
    picked_image = json['picked_image'].toString();
    delivery_image = json['delivery_image'].toString();
    packed_image = json['packed_image'].toString();
    cancel_by_user = json['cancel_by_user'].toString();
    cancel_description = json['cancel_description'].toString();
    user = json['user'] != null ? new VendorJson.fromJson(json['user']) : null;
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    cancel_reason = json['cancel_reason'] != null
        ? new CancelReason.fromJson(json['cancel_reason'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['vendor_id'] = this.vendorId;
    data['business_id'] = this.businessId;
    data['rider_id'] = this.riderId;
    data['address_id'] = this.addressId;
    data['promo_code'] = this.promoCode;
    data['tax'] = this.tax;
    data['sub_total'] = subTotal;

    data['discount'] = this.discount;
    data['total_amount'] = this.totalAmount;
    data['payment_type'] = this.paymentType;
    data['order_number'] = this.orderNumber;
    data['order_date'] = this.orderDate;
    data['delivery_date'] = this.deliveryDate;
    data['delivery_charge'] = this.deliveryCharge;
    data['payment_id'] = this.paymentId;
    data['picked_image'] = picked_image;
    data['delivery_image'] = delivery_image;
    data['packed_image'] = packed_image;
    data['cancel_by_user'] = cancel_by_user;
    data['cancel_description'] = cancel_description;
    if (this.cancel_reason != null) {
      data['cancel_reason'] = this.cancel_reason!.toJson();
    }
    if (this.vendorJson != null) {
      data['vendor_json'] = this.vendorJson!.toJson();
    }
    if (this.businessJson != null) {
      data['business_json'] = this.businessJson!.toJson();
    }
    data['rider_json'] = this.riderJson;
    data['rider_accept_time'] = this.riderAcceptTime;
    if (this.addressJson != null) {
      data['address_json'] = this.addressJson!.toJson();
    }
    data['status'] = this.status;
    data['declined_reason'] = this.declinedReason;
    data['reason_id'] = this.reasonId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['live_status'] = this.liveStatus;
    data['cancel_reason'] = this.cancelReason;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CancelReason {
  int? id;
  String? text;
  String? createdAt;
  String? updatedAt;

  CancelReason({this.id, this.text, this.createdAt, this.updatedAt});

  CancelReason.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class VendorJson {
  int? id;
  String? profile;
  String? role;
  String? name;
  String? email;
  String? phone;
  dynamic emailVerifiedAt;
  dynamic phoneVerifiedAt;
  String? gender;
  dynamic referralCode;
  dynamic addressLine;
  dynamic address;
  String? longitude;
  String? latitude;
  dynamic province;
  dynamic city;
  dynamic postalCode;
  String? status;
  String? riderVerifyStatus;
  int? riderJobStatus;
  dynamic appVersion;
  dynamic deviceType;
  dynamic oneSignalId;
  String? createdAt;
  String? updatedAt;

  VendorJson(
      {this.id,
      this.profile,
      this.role,
      this.name,
      this.email,
      this.phone,
      this.emailVerifiedAt,
      this.phoneVerifiedAt,
      this.gender,
      this.referralCode,
      this.addressLine,
      this.address,
      this.longitude,
      this.latitude,
      this.province,
      this.city,
      this.postalCode,
      this.status,
      this.riderVerifyStatus,
      this.riderJobStatus,
      this.appVersion,
      this.deviceType,
      this.oneSignalId,
      this.createdAt,
      this.updatedAt});

  VendorJson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profile = json['profile'];
    role = json['role'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    emailVerifiedAt = json['email_verified_at'];
    phoneVerifiedAt = json['phone_verified_at'];
    gender = json['gender'];
    referralCode = json['referral_code'];
    addressLine = json['address_line'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    province = json['province'];
    city = json['city'];
    postalCode = json['postal_code'];
    status = json['status'];
    riderVerifyStatus = json['rider_verify_status'];
    riderJobStatus = json['rider_job_status'];
    appVersion = json['app_version'];
    deviceType = json['device_type'];
    oneSignalId = json['one_signal_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profile'] = this.profile;
    data['role'] = this.role;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['phone_verified_at'] = this.phoneVerifiedAt;
    data['gender'] = this.gender;
    data['referral_code'] = this.referralCode;
    data['address_line'] = this.addressLine;
    data['address'] = this.address;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['province'] = this.province;
    data['city'] = this.city;
    data['postal_code'] = this.postalCode;
    data['status'] = this.status;
    data['rider_verify_status'] = this.riderVerifyStatus;
    data['rider_job_status'] = this.riderJobStatus;
    data['app_version'] = this.appVersion;
    data['device_type'] = this.deviceType;
    data['one_signal_id'] = this.oneSignalId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class BusinessJson {
  int? id;
  int? vendorId;
  String? name;
  String? type;
  String? address;
  String? phone;
  String? website;
  String? addressLine;
  String? latitude;
  String? longitude;
  String? isVerified;
  TypeDetail? typeDetail;
  ImageModel? image;

  BusinessJson(
      {this.id,
      this.vendorId,
      this.name,
      this.type,
      this.address,
      this.phone,
      this.website,
      this.addressLine,
      this.latitude,
      this.longitude,
      this.isVerified,
      this.typeDetail,
      this.image});

  BusinessJson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    name = json['name'];
    type = json['type'];
    address = json['address'];
    phone = json['phone'];
    website = json['website'];
    addressLine = json['address_line'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isVerified = json['is_verified'];
    typeDetail = json['type_detail'] != null
        ? new TypeDetail.fromJson(json['type_detail'])
        : null;
    image =
        json['image'] != null ? new ImageModel.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['website'] = this.website;
    data['address_line'] = this.addressLine;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['is_verified'] = this.isVerified;
    if (this.typeDetail != null) {
      data['type_detail'] = this.typeDetail!.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    return data;
  }
}

class TypeDetail {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  TypeDetail({this.id, this.name, this.createdAt, this.updatedAt});

  TypeDetail.fromJson(Map<String, dynamic> json) {
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

class ImageModel {
  int? id;
  int? vendorId;
  String? status;
  String? name;
  String? number;
  int? businessId;
  String? image;
  String? rejectReason;
  String? createdAt;
  String? updatedAt;

  ImageModel(
      {this.id,
      this.vendorId,
      this.status,
      this.name,
      this.number,
      this.businessId,
      this.image,
      this.rejectReason,
      this.createdAt,
      this.updatedAt});

  ImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    status = json['status'];
    name = json['name'];
    number = json['number'];
    businessId = json['business_id'];
    image = json['image'];
    rejectReason = json['reject_reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['status'] = this.status;
    data['name'] = this.name;
    data['number'] = this.number;
    data['business_id'] = this.businessId;
    data['image'] = this.image;
    data['reject_reason'] = this.rejectReason;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class AddressJson {
  int? id;
  int? userId;
  String? title;
  String? addressLine;
  String? longitude;
  String? latitude;
  String? province;
  String? city;
  String? postalCode;
  int? primary;
  String? createdAt;
  String? updatedAt;

  AddressJson(
      {this.id,
      this.userId,
      this.title,
      this.addressLine,
      this.longitude,
      this.latitude,
      this.province,
      this.city,
      this.postalCode,
      this.primary,
      this.createdAt,
      this.updatedAt});

  AddressJson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    addressLine = json['address_line'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    province = json['province'];
    city = json['city'];
    postalCode = json['postal_code'];
    primary = json['primary'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['address_line'] = this.addressLine;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['province'] = this.province;
    data['city'] = this.city;
    data['postal_code'] = this.postalCode;
    data['primary'] = this.primary;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Products {
  int? id;
  int? orderId;
  int? productId;
  int? variationId;
  int? amount;
  dynamic promoCode;
  dynamic discount;
  dynamic tax;
  int? quantity;
  ProductJson? productJson;
  VariationJson? variationJson;
  String? createdAt;
  String? updatedAt;

  Products(
      {this.id,
      this.orderId,
      this.productId,
      this.variationId,
      this.amount,
      this.promoCode,
      this.discount,
      this.tax,
      this.quantity,
      this.productJson,
      this.variationJson,
      this.createdAt,
      this.updatedAt});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    variationId = json['variation_id'];
    amount = json['amount'];
    promoCode = json['promo_code'];
    discount = json['discount'];
    tax = json['tax'];
    quantity = json['quantity'];
    productJson = json['product_json'] != null
        ? new ProductJson.fromJson(json['product_json'])
        : null;
    variationJson = json['variation_json'] != null
        ? new VariationJson.fromJson(json['variation_json'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['variation_id'] = this.variationId;
    data['amount'] = this.amount;
    data['promo_code'] = this.promoCode;
    data['discount'] = this.discount;
    data['tax'] = this.tax;
    data['quantity'] = this.quantity;
    if (this.productJson != null) {
      data['product_json'] = this.productJson!.toJson();
    }
    if (this.variationJson != null) {
      data['variation_json'] = this.variationJson!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ProductJson {
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
  dynamic fullDescription;
  String? images;
  String? defaultImage;
  String? inStock;
  String? cashOnDelivery;
  String? warranty;
  String? warrantyMonth;
  String? warrantyType;
  String? refundable;
  String? refendDay;
  String? attributeIds;
  String? createdAt;
  String? updatedAt;
  String? image;

  ProductJson(
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
      this.defaultImage,
      this.inStock,
      this.cashOnDelivery,
      this.warranty,
      this.warrantyMonth,
      this.warrantyType,
      this.refundable,
      this.refendDay,
      this.attributeIds,
      this.createdAt,
      this.updatedAt,
      this.image});

  ProductJson.fromJson(Map<String, dynamic> json) {
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
    defaultImage = json['default_image'];
    inStock = json['in_stock'];
    cashOnDelivery = json['cash_on_delivery'];
    warranty = json['warranty'];
    warrantyMonth = json['warranty_month'];
    warrantyType = json['warranty_type'];
    refundable = json['refundable'];
    refendDay = json['refend_day'];
    attributeIds = json['attribute_ids'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
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
    data['default_image'] = this.defaultImage;
    data['in_stock'] = this.inStock;
    data['cash_on_delivery'] = this.cashOnDelivery;
    data['warranty'] = this.warranty;
    data['warranty_month'] = this.warrantyMonth;
    data['warranty_type'] = this.warrantyType;
    data['refundable'] = this.refundable;
    data['refend_day'] = this.refendDay;
    data['attribute_ids'] = this.attributeIds;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    return data;
  }
}

class VariationJson {
  int? id;
  int? productId;
  int? basicPrice;
  int? offerPrice;
  int? quantity;
  String? status;
  String? rejectReason;
  String? images;
  dynamic defaultVariationImage;
  String? createdAt;
  String? updatedAt;

  VariationJson(
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
      this.updatedAt});

  VariationJson.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
