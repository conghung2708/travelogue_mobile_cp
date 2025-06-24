abstract class ReviewBase {
  final String id;
  final String userName;
  final String userAvatarUrl;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final int likes;
  final int dislikes;

  ReviewBase({
    required this.id,
    required this.userName,
    required this.userAvatarUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.likes,
    required this.dislikes,
  });

  ReviewBase copyWith({
    int? likes,
    int? dislikes,
  });
}
