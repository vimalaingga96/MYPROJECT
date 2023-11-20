import 'package:food_delivery_admin/main.dart';
import 'package:food_delivery_admin/models/MenuModel.dart';
import 'package:food_delivery_admin/services/BaseService.dart';
import 'package:food_delivery_admin/utils/ModelKeys.dart';

class MenuItemService extends BaseService {
  MenuItemService() {
    ref = db.collection(Collect.menu);
  }

  Stream<List<MenuModel>> getMenuData({String? restId}) {
    return ref!.where(MenuItemKey.restaurantId, isEqualTo: restId).snapshots().map((event) => event.docs.map((e) => MenuModel.fromJson(e.data() as Map<String, dynamic>)).toList());
  }
}
