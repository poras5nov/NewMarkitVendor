class ChangeStatusList {
  int? status;
  String? message;
  List<ChangeData>? data;

  ChangeStatusList({this.status, this.message, this.data});

  ChangeStatusList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ChangeData>[];
      json['data'].forEach((v) {
        data!.add(new ChangeData.fromJson(v));
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

class ChangeData {
  int? id;
  String? name;
  String? image;
  bool? isSelected = false;

  ChangeData({this.id, this.name, this.image});

  ChangeData.fromJson(Map<String, dynamic> json) {
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
