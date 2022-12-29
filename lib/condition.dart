import 'package:disko_001/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConditionPage extends StatefulWidget {
  const ConditionPage({Key? key}) : super(key: key);

  @override
  State<ConditionPage> createState() => _ConditionPageState();
}

class Step {
  Step(this.title, this.body, [this.isExpanded = false]);

  String title;
  String body;
  bool isExpanded;
}

List<Step> getSteps() {
  return [
    Step('1. 서비스 이용약관', '서비스 이용약관에 관한 내용'),
    Step('2. 개인정보 수집 이용목적, 수집하는 개인정보의 항목 및 수집방법',
        '개인정보 수집 이용목적, 수집하는 개인정보의 항목 및 수집방법에 관한 내용'),
    Step('3. 개인정보의 보유 및 이용기간', '개인정보의 보유 및 이용기간에 관한 내용'),
  ];
}

class _ConditionPageState extends State<ConditionPage> {
  final List<Step> _steps = getSteps();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("이용약관 및 개인정보취급방침"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          _renderCondition(),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.5,
          ),
          buttongenerate('동의하고 시작하기'),
        ]),
      ),
    );
  }

  Widget _renderCondition() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _steps[index].isExpanded = !isExpanded;
        });
      },
      children: _steps.map<ExpansionPanel>((Step step) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(step.title),
            );
          },
          body: ListTile(
            title: Text(step.body),
          ),
          isExpanded: step.isExpanded,
        );
      }).toList(),
    );
  }

  Widget buttongenerate(String text) {
    return SizedBox(
      //width: MediaQuery.of(context).size.width/5,
      //height: MediaQuery.of(context).size.height/15,
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => const SignUpPage());
        },
        child: Text(text, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
