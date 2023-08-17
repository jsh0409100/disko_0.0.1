import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../models/user_model.dart';
import '../../../starting/start_page.dart';
import 'account_setting_page.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  static const routeName = '/FaQ-screen';

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  bool _expanded1 = false;
  bool _expanded2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('게시판 이용규칙'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 0,
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(25),
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () => throw Exception(),
                      child: const Text("Throw Test Exception")
                  ),
                  const Text(
                    '🫱🏻‍🫲🏼 서로 존중해주세요',
                    style: TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 20,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 30.0, bottom: 10),
                    child: Text(
                      '개인이나 그룹의 정체성을 공격하거나 배경이나 관심사에 \n대해 선입견을 갖거나 불친절하게 대하는 것을 DISKO는 \n결코 허용하지 않습니다.',
                      style: TextStyle(
                        color: Color(0xFF191919),
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💪🏻 정직하게 행동합니다',
                    style: TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 20,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, bottom: 10),
                    child: Text(
                      '소통에 있어서 무엇보다 솔직하고 진실한 태도가 중요하며 \n모든 계정 뒤에는 사람이 있다는 것을 기억해주세요.  나쁜 소문을 퍼뜨리거나, 다른 유저를 저격하거나, 모욕감을 \n주는 행위는 절대 허용되지 않습니다. ',
                      style: TextStyle(
                        color: Color(0xFF191919),
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💓 소통하기 편하고, 친절한 커뮤니티로!',
                    style: TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 20,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, bottom: 10),
                    child: Text(
                      'DISKO에는 다양한 연령대의 유저들이 활동하고 있습니다. \n안전을 최우선으로 생각해야하는 초등학생부터 성인까지 \n연령대의 폭이 넓기 때문에 대화를 할 때는 항상 친절하고 \n모든 연령대에 적합하게 행동해야 합니다. 무례하거나 모욕적\n이거나, 너무 폭력적이거나, 커뮤니티에 방해가 되는 글은 \n신고를 통해 DISKO팀이 신고 내용을 확인하고 적절한 조치를 \n취할 것입니다.',
                      style: TextStyle(
                        color: Color(0xFF191919),
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ExpansionPanelList(
              expandedHeaderPadding: const EdgeInsets.all(10.0),
              children: [
                ExpansionPanel(
                  hasIcon: false,
                  canTapOnHeader: true,
                  headerBuilder: (context, isExpanded) {
                    return ListTile(
                        title: const Text(
                          '제한하는 콘텐츠 내용',
                          style: TextStyle(
                            color: Color(0xFF191919),
                            fontSize: 17,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        leading: _expanded1
                            ? const Icon(Icons.arrow_right)
                            : const Icon(Icons.arrow_drop_down)
                    );
                  },
                  body: const Text(
                    '1) 혐오 콘텐츠 및 비속어\n2) 폭력적이거나, 충격적이거나, 유혈적인 콘텐츠\n3) 노출 및 성적 콘텐츠\n4) 정치적 콘텐츠 및 논란이 될 수 있는 사회적 이슈\n5) 비극적, 민감성 콘텐츠\n7) 호도하는 콘텐츠\n',
                    style: TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                    ),
                  ),
                  isExpanded: _expanded1,
                ),
                ExpansionPanel(
                  hasIcon: false,
                  canTapOnHeader: true,
                  headerBuilder: (context, isExpanded) {
                    return ListTile(
                      title: const Text(
                        '이용제한 방식',
                        style: TextStyle(
                          color: Color(0xFF191919),
                          fontSize: 17,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                        leading: _expanded2
                            ? const Icon(Icons.arrow_right)
                            : const Icon(Icons.arrow_drop_down)
                    );
                  },
                  body: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'DISKO는 커뮤니티 가이드라인을 위반한 유저의 서비스 이용을 제한할 수 있습니다. DISKO는 커뮤니티 가이드라인을 위반한 콘텐츠를 블라인드 삭제할 수 있는 권리가 있으며, 위반에 사용된 계정을 정지시킬 권리가 있고 반복해서 위반한 경우에는 계정을 삭제 처리할 수 있습니다. DISKO는 커뮤니티 가이드라인을 위반하는 항목을 결정할 수 있는 단독 권한을 가집니다. \n',
                          style: TextStyle(
                            color: Color(0xFF191919),
                            fontSize: 12,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            height: 1.33,
                          ),
                        ),
                        TextSpan(
                          text:
                              '1. 게시물 삭제 커뮤니티 가이드라인에 위반되는 항목에 해당 하는 게시물이 발견되거나 신고를 통해 접수되면 검토 후 별도의 통보 없이 삭제됩니다. \n2. 계정 정지 커뮤니티 가이드라인에 위반되는 항목 중에서  그 정도가 심각하거나, 동일한 아이디를 통해 반복해서  해당 행위를 저지르는 경우 검토 후 해당 계정을 정지합니다. \n3. IP 주소 차단 커뮤니티 가이드라인에 위반되는 항목 중에서 그 정도가 매우 심각하거나, 동일한 IP 주소 상에서 여러  계정을 통해 반복해서 해당 행위를 저지르는 경우 검토 후 해당 IP 주소에서 더 이상 DISKO 서비스를 사용할 수 없도록 차단합니다.',
                          style: TextStyle(
                            color: Color(0xFF191919),
                            fontSize: 12,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ),
                  isExpanded: _expanded2,
                ),
              ],
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  if (panelIndex == 0) {
                    _expanded1 = !_expanded1;
                  }
                  if (panelIndex == 1) {
                    _expanded2 = !_expanded2;
                  }
                });
              },
            ),
          ],
        ));
  }
}
