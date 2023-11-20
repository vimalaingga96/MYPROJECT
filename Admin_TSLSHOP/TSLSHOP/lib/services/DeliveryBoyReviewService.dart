import 'package:food_delivery_admin/main.dart';
import 'package:food_delivery_admin/models/DeliveryBoyReviewModel.dart';
import 'package:food_delivery_admin/services/BaseService.dart';
import 'package:food_delivery_admin/utils/ModelKeys.dart';

class DeliveryBoyReviewService extends BaseService {
  DeliveryBoyReviewService() {
    ref = db.collection(Collect.deliveryBoyReviews);
  }

  Stream<List<DeliveryBoyReviewModel>> getDeliveryBoyReviews() {
    return ref!.snapshots().map((event) => event.docs.map((e) => DeliveryBoyReviewModel.fromJson(e.data() as Map<String, dynamic>)).toList());
  }
}
