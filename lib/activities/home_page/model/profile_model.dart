class ProfileModel {
  int? status;
  String? message;
  Data? data;
  String? token;

  ProfileModel({this.status, this.message, this.data, this.token});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class Data {
  int? id;
  String? profile;
  String? role;
  String? name;
  String? email;
  String? phone;
  Null? emailVerifiedAt;
  Null? phoneVerifiedAt;
  String? gender;
  Null? referralCode;
  Null? addressLine;
  Null? address;
  String? longitude;
  String? latitude;
  Null? province;
  Null? city;
  Null? postalCode;
  String? status;
  String? riderVerifyStatus;
  int? riderJobStatus;
  Null? appVersion;
  Null? deviceType;
  Null? oneSignalId;
  String? createdAt;
  String? updatedAt;
  int? businessesCount;
  Businesses? businesses;
  List<Documents>? documents;

  Data(
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
      this.updatedAt,
      this.businessesCount,
      this.businesses,
      this.documents});

  Data.fromJson(Map<String, dynamic> json) {
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
    businessesCount = json['businesses_count'];
    businesses = json['businesses'] != null
        ? new Businesses.fromJson(json['businesses'])
        : null;
    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(new Documents.fromJson(v));
      });
    }
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
    data['businesses_count'] = this.businessesCount;
    if (this.businesses != null) {
      data['businesses'] = this.businesses!.toJson();
    }
    if (this.documents != null) {
      data['documents'] = this.documents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Businesses {
  int? id;
  int? vendorId;
  String? name;
  String? type;
  String? categoryId;
  String? storeImages;
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
  // Null? policeClearanceCertificate;
  String? cancelledChequeNumber;
  String? cancelledChequeImage;
  String? panImage;
  String? aadhaarImage;
  // Null? policeClearanceImage;
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
  String? createdAt;
  String? updatedAt;

  Businesses(
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
      // this.policeClearanceCertificate,
      this.cancelledChequeNumber,
      this.cancelledChequeImage,
      this.panImage,
      this.aadhaarImage,
      // this.policeClearanceImage,
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
      this.createdAt,
      this.updatedAt});

  Businesses.fromJson(Map<String, dynamic> json) {
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
    //  policeClearanceCertificate = json['police_Clearance_Certificate'];
    cancelledChequeNumber = json['cancelled_cheque_number'];
    cancelledChequeImage = json['cancelled_cheque_image'];
    panImage = json['pan_image'];
    aadhaarImage = json['aadhaar_image'];
    // policeClearanceImage = json['police_Clearance_image'];
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    // data['police_Clearance_Certificate'] = this.policeClearanceCertificate;
    data['cancelled_cheque_number'] = this.cancelledChequeNumber;
    data['cancelled_cheque_image'] = this.cancelledChequeImage;
    data['pan_image'] = this.panImage;
    data['aadhaar_image'] = this.aadhaarImage;
    //  data['police_Clearance_image'] = this.policeClearanceImage;
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Documents {
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

  Documents(
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

  Documents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    status = json['status'];
    name = json['name'];
    number = json['number'];
    businessId = json['business_id'];
    image = json['image'];
    rejectReason = json['reject_reason'].toString();
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
