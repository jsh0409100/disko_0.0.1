import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home_screen/home.dart';

class SignUpPage extends StatefulWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Stream<User?> get authStateChange => auth.authStateChanges();

  SignUpPage({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final countryPicker = const FlCountryCodePicker();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController countrycode = TextEditingController();
  TextEditingController verController = TextEditingController();
  TextEditingController phonenumController = TextEditingController();

  var phone = "";
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CountryCode? countryCode;

  receiveAuthentication() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: countryCode!.dialCode + phone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        SignUpPage.verify = verificationId;
      },
      timeout: const Duration(minutes: 2),
      codeAutoRetrievalTimeout: (String verificationId) {}, //세원이가 5분 넣기
    );
  }

  AuthnumInput() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: SignUpPage.verify, smsCode: verController.text);

// Sign the user in (or link) with the credential
      await widget.auth.signInWithCredential(credential);

      UserModel newUser = UserModel(
          phoneNum: phone, countryCode: countryCode!.dialCode, name: "guest");
      users.doc(widget.auth.currentUser!.uid).set(newUser.toJson());

      Get.to(() => const MyHome());
    } catch (e) {
      print(e);
    }
  }

  bool _isVisible = false;

  void visibility() {
    setState(() {
      _isVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "회원가입",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        leading: const Icon(
          Icons.close,
          size: 24,
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
                Column(
                  children: const [
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
                      final code =
                          await countryPicker.showPicker(context: context);
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0))),
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
                      controller: phonenumController,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        phone = value;
                      },
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: Color(0xffC4C4C4)), //<-- SEE HERE
                        ),
                        labelText: '휴대폰 번호를 입력해주세요.',
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
                disabledBackgroundColor: const Color(0xff4E4E4E4D),
                disabledForegroundColor: Colors.white,
              ),
              onPressed: phonenumController.text != ""
                  ? () => {receiveAuthentication(), visibility()}
                  : null,
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
                      borderSide: BorderSide(
                          width: 1, color: Color(0xffC4C4C4)), //<-- SEE HERE
                    ),
                    labelText: '인증번호를 입력해 주세요.',
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.029),
            Visibility(
              visible: _isVisible,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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
                    '이용약관',
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
                  disabledBackgroundColor:
                      Theme.of(context).colorScheme.primary.withAlpha(90),
                ),
                onPressed:
                    verController.text != "" ? () => AuthnumInput() : null,
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
