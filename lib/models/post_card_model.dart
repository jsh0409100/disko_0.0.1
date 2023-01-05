class PostCardModel {
  final String userName, postCategory, postTitle, postText;

  PostCardModel.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        postTitle = json['postTitle'],
        postCategory = json['category'],
        postText = json['postText'];
}
