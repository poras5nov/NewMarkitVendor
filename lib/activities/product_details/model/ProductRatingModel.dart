class ProductRatingModel {
  int? status;
  String? message;
  AllReviews? allReviews;
  ProductRatings? productRatings;

  ProductRatingModel(
      {this.status, this.message, this.allReviews, this.productRatings});

  ProductRatingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    allReviews = json['all_reviews'] != null
        ? new AllReviews.fromJson(json['all_reviews'])
        : null;
    productRatings = json['product_ratings'] != null
        ? new ProductRatings.fromJson(json['product_ratings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.allReviews != null) {
      data['all_reviews'] = this.allReviews!.toJson();
    }
    if (this.productRatings != null) {
      data['product_ratings'] = this.productRatings!.toJson();
    }
    return data;
  }
}

class AllReviews {
  int? currentPage;
  List<Data>? data;
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

  AllReviews(
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

  AllReviews.fromJson(Map<String, dynamic> json) {
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
    if (json['next_page_url'] == null) {
      nextPageUrl = '';
    } else {
      nextPageUrl = json['next_page_url'];
    }
    path = json['path'];
    perPage = json['per_page'];
    if (json['prev_page_url'] == null) {
      prevPageUrl = '';
    } else {
      prevPageUrl = json['prev_page_url'];
    }
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
  int? isRead;
  int? readByAdmin;
  int? readByVendor;
  String? userName;
  int? vendorId;
  int? productId;
  String? rating;
  String? title;
  String? description;
  String? links;
  String? createdAt;
  String? updatedAt;
  int? helpfulCount;
  int? notHelpfulCount;
  User? user;

  Data(
      {this.id,
      this.isRead,
      this.readByAdmin,
      this.readByVendor,
      this.userName,
      this.vendorId,
      this.productId,
      this.rating,
      this.title,
      this.description,
      this.links,
      this.createdAt,
      this.updatedAt,
      this.helpfulCount,
      this.notHelpfulCount,
      this.user});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isRead = json['is_read'];
    readByAdmin = json['read_by_admin'];
    readByVendor = json['read_by_vendor'];
    userName = json['user_name'].toString();
    vendorId = json['vendor_id'];
    productId = json['product_id'];
    rating = json['rating'].toString();
    title = json['title'].toString();
    description = json['description'];
    if (json['links'] == null) {
      links = '';
    } else {
      links = json['links'];
    }

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    helpfulCount = json['helpful_count'];
    notHelpfulCount = json['not_helpful_count'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_read'] = this.isRead;
    data['read_by_admin'] = this.readByAdmin;
    data['read_by_vendor'] = this.readByVendor;
    data['user_name'] = this.userName;
    data['vendor_id'] = this.vendorId;
    data['product_id'] = this.productId;
    data['rating'] = this.rating;
    data['title'] = this.title;
    data['description'] = this.description;
    data['links'] = this.links;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['helpful_count'] = this.helpfulCount;
    data['not_helpful_count'] = this.notHelpfulCount;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class ProductRatings {
  String? totalRatings;
  String? fiveStarRating;
  String? fourStarRating;
  String? threeStarRating;
  String? twotarRating;
  String? onetarRating;

  ProductRatings(
      {this.totalRatings,
      this.fiveStarRating,
      this.fourStarRating,
      this.threeStarRating,
      this.twotarRating,
      this.onetarRating});

  ProductRatings.fromJson(Map<String, dynamic> json) {
    if (json['totalRatings'] == null) {
      totalRatings = '0';
    } else {
      totalRatings = json['totalRatings'].toString();
    }
    if (json['fiveStarRating'] == null) {
      fiveStarRating = '0';
    } else {
      fiveStarRating = json['fiveStarRating'].toString();
    }
    if (json['fourStarRating'] == null) {
      fourStarRating = '0';
    } else {
      fourStarRating = json['fourStarRating'].toString();
    }
    if (json['threeStarRating'] == null) {
      threeStarRating = '0';
    } else {
      threeStarRating = json['threeStarRating'].toString();
    }
    if (json['twotarRating'] == null) {
      twotarRating = '0';
    } else {
      twotarRating = json['twotarRating'].toString();
    }
    if (json['onetarRating'] == null) {
      onetarRating = '0';
    } else {
      onetarRating = json['onetarRating'].toString();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalRatings'] = this.totalRatings;
    data['fiveStarRating'] = this.fiveStarRating;
    data['fourStarRating'] = this.fourStarRating;
    data['threeStarRating'] = this.threeStarRating;
    data['twotarRating'] = this.twotarRating;
    data['onetarRating'] = this.onetarRating;
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
