class ReportCountModel {
  int? status;
  String? message;
  int? feedbacks;
  int? newReviews;

  ReportCountModel({this.status, this.message, this.feedbacks});

  ReportCountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    feedbacks = json['feedbacks'];
    newReviews = json['newReviews'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['feedbacks'] = this.feedbacks;
    data['newReviews'] = this.newReviews;
    return data;
  }
}
