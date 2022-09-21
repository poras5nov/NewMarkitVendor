class BusinessModel {
  String? name;
  int? type;
  String? categoryId = "";
  String? storeImages = "";
  String? phone;
  String? bussinessEmail;
  String? website;
  String? address;
  String? state;
  String? city;
  String? postalCode;
  String? addressLine;
  String? pickupState;
  String? pickupCity;
  String? pickupPostalCode;
  String? latitude;
  String? longitude;
  String? panNumber = "";
  String? gstNumber = "";
  String? aadhaarNumber = "";
  // String? policeClearanceCertificate = "";
  String? cancelledChequeNumber = "";
  String? panImage = "";
  String? aadhaarImage = "";
  String? gstImage = "";
  // String? policeClearanceImage = "";
  String? cancelledChequeImage = "";
  String? panDuplicateImage = "";
  String? aadhaarDuplicateImage = "";
  String? gstDuplicateImage = "";
  // String? policeClearanceImage = "";
  String? cancelledDuplicateChequeImage = "";
  String? signatureImage = "";
  // String? policeClearanceImage = "";
  String? signatureDuplicateChequeImage = "";
  String? bankAccount;
  String? bankName;
  String? ifscCode;
  String? accountHolderName;
  String? sharedDelivery;
  String? freeDelivery;
  List<WorkingDays>? workingDays;

  BusinessModel(
      {this.name,
      this.type,
      this.categoryId,
      this.storeImages,
      this.phone,
      this.bussinessEmail,
      this.website,
      this.address,
      this.state,
      this.city,
      this.postalCode,
      this.addressLine,
      this.pickupState,
      this.pickupCity,
      this.pickupPostalCode,
      this.latitude,
      this.longitude,
      this.panNumber,
      this.gstNumber,
      this.aadhaarNumber,
      // this.policeClearanceCertificate,
      this.cancelledChequeNumber,
      this.panImage,
      this.aadhaarImage,
      this.gstImage,
      //  this.policeClearanceImage,
      this.cancelledChequeImage,
      this.panDuplicateImage,
      this.aadhaarDuplicateImage,
      this.gstDuplicateImage,
      //  this.policeClearanceImage,
      this.cancelledDuplicateChequeImage,
      this.signatureImage,
      this.signatureDuplicateChequeImage,
      this.bankAccount,
      this.bankName,
      this.ifscCode,
      this.accountHolderName,
      this.sharedDelivery,
      this.freeDelivery,
      this.workingDays});

  BusinessModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    categoryId = json['category_id'];
    storeImages = json['store_images'];
    phone = json['phone'];
    bussinessEmail = json['bussiness_email'];
    website = json['website'];
    address = json['address'];
    state = json['state'];
    city = json['city'];
    postalCode = json['postal_code'];
    addressLine = json['address_line'];
    pickupState = json['pickup_state'];
    pickupCity = json['pickup_city'];
    pickupPostalCode = json['pickup_postal_code'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    panNumber = json['pan_number'];
    gstNumber = json['gst_number'];
    aadhaarNumber = json['aadhaar_number'];
    // policeClearanceCertificate = json['police_Clearance_Certificate'];
    cancelledChequeNumber = json['cancelled_cheque_number'];
    panImage = json['pan_image'];
    aadhaarImage = json['aadhaar_image'];
    gstImage = json['gst_image'];
    // policeClearanceImage = json['police_Clearance_image'];
    cancelledChequeImage = json['cancelled_cheque_image'];
    signatureImage = json['signature_image'];

    bankAccount = json['bank_account'];
    bankName = json['bank_name'];
    ifscCode = json['ifsc_code'];
    accountHolderName = json['account_holder_name'];
    sharedDelivery = json['shared_delivery'];
    freeDelivery = json['free_delivery'];
    if (json['working_days'] != null) {
      workingDays = <WorkingDays>[];
      json['working_days'].forEach((v) {
        workingDays!.add(new WorkingDays.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['category_id'] = this.categoryId;
    data['store_images'] = this.storeImages;
    data['phone'] = this.phone;
    data['bussiness_email'] = this.bussinessEmail;
    data['website'] = this.website;
    data['address'] = this.address;
    data['state'] = this.state;
    data['city'] = this.city;
    data['postal_code'] = this.postalCode;
    data['address_line'] = this.addressLine;
    data['pickup_state'] = this.pickupState;
    data['pickup_city'] = this.pickupCity;
    data['pickup_postal_code'] = this.pickupPostalCode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['pan_number'] = this.panNumber;
    data['gst_number'] = this.gstNumber;
    data['aadhaar_number'] = this.aadhaarNumber;
    // data['police_Clearance_Certificate'] = this.policeClearanceCertificate;
    data['cancelled_cheque_number'] = this.cancelledChequeNumber;
    data['pan_image'] = this.panImage;
    data['aadhaar_image'] = this.aadhaarImage;
    data['gst_image'] = this.gstImage;
    //  data['police_Clearance_image'] = this.policeClearanceImage;
    data['cancelled_cheque_image'] = this.cancelledChequeImage;
    data['signature_image'] = this.signatureImage;

    data['bank_account'] = this.bankAccount;
    data['bank_name'] = this.bankName;
    data['ifsc_code'] = this.ifscCode;
    data['account_holder_name'] = this.accountHolderName;
    data['shared_delivery'] = this.sharedDelivery;
    data['free_delivery'] = this.freeDelivery;
    if (this.workingDays != null) {
      data['working_days'] = this.workingDays!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkingDays {
  String? from = "";
  String? fromType = "";
  String? to = "";
  String? toType = "";
  String? open = "";
  String? day = "";

  WorkingDays(
      {this.from, this.fromType, this.to, this.toType, this.open, this.day});

  WorkingDays.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    fromType = json['from_type'];
    to = json['to'];
    toType = json['to_type'];
    open = json['open'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['from_type'] = this.fromType;
    data['to'] = this.to;
    data['to_type'] = this.toType;
    data['open'] = this.open;
    data['day'] = this.day;
    return data;
  }
}
