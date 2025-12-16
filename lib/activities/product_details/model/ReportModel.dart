class ReportModel {
  int? status;
  String? message;
  List<Feedbacks>? feedbacks;

  ReportModel({this.status, this.message, this.feedbacks});

  ReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['feedbacks'] != null) {
      feedbacks = <Feedbacks>[];
      json['feedbacks'].forEach((v) {
        feedbacks!.add(new Feedbacks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.feedbacks != null) {
      data['feedbacks'] = this.feedbacks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Feedbacks {
  int? id;
  int? isRead;
  int? readByAdmin;
  int? readByVendor;
  int? userId;
  int? reviewId;
  int? helpfull;
  String? report;
  int? productId;
  String? createdAt;
  String? updatedAt;
  User? user;

  Feedbacks(
      {this.id,
      this.isRead,
      this.readByAdmin,
      this.readByVendor,
      this.userId,
      this.reviewId,
      this.helpfull,
      this.report,
      this.productId,
      this.createdAt,
      this.updatedAt,
      this.user});

  Feedbacks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isRead = json['is_read'];
    readByAdmin = json['read_by_admin'];
    readByVendor = json['read_by_vendor'];
    userId = json['user_id'];
    reviewId = json['review_id'];
    helpfull = json['helpfull'];
    report = json['report'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_read'] = this.isRead;
    data['read_by_admin'] = this.readByAdmin;
    data['read_by_vendor'] = this.readByVendor;
    data['user_id'] = this.userId;
    data['review_id'] = this.reviewId;
    data['helpfull'] = this.helpfull;
    data['report'] = this.report;
    data['product_id'] = this.productId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? profile;

  String? name;

  User({
    this.profile,
    this.name,
  });

  User.fromJson(Map<String, dynamic> json) {
    profile = json['profile'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['profile'] = this.profile;

    data['name'] = this.name;
    return data;
  }
}
