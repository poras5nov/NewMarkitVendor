class VendorRatingModel {
  int? status;
  String? message;
  Rating? rating;

  VendorRatingModel({this.status, this.message, this.rating});

  VendorRatingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    rating =
        json['rating'] != null ? new Rating.fromJson(json['rating']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.rating != null) {
      data['rating'] = this.rating!.toJson();
    }
    return data;
  }
}

class Rating {
  List<Ratings>? ratings;
  String? totalRatings;
  String? fiveStarRating;
  String? fourStarRating;
  String? threeStarRating;
  String? twotarRating;
  String? onetarRating;

  Rating(
      {this.ratings,
      this.totalRatings,
      this.fiveStarRating,
      this.fourStarRating,
      this.threeStarRating,
      this.twotarRating,
      this.onetarRating});

  Rating.fromJson(Map<String, dynamic> json) {
    if (json['ratings'] != null) {
      ratings = <Ratings>[];
      json['ratings'].forEach((v) {
        ratings!.add(new Ratings.fromJson(v));
      });
    }
    totalRatings = json['totalRatings'].toString();
    fiveStarRating = json['fiveStarRating'].toString();
    fourStarRating = json['fourStarRating'].toString();
    threeStarRating = json['threeStarRating'].toString();
    twotarRating = json['twotarRating'].toString();
    onetarRating = json['onetarRating'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ratings != null) {
      data['ratings'] = this.ratings!.map((v) => v.toJson()).toList();
    }
    data['totalRatings'] = this.totalRatings;
    data['fiveStarRating'] = this.fiveStarRating;
    data['fourStarRating'] = this.fourStarRating;
    data['threeStarRating'] = this.threeStarRating;
    data['twotarRating'] = this.twotarRating;
    data['onetarRating'] = this.onetarRating;
    return data;
  }
}

class Ratings {
  int? id;
  int? userId;
  int? vendorId;
  String? rating;
  String? title;
  String? description;
  String? createdAt;
  String? updatedAt;
  User? user;

  Ratings(
      {this.id,
      this.userId,
      this.vendorId,
      this.rating,
      this.title,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.user});

  Ratings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    rating = json['rating'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['vendor_id'] = this.vendorId;
    data['rating'] = this.rating;
    data['title'] = this.title;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  dynamic code;
  String? profile;
  String? role;
  dynamic managerTypeId;
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
  String? city;
  dynamic postalCode;
  String? status;
  String? riderVerifyStatus;
  int? riderJobStatus;
  String? appVersion;
  String? deviceType;
  String? oneSignalId;
  String? provider;
  String? googleId;
  dynamic facebookId;
  dynamic appleId;
  dynamic otp;
  String? otpTime;
  String? createdAt;
  String? updatedAt;
  int? profileStep;
  int? offerOrderCount;
  String? userTypeStatus;

  User(
      {this.id,
      this.code,
      this.profile,
      this.role,
      this.managerTypeId,
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
      this.provider,
      this.googleId,
      this.facebookId,
      this.appleId,
      this.otp,
      this.otpTime,
      this.createdAt,
      this.updatedAt,
      this.profileStep,
      this.offerOrderCount,
      this.userTypeStatus});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    profile = json['profile'];
    role = json['role'];
    managerTypeId = json['manager_type_id'];
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
    provider = json['provider'];
    googleId = json['google_id'];
    facebookId = json['facebook_id'];
    appleId = json['apple_id'];
    otp = json['otp'];
    otpTime = json['otp_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profileStep = json['profile_step'];
    offerOrderCount = json['offer_order_count'];
    userTypeStatus = json['user_type_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['profile'] = this.profile;
    data['role'] = this.role;
    data['manager_type_id'] = this.managerTypeId;
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
    data['provider'] = this.provider;
    data['google_id'] = this.googleId;
    data['facebook_id'] = this.facebookId;
    data['apple_id'] = this.appleId;
    data['otp'] = this.otp;
    data['otp_time'] = this.otpTime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['profile_step'] = this.profileStep;
    data['offer_order_count'] = this.offerOrderCount;
    data['user_type_status'] = this.userTypeStatus;
    return data;
  }
}
