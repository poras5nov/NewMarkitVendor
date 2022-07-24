class HsnModel {
  int? status;
  String? message;
  List<Hsnata>? data;

  HsnModel({this.status, this.message, this.data});

  HsnModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Hsnata>[];
      json['data'].forEach((v) {
        data!.add(new Hsnata.fromJson(v));
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

class Hsnata {
  int? id;
  String? number;
  String? categoryId;
  String? taxable;
  String? howMuchTax;
  String? createdAt;
  String? updatedAt;

  Hsnata(
      {this.id,
      this.number,
      this.categoryId,
      this.taxable,
      this.howMuchTax,
      this.createdAt,
      this.updatedAt});

  Hsnata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    categoryId = json['category_id'];
    taxable = json['taxable'];
    howMuchTax = json['how_much_tax'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['category_id'] = this.categoryId;
    data['taxable'] = this.taxable;
    data['how_much_tax'] = this.howMuchTax;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
