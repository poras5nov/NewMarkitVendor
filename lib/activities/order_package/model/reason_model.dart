class ReasonModel {
  int? status;
  List<Status>? statusList;
  String? message;
  List<RData>? data;

  ReasonModel({this.status, this.message, this.data});

  ReasonModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    if (json['statusList'] != null) {
      statusList = <Status>[];
      json['statusList'].forEach((v) {
        statusList!.add(new Status.fromJson(v));
      });
    }
    message = json['message'];
    if (json['data'] != null) {
      data = <RData>[];
      json['data'].forEach((v) {
        data!.add(new RData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.statusList != null) {
      data['status'] = this.statusList!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Status {
  int? id;
  String? name;
  String? image;
  bool? isSelected = false;

  Status({this.id, this.name, this.image});

  Status.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;

    return data;
  }
}

class RData {
  int? id;
  String? text;
  String? createdAt;
  String? updatedAt;

  RData({this.id, this.text, this.createdAt, this.updatedAt});

  RData.fromJson(Map<String, dynamic> json) {
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
