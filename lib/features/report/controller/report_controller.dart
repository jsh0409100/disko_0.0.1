import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controller/auth_controller.dart';
import '../repository/report_repository.dart';

final reportControllerProvider = Provider((ref) {
  final reportRepository = ref.watch(reportRepositoryProvider);
  return ReportController(
    reportRepository: reportRepository,
    ref: ref,
  );
});

class ReportController {
  final ReportRepository reportRepository;
  final ProviderRef ref;
  ReportController({
    required this.reportRepository,
    required this.ref,
  });

  void submitReport(
      BuildContext context, String report, String reportType, String reportedUid, String reportId) {
    ref.read(userDataAuthProvider).whenData(
          (value) => reportRepository.submitReport(
            context: context,
            report: report,
            reportType: reportType,
            reportedUid: reportedUid,
            reportId: reportId,
          ),
        );
  }
}
