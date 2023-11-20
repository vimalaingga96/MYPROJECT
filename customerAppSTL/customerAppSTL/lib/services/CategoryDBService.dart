import 'package:fooddelivery/models/CategoryModel.dart';
import 'package:fooddelivery/services/BaseService.dart';
import 'package:fooddelivery/utils/Constants.dart';
import 'package:fooddelivery/utils/ModalKeys.dart';

import '../main.dart';

class CategoryDBService extends BaseService {
  CategoryDBService() {
    ref = db.collection(CATEGORIES);
  }

  Stream<List<CategoryModel>> categories({String searchText = '', isDeleted = false}) {
    return searchText.isNotEmpty
        ? ref.where(RestaurantKeys.caseSearch, arrayContains: searchText.toLowerCase()) as Stream<List<CategoryModel>>
        : ref.where(CommonKeys.isDeleted, isEqualTo: false).snapshots().map((x) => x.docs.map((y) => CategoryModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }
}
