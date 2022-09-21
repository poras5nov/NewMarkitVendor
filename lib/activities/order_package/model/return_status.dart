class ReturnStatusData {
  String? name;
  bool? isSelected = false;

  ReturnStatusData({this.name});

  ReturnStatusData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;

    return data;
  }
}
