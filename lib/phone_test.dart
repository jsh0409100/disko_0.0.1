import 'package:disko_001/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class phonelogin extends StatefulWidget {
  const phonelogin({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<phonelogin> createState() => _phoneloginState();
}

class _phoneloginState extends State<phonelogin> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController countrycode = TextEditingController();
  TextEditingController ver = TextEditingController();

  var phone = "";

  @override
  void initState() {
    countrycode.text = "+82";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 55,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 40,
                  child: TextField(
                    controller: countrycode,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "|",
                  style: TextStyle(fontSize: 33, color: Colors.grey),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      phone = value;
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Phone"),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: '${countrycode.text + phone}',
                verificationCompleted: (PhoneAuthCredential credential) {},
                verificationFailed: (FirebaseAuthException e) {},
                codeSent: (String verificationId, int? resendToken) {
                  phonelogin.verify = verificationId;
                },
                codeAutoRetrievalTimeout: (String verificationId) {},
              );
            },
            child: const Text('Send the code'),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 55,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              width: 100,
              child: TextField(
                controller: ver,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: phonelogin.verify, smsCode: ver.text);

                // Sign the user in (or link) with the credential
                await auth.signInWithCredential(credential);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHome()),
                ); // 이건 Get.to로 변경
              } catch (e) {
                print(e);
              }
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }
}
