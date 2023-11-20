import 'package:food_delivery_admin/main.dart';
import 'package:food_delivery_admin/models/RestaurantModel.dart';
import 'package:food_delivery_admin/services/BaseService.dart';
import 'package:food_delivery_admin/utils/ModelKeys.dart';

class RestaurantService extends BaseService {
  RestaurantService() {
    ref = db.collection(Collect.restaurants);
  }

  Stream<List<RestaurantModel>> getAllRestaurants() {
    return ref!.orderBy(RestaurantKey.isDeleted, descending: false).snapshots().map((event) => event.docs.map((e) => RestaurantModel.fromJson(e.data() as Map<String, dynamic>)).toList());
  }

  Future<RestaurantModel> getRestaurantDetails({String? ownerId, bool isDeleted = false}) async {
    return await ref!.where(RestaurantKey.ownerId, isEqualTo: ownerId).where(RestaurantKey.isDeleted, isEqualTo: isDeleted).get().then(
      (value) {
        if (value.docs.isNotEmpty) {
          return RestaurantModel.fromJson(value.docs.first.data() as Map<String, dynamic>);
        } else {
          throw 'Data not found';
        }
      },
    );
  }
}
