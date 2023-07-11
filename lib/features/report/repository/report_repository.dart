import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/models/report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';

final reportRepositoryProvider = Provider(
  (ref) => ReportRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ReportRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ReportRepository({
    required this.firestore,
    required this.auth,
  });

  void _saveReport({
    required String report,
    required Timestamp time,
    required String reportType,
    required String reportedUid,
    required String reportId,
  }) async {
    final message = ReportModel(
      report: report,
      reportType: reportType,
      reportedUid: reportedUid,
      reporterUid: auth.currentUser!.uid,
      reportId: reportId,
      time: time,
    );

    await firestore.collection('reports').doc(reportId).set(
          message.toJson(),
        );
  }

  void submitReport({
    required BuildContext context,
    required String report,
    required String reportType,
    required String reportedUid,
    required String reportId,
  }) async {
    try {
      var time = Timestamp.now();

      _saveReport(
        report: report,
        reportType: reportType,
        reportedUid: reportedUid,
        reportId: reportId,
        time: time,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
