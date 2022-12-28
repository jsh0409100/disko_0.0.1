import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final countryPicker = const FlCountryCodePicker();
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
        leading: new Icon(
          Icons.close,
          color: Colors.black,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
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
                      final code = await countryPicker.showPicker(context: context);
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
                          borderRadius: const BorderRadius.all(Radius.circular(5.0))),
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
                          Icon(
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
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
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
                minimumSize: Size(double.maxFinite, 50),
                primary: Colors.grey,
              ),
              onPressed: () {},
              child: const Text('인증문자 받기'),
            ),
          ],
        ),
      ),
    );
  }
}

