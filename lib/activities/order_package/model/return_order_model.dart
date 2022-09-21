class RetrunOrderModel {
  int? status;
  String? message;
  ReturnData? data;

  RetrunOrderModel({this.status, this.message, this.data});

  RetrunOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new ReturnData.fromJson(json['data']) : null;
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

class ReturnData {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  ReturnData(
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

  ReturnData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
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

class Data {
  int? id;
  int? userId;
  int? vendorId;
  int? businessId;
  dynamic riderId;
  int? addressId;
  dynamic promoCode;
  int? tax;
  String? sgst;
  String? cgst;
  String? igst;
  int? discount;
  String? totalAmount;
  String? paymentType;
  String? orderNumber;
  String? orderDate;
  dynamic deliveryDate;
  String? deliveryCharge;
  dynamic paymentId;
  VendorJson? vendorJson;
  BusinessJson? businessJson;
  dynamic riderJson;
  dynamic riderAcceptTime;
  AddressJson? addressJson;
  String? status;
  String? paymentStatus;
  dynamic declinedReason;
  dynamic reasonId;
  String? createdAt;
  String? updatedAt;
  String? liveStatus;
  String? pickedImage;
  String? deliveryImage;
  String? packedImage;
  VendorJson? user;
  ReturnRequest? returnRequest;

  Data(
      {this.id,
      this.userId,
      this.vendorId,
      this.businessId,
      this.riderId,
      this.addressId,
      this.promoCode,
      this.tax,
      this.sgst,
      this.cgst,
      this.igst,
      this.discount,
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
      this.paymentStatus,
      this.declinedReason,
      this.reasonId,
      this.createdAt,
      this.updatedAt,
      this.liveStatus,
      this.pickedImage,
      this.deliveryImage,
      this.packedImage,
      this.user,
      this.returnRequest});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    businessId = json['business_id'];
    riderId = json['rider_id'];
    addressId = json['address_id'];
    promoCode = json['promo_code'];
    tax = json['tax'];
    sgst = json['sgst'];
    cgst = json['cgst'];
    igst = json['igst'];
    discount = json['discount'];
    totalAmount = json['total_amount'];
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
    paymentStatus = json['payment_status'];
    declinedReason = json['declined_reason'];
    reasonId = json['reason_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    liveStatus = json['live_status'];
    pickedImage = json['picked_image'];
    deliveryImage = json['delivery_image'];
    packedImage = json['packed_image'];
    user = json['user'] != null ? new VendorJson.fromJson(json['user']) : null;
    returnRequest = json['return_request'] != null
        ? new ReturnRequest.fromJson(json['return_request'])
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
    data['sgst'] = this.sgst;
    data['cgst'] = this.cgst;
    data['igst'] = this.igst;
    data['discount'] = this.discount;
    data['total_amount'] = this.totalAmount;
    data['payment_type'] = this.paymentType;
    data['order_number'] = this.orderNumber;
    data['order_date'] = this.orderDate;
    data['delivery_date'] = this.deliveryDate;
    data['delivery_charge'] = this.deliveryCharge;
    data['payment_id'] = this.paymentId;
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
    data['payment_status'] = this.paymentStatus;
    data['declined_reason'] = this.declinedReason;
    data['reason_id'] = this.reasonId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['live_status'] = this.liveStatus;
    data['picked_image'] = this.pickedImage;
    data['delivery_image'] = this.deliveryImage;
    data['packed_image'] = this.packedImage;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.returnRequest != null) {
      data['return_request'] = this.returnRequest!.toJson();
    }
    return data;
  }
}

class VendorJson {
  int? id;
  dynamic code;
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
      this.code,
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
    code = json['code'];
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
    data['code'] = this.code;
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
  String? categoryId;
  dynamic storeImages;
  String? address;
  String? state;
  String? city;
  String? postalCode;
  String? phone;
  String? website;
  String? bussinessEmail;
  String? addressLine;
  String? pickupState;
  String? pickupCity;
  String? pickupPostalCode;
  String? panNumber;
  String? gstNumber;
  String? aadhaarNumber;
  String? policeClearanceCertificate;
  String? cancelledChequeNumber;
  String? cancelledChequeImage;
  String? panImage;
  String? aadhaarImage;
  String? policeClearanceImage;
  String? gstImage;
  String? latitude;
  String? longitude;
  String? isVerified;
  String? open;
  String? bankAccount;
  String? bankName;
  String? ifscCode;
  String? accountHolderName;
  String? sharedDelivery;
  String? freeDelivery;
  dynamic signatureImage;
  String? createdAt;
  String? updatedAt;
  TypeDetail? typeDetail;
  Image? image;

  BusinessJson(
      {this.id,
      this.vendorId,
      this.name,
      this.type,
      this.categoryId,
      this.storeImages,
      this.address,
      this.state,
      this.city,
      this.postalCode,
      this.phone,
      this.website,
      this.bussinessEmail,
      this.addressLine,
      this.pickupState,
      this.pickupCity,
      this.pickupPostalCode,
      this.panNumber,
      this.gstNumber,
      this.aadhaarNumber,
      this.policeClearanceCertificate,
      this.cancelledChequeNumber,
      this.cancelledChequeImage,
      this.panImage,
      this.aadhaarImage,
      this.policeClearanceImage,
      this.gstImage,
      this.latitude,
      this.longitude,
      this.isVerified,
      this.open,
      this.bankAccount,
      this.bankName,
      this.ifscCode,
      this.accountHolderName,
      this.sharedDelivery,
      this.freeDelivery,
      this.signatureImage,
      this.createdAt,
      this.updatedAt,
      this.typeDetail,
      this.image});

  BusinessJson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    name = json['name'];
    type = json['type'];
    categoryId = json['category_id'];
    storeImages = json['store_images'];
    address = json['address'];
    state = json['state'];
    city = json['city'];
    postalCode = json['postal_code'];
    phone = json['phone'];
    website = json['website'];
    bussinessEmail = json['bussiness_email'];
    addressLine = json['address_line'];
    pickupState = json['pickup_state'];
    pickupCity = json['pickup_city'];
    pickupPostalCode = json['pickup_postal_code'];
    panNumber = json['pan_number'];
    gstNumber = json['gst_number'];
    aadhaarNumber = json['aadhaar_number'];
    policeClearanceCertificate = json['police_Clearance_Certificate'];
    cancelledChequeNumber = json['cancelled_cheque_number'];
    cancelledChequeImage = json['cancelled_cheque_image'];
    panImage = json['pan_image'];
    aadhaarImage = json['aadhaar_image'];
    policeClearanceImage = json['police_Clearance_image'];
    gstImage = json['gst_image'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isVerified = json['is_verified'];
    open = json['open'];
    bankAccount = json['bank_account'];
    bankName = json['bank_name'];
    ifscCode = json['ifsc_code'];
    accountHolderName = json['account_holder_name'];
    sharedDelivery = json['shared_delivery'];
    freeDelivery = json['free_delivery'];
    signatureImage = json['signature_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    typeDetail = json['type_detail'] != null
        ? new TypeDetail.fromJson(json['type_detail'])
        : null;
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['category_id'] = this.categoryId;
    data['store_images'] = this.storeImages;
    data['address'] = this.address;
    data['state'] = this.state;
    data['city'] = this.city;
    data['postal_code'] = this.postalCode;
    data['phone'] = this.phone;
    data['website'] = this.website;
    data['bussiness_email'] = this.bussinessEmail;
    data['address_line'] = this.addressLine;
    data['pickup_state'] = this.pickupState;
    data['pickup_city'] = this.pickupCity;
    data['pickup_postal_code'] = this.pickupPostalCode;
    data['pan_number'] = this.panNumber;
    data['gst_number'] = this.gstNumber;
    data['aadhaar_number'] = this.aadhaarNumber;
    data['police_Clearance_Certificate'] = this.policeClearanceCertificate;
    data['cancelled_cheque_number'] = this.cancelledChequeNumber;
    data['cancelled_cheque_image'] = this.cancelledChequeImage;
    data['pan_image'] = this.panImage;
    data['aadhaar_image'] = this.aadhaarImage;
    data['police_Clearance_image'] = this.policeClearanceImage;
    data['gst_image'] = this.gstImage;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['is_verified'] = this.isVerified;
    data['open'] = this.open;
    data['bank_account'] = this.bankAccount;
    data['bank_name'] = this.bankName;
    data['ifsc_code'] = this.ifscCode;
    data['account_holder_name'] = this.accountHolderName;
    data['shared_delivery'] = this.sharedDelivery;
    data['free_delivery'] = this.freeDelivery;
    data['signature_image'] = this.signatureImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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

class Image {
  int? id;
  int? vendorId;
  String? status;
  String? name;
  String? number;
  int? businessId;
  String? image;
  dynamic rejectReason;
  String? createdAt;
  String? updatedAt;

  Image(
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

  Image.fromJson(Map<String, dynamic> json) {
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

class ReturnRequest {
  int? id;
  int? orderId;
  String? requestType;
  String? status;
  String? reason;
  String? createdAt;
  String? updatedAt;
  List<ReturnProducts>? returnProducts;

  ReturnRequest(
      {this.id,
      this.orderId,
      this.requestType,
      this.status,
      this.reason,
      this.createdAt,
      this.updatedAt,
      this.returnProducts});

  ReturnRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    requestType = json['request_type'];
    status = json['status'];
    reason = json['reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['return_products'] != null) {
      returnProducts = <ReturnProducts>[];
      json['return_products'].forEach((v) {
        returnProducts!.add(new ReturnProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['request_type'] = this.requestType;
    data['status'] = this.status;
    data['reason'] = this.reason;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.returnProducts != null) {
      data['return_products'] =
          this.returnProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReturnProducts {
  int? id;
  int? orderId;
  int? orderProductId;
  int? requestId;
  int? productId;
  int? variationId;
  String? status;
  String? type;
  int? amount;
  dynamic promoCode;
  dynamic discount;
  dynamic tax;
  int? quantity;
  ProductJson? productJson;
  VariationJson? variationJson;
  String? returnReason;
  String? createdAt;
  String? updatedAt;

  ReturnProducts(
      {this.id,
      this.orderId,
      this.orderProductId,
      this.requestId,
      this.productId,
      this.variationId,
      this.status,
      this.type,
      this.amount,
      this.promoCode,
      this.discount,
      this.tax,
      this.quantity,
      this.productJson,
      this.variationJson,
      this.returnReason,
      this.createdAt,
      this.updatedAt});

  ReturnProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    orderProductId = json['order_product_id'];
    requestId = json['request_id'];
    productId = json['product_id'];
    variationId = json['variation_id'];
    status = json['status'];
    type = json['type'];
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
    returnReason = json['return_reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['order_product_id'] = this.orderProductId;
    data['request_id'] = this.requestId;
    data['product_id'] = this.productId;
    data['variation_id'] = this.variationId;
    data['status'] = this.status;
    data['type'] = this.type;
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
    data['return_reason'] = this.returnReason;
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
  dynamic hsnNo;
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
  dynamic warrantyMonth;
  String? warrantyType;
  String? refundable;
  dynamic refendDay;
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
  dynamic rejectReason;
  String? images;
  String? defaultVariationImage;
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
