import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:telephony/telephony.dart';

import '../../../common/utils/utils.dart';
import '../controller/auth_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  static const routeName = '/signup-screen';
  final bool isSignUp;

  const SignUpScreen({
    required this.isSignUp,
    Key? key,
  }) : super(key: key);

  static String verificationId = "";

  @override
  ConsumerState<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends ConsumerState<SignUpScreen> {
  String otp = '';
  String title = '';

  bool _isVisible = false;
  final countryPicker = const FlCountryCodePicker();

  Telephony telephony = Telephony.instance;
  OtpFieldController verController = OtpFieldController();

  // TextEditingController verController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();

  var phone = "";
  CountryCode? countryCode;

  void sendPhoneNumber(
    bool isSignUp,
  ) {
    String phoneNumber = phoneNumController.text.trim();
    if (phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, phoneNumber, countryCode!.dialCode, isSignUp);
      setState(() {
        _isVisible = true;
      });
    } else {
      showSnackBar(context: context, content: '핸드폰 번호와 국가 코드를 입력해주세요');
    }
  }

  void verifyOTP(
      WidgetRef ref, BuildContext context, String userOTP, String countryCode, bool isSignUp) {
    ref.read(authControllerProvider).verifyOTP(
          context,
          SignUpScreen.verificationId,
          userOTP,
          countryCode,
          isSignUp,
        );
  }

  String whattitle() {
    if (widget.isSignUp == true) {
      return "회원가입";
    } else {
      return "로그인";
    }
  }

  @override
  void initState() {
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        print(message.address);
        print(message.body);

        String sms = message.body.toString();

        if (message.body!.contains('disko001.firebaseapp.com')) {
          String otpcode = sms.replaceAll(RegExp(r'[^0-9]'), '');
          verController.set(otpcode.split(""));

          setState(() {
            // refresh UI
          });
        } else {
          print("error");
        }
      },
      listenInBackground: false,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    phoneNumController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          whattitle(),
          semanticsLabel: title,
          style: const TextStyle(
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
          icon: const Icon(
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
                        setState(() {
                          phone = value.trim();
                        });
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
                backgroundColor: phone.trim().isEmpty? const Color(0xff4e4e4e4d) : const Color(0xff4E4E4E),
                foregroundColor: Colors.white,
              ),
              onPressed: (phone.trim().isEmpty || phone.trim() == '')
                  ? null
                  : () => sendPhoneNumber(widget.isSignUp),
              child: const Text(
                '인증문자 받기',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Visibility(
              visible: _isVisible,
              child: SizedBox(
                height: 44,
                child: OTPTextField(
                  outlineBorderRadius: 10,
                  controller: verController,
                  length: 6,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 50,
                  style: const TextStyle(fontSize: 17),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  onCompleted: (pin) {
                    otp = pin;
                  },
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
                onPressed: otp != ""
                    ? () => verifyOTP(
                          ref,
                          context,
                          otp,
                          countryCode!.dialCode,
                          widget.isSignUp,
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
