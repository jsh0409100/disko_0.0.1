import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';
import '../controller/auth_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  static const routeName = '/signup-screen';
  final bool itisSignUp;

  const SignUpScreen({required this.itisSignUp, Key? key, }) : super(key: key);

  static String verificationId = "";

  @override
  ConsumerState<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends ConsumerState<SignUpScreen> {
  bool _isVisible = false;
  String title = '';
  final countryPicker = const FlCountryCodePicker();

  TextEditingController verController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();

  var phone = "";
  // CollectionReference users = FirebaseFirestore.instance.collection('users');
  CountryCode? countryCode;

  void sendPhoneNumber() {
    String phoneNumber = phoneNumController.text.trim();
    if (phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${countryCode!.dialCode}$phoneNumber');
    } else {
      showSnackBar(context: context, content: '핸드폰 번호와 국가 코드를 입력해주세요');
    }
  }

  @override
  void dispose() {
    super.dispose();
    phoneNumController.dispose();
    verController.dispose();
  }

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP, String countryCode, bool itisSignUp) {
    ref.read(authControllerProvider).verifyOTP(
          context,
          SignUpScreen.verificationId,
          userOTP,
          countryCode,
          itisSignUp,
        );
  }

  void visibility() {
    setState(() {
      _isVisible = true;
    });
  }

  String whattitle() {
    if(widget.itisSignUp == true){
      return "회원가입";
    } else {
      return "로그인";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          whattitle(),
          semanticsLabel: title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            size: 24,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.041),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🤫',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.004),
                const Column(
                  children: [
                    Text(
                      '디스코는 휴대폰 번호로만 로그인해요.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '인증목적으로만 사용되니 안심하세요!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () async {
                      final code = await countryPicker.showPicker(context: context);
                      setState(() {
                        countryCode = code;
                      });
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: const Color(0xffC4C4C4),
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(5.0))),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          FittedBox(
                            child: Text(
                              countryCode?.dialCode ?? "+1",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 7),
                          const Icon(
                            Icons.arrow_drop_down_outlined,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: phoneNumController,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        phone = value;
                      },
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Color(0xffC4C4C4)), //<-- SEE HERE
                        ),
                        hintText: '휴대폰 번호를 입력해주세요.',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                minimumSize: const Size(double.maxFinite, 49),
                backgroundColor: const Color(0xff4E4E4E),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xff4e4e4e4d),
                disabledForegroundColor: Colors.white,
              ),
              onPressed:
                  phoneNumController.text != "" ? () => {sendPhoneNumber(), visibility()} : null,
              child: const Text(
                '인증문자 받기',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Visibility(
              visible: _isVisible,
              child: SizedBox(
                height: 44,
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: verController,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Color(0xffC4C4C4)), //<-- SEE HERE
                    ),
                    hintText: '인증번호를 입력해 주세요.',
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.029),
            Visibility(
              visible: _isVisible,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '이용약관 ',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color(0xff797979),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '및 ',
                    style: TextStyle(
                      color: Color(0xff797979),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '개인정보 취급방침',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color(0xff797979),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.018),
            Visibility(
              visible: _isVisible,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.maxFinite, 51),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  disabledBackgroundColor: Theme.of(context).colorScheme.primary.withAlpha(90),
                ),
                onPressed: verController.text != ""
                    ? () => verifyOTP(
                          ref,
                          context,
                          verController.text.trim(),
                          countryCode!.dialCode,
                          widget.itisSignUp,
                        )
                    : null,
                child: const Text(
                  '디스코 시작하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
