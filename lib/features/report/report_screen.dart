import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../app_layout_screen.dart';
import 'controller/report_controller.dart';

class ReportScreen extends ConsumerWidget {
  static const String routeName = '/report-screen';
  final String reportedUid;
  final String reportedDisplayName;
  const ReportScreen({Key? key, required this.reportedUid, required this.reportedDisplayName})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController reportController = TextEditingController();
    TextEditingController reportTypeController = TextEditingController();
    final List<DropdownMenuEntry<String>> entries = <DropdownMenuEntry<String>>[
      const DropdownMenuEntry(value: '광고, 홍보/ 거래 시도', label: '광고, 홍보/ 거래 시도'),
      const DropdownMenuEntry(value: '욕설, 음란어 사용', label: '욕설, 음란어 사용'),
      const DropdownMenuEntry(value: '비매너', label: '비매너'),
      const DropdownMenuEntry(value: '기타', label: '기타'),
    ];

    void _submitReport(String reportId) async {
      ref.read(reportControllerProvider).submitReport(
            context,
            reportController.text,
            reportTypeController.text,
            reportedUid,
            reportId,
          );
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppLayoutScreen.routeName,
        (route) => false,
      );
      showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              title: Text(
                '신고가 접수되었습니다.',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            );
          });
    }

    return Scaffold(
        appBar: AppBar(
          shape: const Border(bottom: BorderSide(color: Colors.black, width: 0.5)),
          centerTitle: true,
          title: const Text(
            '사용자 신고',
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(
                        reportedDisplayName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.black, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        '님을',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black),
                      ),
                    ]),
                    Text(
                      '신고하려는 이유를 선택해 주세요',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownMenu<String>(
                  controller: reportTypeController,
                  label: const Text('신고 종류를 선택해 주세요'),
                  dropdownMenuEntries: entries,
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                    controller: reportController,
                    maxLength: 300,
                    maxLines: 30,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Theme.of(context).colorScheme.primary), //<-- SEE HERE
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                      hintText: '신고 내용을 입력해 주세요',
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      final reportId = const Uuid().v1();
                      _submitReport(reportId);
                    },
                    style: TextButton.styleFrom(
                      elevation: 2,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text('신고 접수 하기',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: Colors.white)),
                  ),
                ),
              ]),
            );
          },
        ));
  }
}
