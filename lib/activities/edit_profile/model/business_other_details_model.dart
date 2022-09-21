class BusinessOtherDetailsModel {
  String? name;
  int? businessId;
  String? storeImages;
  String? phone;
  String? bussinessEmail;
  String? website;
  String? freeDelivery;
  String? sharedDelivery;

  BusinessOtherDetailsModel(
      {this.name,
      this.businessId,
      this.storeImages,
      this.phone,
      this.bussinessEmail,
      this.website,
      this.freeDelivery,
      this.sharedDelivery});

  BusinessOtherDetailsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    businessId = json['business_id'];
    storeImages = json['store_images'];
    phone = json['phone'];
    bussinessEmail = json['bussiness_email'];
    website = json['website'];
    freeDelivery = json['free_delivery'];
    sharedDelivery = json['shared_delivery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['business_id'] = this.businessId;
    data['store_images'] = this.storeImages;
    data['phone'] = this.phone;
    data['bussiness_email'] = this.bussinessEmail;
    data['website'] = this.website;
    data['free_delivery'] = this.freeDelivery;
    data['shared_delivery'] = this.sharedDelivery;
    return data;
  }
}
