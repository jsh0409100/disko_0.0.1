import 'package:flutter/material.dart';

class ConditionPage extends StatefulWidget {
  const ConditionPage({Key? key}) : super(key: key);

  @override
  State<ConditionPage> createState() => _ConditionPageState();
}

class _ConditionPageState extends State<ConditionPage> {
  List<bool> selected = List<bool>.generate(3, (int index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "이용약관 및 개인정보취급방침",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      dataRowHeight: 63,
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            '전체동의',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                      rows: <DataRow>[
                        DataRow(
                          cells: const <DataCell>[
                            DataCell(ConditionCell(
                              conditionTitle: '서비스 이용약관',
                            ))
                          ],
                          selected: selected[0],
                          onSelectChanged: (bool? value) {
                            setState(() {
                              selected[0] = value!;
                            });
                          },
                        ),
                        DataRow(
                          cells: const <DataCell>[
                            DataCell(ConditionCell(
                              conditionTitle:
                                  '개인정보의 수집 이용목적, 수집하는 개인 정보의 항목 및 수집방법',
                            ))
                          ],
                          selected: selected[1],
                          onSelectChanged: (bool? value) {
                            setState(() {
                              selected[1] = value!;
                            });
                          },
                        ),
                        DataRow(
                          cells: const <DataCell>[
                            DataCell(ConditionCell(
                              conditionTitle: '개인정보의 보유 및 이용기간',
                            ))
                          ],
                          selected: selected[2],
                          onSelectChanged: (bool? value) {
                            setState(() {
                              selected[2] = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.maxFinite, 45),
                  backgroundColor: const Color(0xff7150FF),
                ),
                onPressed: () async {
                  // Get.to(() => const SignUpPage());
                },
                child: const Text('디스코 시작하기'),
              ),
            ),
          ),
          const SizedBox(
            height: 57,
          )
        ],
      ),
    );
  }
}

class ConditionCell extends StatelessWidget {
  final String conditionTitle;

  const ConditionCell({
    required this.conditionTitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 279, child: Text(conditionTitle)),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () {
            showModalBottomSheet<void>(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 375,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 38, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          conditionTitle,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        const Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text(
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                                '서비스 이용약관 내용은 이렇습니당구리구리구리구 니당구리구리구리구 부리부리부리부리부립루비리부리부부뤼구리구리구 서비니당구리구리구리구 부리부리부리부리부립루비리부리부부뤼구리구리구 서비부리부리부리부리부립루비리부리부부뤼구리구리구 서비스 이용약관 내용은 이렇습니당구리구리구리구 부리부리부리부리부립루비리부리부부뤼구리구리구 서비스 이용약관 내용은 이렇습니당구리구리구리구 부리부리부리부리부립루비리부리부부뤼구리구리구 서비스 이용약관 내용은 이렇습니당구리구리구리구 부리부리부리부리부립루비리부리부부뤼구리구리구 서비스 이용약관 내용은 이렇습니당구리구리구리구 부리부리부리부리부립루비리부리부부뤼구리구리구 서비스 이용약관 내용은 이렇습니당구리구리구리구 부리부리부리부리부립루비리부리부부뤼구리구리구'),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary),
                          child: Text(
                            '확인',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        )
      ],
    );
  }
}
