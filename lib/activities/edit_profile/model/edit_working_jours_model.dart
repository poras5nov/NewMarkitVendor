import '../../create_business/model/business_model.dart';

class EditWorkingHoursModel {
  int? businessId;
  List<WorkingDays>? workingDays;

  EditWorkingHoursModel({this.businessId, this.workingDays});

  EditWorkingHoursModel.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    if (json['working_days'] != null) {
      workingDays = <WorkingDays>[];
      json['working_days'].forEach((v) {
        workingDays!.add(new WorkingDays.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    if (this.workingDays != null) {
      data['working_days'] = this.workingDays!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
