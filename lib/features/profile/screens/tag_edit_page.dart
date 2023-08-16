// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:disko_001/common/utils/utils.dart';
// import 'package:disko_001/features/auth/controller/auth_controller.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
// import 'package:get/get.dart';
//
// import '../../../models/user_model.dart';
// import '../cotroller/profile_controller.dart';
//
//
// class TagEditPage extends ConsumerStatefulWidget {
//   final String displayName, country, description, imageURL;
//   final List<String> tag, follow;
//
//   const TagEditPage({
//     Key? key,
//     required this.displayName,
//     required this.country,
//     required this.description,
//     required this.imageURL,
//     required this.tag,
//     required this.follow,
//   }) : super(key: key);
//
//   @override
//   ConsumerState<TagEditPage> createState() => _TagEditPageState();
// }
//
// class _TagEditPageState extends ConsumerState<TagEditPage> {
//
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   CollectionReference user = FirebaseFirestore.instance.collection("users");
//   final TextEditingController ImojiController = TextEditingController();
//   final TextEditingController tagController = TextEditingController();
//   bool isShowSticker = false;
//   String selectedEmoji = '';
//
//   @override
//   void initState(){
//     super.initState();
//     isShowSticker = false;
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     ImojiController.dispose();
//     tagController.dispose();
//   }
//
//   Future<bool> onBackPress(){
//     if(isShowSticker){
//       setState(() {
//         isShowSticker = false;
//       });
//     } else {
//       Navigator.pop(context);
//     }
//      return Future.value(false);
//   }
//
//
//   void storeUserData() async {
//
//     File? image;
//
//     if (widget.displayName.isNotEmpty) {
//       ref.read(authControllerProvider).saveProfileDataToFirebase(
//         context,
//         widget.displayName,
//         image,
//         widget.country,
//         widget.tag,
//         widget.description,
//         widget.follow,
//       );
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("키워드 선택하기"),
//       ),
//       body: SingleChildScrollView(
//         child: WillPopScope(
//           onWillPop: onBackPress,
//           child: Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("새로 추가할 키워드를 입력해보세요."),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Row(
//                   children: [
//                     Container(
//                       width: 200,
//                       child: TextField(
//                         controller: tagController,
//                         decoration: InputDecoration(
//                           prefixIcon: IconButton(
//                             icon: selectedEmoji == '' ? const Icon(Icons.add) : Text(selectedEmoji),
//                             onPressed: (){
//                               setState((){
//                                 isShowSticker = !isShowSticker;
//                               });
//                             }
//                           ),
//                           enabledBorder: const OutlineInputBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(20)),
//                             borderSide: BorderSide(color: Colors.blue),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 20),
//                     ElevatedButton(
//                         onPressed: () async {
//                             DocumentSnapshot documentSnapshot = await user.doc(auth.currentUser?.uid).get();
//                             List<String> currentArray = List.from(documentSnapshot.get("tag") as List<dynamic>);
//                             if(tagController.text.isNotEmpty) {
//                               currentArray.add(selectedEmoji + " " + tagController.text);
//                             }
//                             await user.doc(auth.currentUser?.uid).update({"tag": currentArray});
//                           },
//                         child: Text("추가"),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height : 50),
//                 Text("현재 키워드"),
//                 SizedBox(height : 20),
//                 StreamBuilder<UserModel>(
//                   stream: getUserStreamByUid(auth.currentUser!.uid),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       return Wrap(
//                         key: UniqueKey(),
//                         spacing: MediaQuery.of(context).size.width * 0.03,
//                         runSpacing: MediaQuery.of(context).size.width * 0.001,
//                         children: List.generate(widget.tag.length, (index) {
//                           return mChip(widget.tag[index]);
//                         }),
//                       );
//                     } else {
//                       return SizedBox(height: 1);
//                     }
//                   },
//                 ),
//
//                 (isShowSticker ? buildSticker() : Container()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   Widget buildSticker(){
//     return Container(
//       height: 280,
//       child: EmojiPicker(
//         onEmojiSelected: (category, emoji){
//           setState(() {
//             selectedEmoji = emoji.emoji.toString();
//           });
//         },
//         config: const Config(
//           columns: 7,
//           buttonMode: ButtonMode.MATERIAL,
//         ),
//       ),
//     );
//   }
//
//   Widget mChip(String text) {
//     return Chip(
//       label: Text(text),
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//         side: const BorderSide(
//           color: Colors.black,
//           width: 1,
//         ),
//       ),
//     );
//   }
//
// }
