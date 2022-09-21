class BusinessAddressModel {
  int? businessId;
  String? address;
  String? state;
  String? city;
  String? postalCode;
  String? addressLine;
  String? pickupState;
  String? pickupCity;
  String? pickupPostalCode;

  BusinessAddressModel(
      {this.businessId,
      this.address,
      this.state,
      this.city,
      this.postalCode,
      this.addressLine,
      this.pickupState,
      this.pickupCity,
      this.pickupPostalCode});

  BusinessAddressModel.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    address = json['address'];
    state = json['state'];
    city = json['city'];
    postalCode = json['postal_code'];
    addressLine = json['address_line'];
    pickupState = json['pickup_state'];
    pickupCity = json['pickup_city'];
    pickupPostalCode = json['pickup_postal_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['address'] = this.address;
    data['state'] = this.state;
    data['city'] = this.city;
    data['postal_code'] = this.postalCode;
    data['address_line'] = this.addressLine;
    data['pickup_state'] = this.pickupState;
    data['pickup_city'] = this.pickupCity;
    data['pickup_postal_code'] = this.pickupPostalCode;
    return data;
  }
}
