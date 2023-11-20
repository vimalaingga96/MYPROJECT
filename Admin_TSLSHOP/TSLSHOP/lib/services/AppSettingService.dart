import 'package:food_delivery_admin/models/AppSettingModel.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'BaseService.dart';

class AppSettingService extends BaseService {
  String? id;

  AppSettingService() {
    ref = db.collection('settings');
  }

  Future<AppSettingModel> getAppSettings() async {
    return await ref!.get().then((value) async {
      if (value.docs.isNotEmpty) {
        id = value.docs.first.id;

        return AppSettingModel.fromJson(value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw appStore.translate('something_went_wrong');
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<void> setAppSettings() async {
    AppSettingModel appSettingModel = AppSettingModel();

    appSettingModel.termCondition = '';
    appSettingModel.privacyPolicy = '';
    appSettingModel.contactInfo = '';
    //endregion

    await ref!.get().then((value) async {
      if (value.docs.isNotEmpty) {
        appSettingModel = await ref!.get().then((value) => AppSettingModel.fromJson(value.docs.first.data() as Map<String, dynamic>));
      }

      await saveAppSettings(appSettingModel);
    });
  }

  Future<void> saveAppSettings(AppSettingModel appSettingModel) async {
    await setValue(TERMS_AND_CONDITION_PREF, appSettingModel.termCondition.validate());
    await setValue(PRIVACY_POLICY_PREF, appSettingModel.privacyPolicy.validate());
    await setValue(CONTACT_PREF, appSettingModel.contactInfo.validate());
  }
}
