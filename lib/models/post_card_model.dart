class PostCardModel {
  final String userName, postCategory, postTitle, postText, postTimeStamp;

  PostCardModel({
    required this.postTimeStamp,
    required this.userName,
    required this.postCategory,
    required this.postTitle,
    required this.postText,
    //required this.postImage
  });

  PostCardModel.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        postTitle = json['postTitle'],
        postCategory = json['category'],
        postText = json['postText'],
        postTimeStamp = json['postTimeStamp'];
        //postImage = json['postImage'];

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'postTitle': postTitle,
        'category': postCategory,
        'postText': postText,
        'postTimeStamp': postTimeStamp,
        //'postImage' : postImage
      };
}
