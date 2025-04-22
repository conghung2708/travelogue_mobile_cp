abstract class ReviewBase {
  String get userName;
  String get userAvatarUrl;
  int get rating;
  String get comment;
  DateTime get createdAt;
  int get likes;
  set likes(int value);

  int get dislikes;
  set dislikes(int value);
}
