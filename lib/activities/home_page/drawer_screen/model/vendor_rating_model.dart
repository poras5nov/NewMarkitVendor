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
    rating = json['rating'].toString();
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
  Null? code;
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
  String? appVersion;
  String? deviceType;
  String? oneSignalId;
  Null? otp;
  String? otpTime;
  String? createdAt;
  String? updatedAt;

  User(
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
      this.otp,
      this.otpTime,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
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
    otp = json['otp'];
    otpTime = json['otp_time'];
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
    data['otp'] = this.otp;
    data['otp_time'] = this.otpTime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
