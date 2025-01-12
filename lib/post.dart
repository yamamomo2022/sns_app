class Post {
  String id;
  String text;
  DateTime? createAt;
  DateTime? updateAt;

  Post({
    required this.id,
    required this.text,
    required this.createAt,
    required this.updateAt,
  });
}
