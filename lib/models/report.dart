import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String report, reportType, reportedUid, reporterUid, reportId;
  final Timestamp time;

  ReportModel({
    required this.report,
    required this.time,
    required this.reportType,
    required this.reportedUid,
    required this.reporterUid,
    required this.reportId,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      time: json['time'],
      report: json['report'],
      reportType: json['reportType'],
      reportedUid: json['reportedUid'],
      reporterUid: json['reporterUid'],
      reportId: json['reportId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'report': report,
        'reportType': reportType,
        'reportedUid': reportedUid,
        'reporterUid': reporterUid,
        'reportId': reportId,
        'time': time,
      };
}
