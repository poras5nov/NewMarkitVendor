class BankInfoModel {
  String? bRANCH;

  BankInfoModel({this.bRANCH});

  BankInfoModel.fromJson(Map<String, dynamic> json) {
    bRANCH = json['BRANCH'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BRANCH'] = this.bRANCH;

    return data;
  }
}
