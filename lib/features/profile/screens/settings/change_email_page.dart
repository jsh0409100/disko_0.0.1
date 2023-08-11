import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/utils/utils.dart';
import '../../../../models/user_model.dart';
import '../../cotroller/profile_controller.dart';

class EmailEditPage extends ConsumerStatefulWidget {
  final UserModel user;

  static const String routeName = 'email-edit-screen';

  const EmailEditPage({Key? key, required this.user}) : super(key: key);

  @override
  ConsumerState<EmailEditPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends ConsumerState<EmailEditPage> {
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.user.email != null) {
      emailController.text = widget.user.email!;
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  void updateEmail() {
    String email = emailController.text.trim();
    ref.read(profileControllerProvider).updateEmail(email);
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            title: Text(
              '이메일이 변경 되었습니다',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          );
        });
  }

  void increaseDiskoPoint() {
    ref.read(profileControllerProvider).increaseDiskoPoint(100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("이메일 변경"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              bool valid = EmailValidator.validate(emailController.text.trim());
              if (valid) {
                if (widget.user.email == null) increaseDiskoPoint();
                updateEmail();
              } else {
                showSnackBar(content: "올바른 이메일을 입력해 주세요", context: context);
              }
              ;
            },
            child: const Text("완료"),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textField(" ", "이메일을 입력해 주세요", 1, emailController),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget textField(String hint, String title, int size, TextEditingController controller) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormField(
            controller: controller,
            cursorColor: Colors.black54,
            maxLines: size,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.black54,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.black54,
              )),
            ),
          ),
        ),
      ],
    );
  }
}
