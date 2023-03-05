class ChipModel {
  final List<String> tag;

  ChipModel({
    required this.tag,
  });

  ChipModel.fromJson(Map<String, dynamic> json)
    :tag = json['tag'].cast<String>();

  Map<String, dynamic> toJson() => {
    'tag': tag,
  };
}