import 'package:food_delivery_admin/models/ReviewModel.dart';
import 'package:food_delivery_admin/utils/ModelKeys.dart';

import '../main.dart';
import 'BaseService.dart';

class ReviewService extends BaseService {
  ReviewService() {
    ref = db.collection(Collect.reviews);
  }

  Stream<List<ReviewModel>> getReviews() {
    return ref!.snapshots().map((event) => event.docs.map((e) => ReviewModel.fromJson(e.data() as Map<String, dynamic>)).toList());
  }
}
