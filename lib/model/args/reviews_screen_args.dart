import 'package:travelogue_mobile/model/review_base_model.dart';

class ReviewsScreenArgs<T extends ReviewBase> {
  final List<T> reviews;
  final double averageRating;

  ReviewsScreenArgs({
    required this.reviews,
    required this.averageRating,
  });
}
