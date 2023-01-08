class PostCardModel {
  final String userName, postCategory, postTitle, postText;

  PostCardModel({
    required this.userName,
    required this.postCategory,
    required this.postTitle,
    required this.postText,
  });

  PostCardModel.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        postTitle = json['postTitle'],
        postCategory = json['category'],
        postText = json['postText'];

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'postTitle': postTitle,
        'category': postCategory,
        'postText': postText,
      };
}
