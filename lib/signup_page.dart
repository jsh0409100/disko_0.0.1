import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final countryPicker = const FlCountryCodePicker();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController countrycode = TextEditingController();
  TextEditingController verController = TextEditingController();

  var phone = "";
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CountryCode? countryCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "로그인",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(
          Icons.close,
          color: Colors.black,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.phonelink_lock,
                  size: 40,
                  color: Color(0xff9865FC),
                ),
                SizedBox(width: MediaQuery.of(context).size.height * 0.01),
                Column(
                  children: const [
                    Text(
                      '디스코는 휴대폰 번호로만 로그인해요.',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      '인증목적으로만 사용되니 안심하세요!',
                      style: TextStyle(
                        fontSize: 17,
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
                      height: 45,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0))),
                      child: Row(
                        children: [
                          Center(
                            child: Text(
                              countryCode?.dialCode ?? "+1",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down_outlined,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.height * 0.01),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 45,
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        phone = value;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '휴대폰 번호를 입력해주세요.',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.maxFinite, 50),
                backgroundColor: Colors.grey,
              ),
              onPressed: () async {
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: countryCode!.dialCode + phone,
                  verificationCompleted: (PhoneAuthCredential credential) {},
                  verificationFailed: (FirebaseAuthException e) {},
                  codeSent: (String verificationId, int? resendToken) {
                    SignUpPage.verify = verificationId;
                  },
                  timeout: const Duration(minutes: 2),
                  codeAutoRetrievalTimeout:
                      (String verificationId) {}, //세원이가 5분 넣기
                );
              },
              child: const Text('인증문자 받기'),
            ),
            Expanded(
              child: SizedBox(
                height: 45,
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: verController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '인증번호를 입력해 주세요.',
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.maxFinite, 50),
                backgroundColor: Colors.grey,
              ),
              onPressed: () async {
                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: SignUpPage.verify,
                      smsCode: verController.text);

                  // Sign the user in (or link) with the credential
                  await auth.signInWithCredential(credential);

                  UserModel newUser = UserModel(
                      phoneNum: phone,
                      countryCode: countryCode!.dialCode,
                      name: "guest",
                      uid: auth.currentUser!.uid);
                  users.add(newUser.toJson());

                  Get.to(() => const MyHome());
                } catch (e) {
                  print(e);
                }
              },
              child: const Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
