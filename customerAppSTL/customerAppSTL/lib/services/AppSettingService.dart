import 'package:fooddelivery/models/AppSettingModel.dart';
import 'package:fooddelivery/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'BaseService.dart';

class AppSettingService extends BaseService {
  String? id;

  AppSettingService() {
    ref = db.collection('settings');
  }

  Future<AppSettingModel> getAppSettings() async {
    return await ref.get().then((value) async {
      if (value.docs.isNotEmpty) {
        id = value.docs.first.id;

        return AppSettingModel.fromJson(value.docs.first.data() as Map<String, dynamic>);
      } else {
        await setAppSettings();
        //throw errorSomethingWentWrong;

        AppSettingModel appSettingModel = AppSettingModel();

        //region Default values

        appSettingModel.termCondition = '';
        appSettingModel.privacyPolicy = '';
        appSettingModel.contactInfo = '';

        //endregion

        return appSettingModel;
      }
    }).catchError((e) {
      throw e;
    });
  }

  Future<void> setAppSettings() async {
    AppSettingModel appSettingModel = AppSettingModel();

    //region Default values

    appSettingModel.termCondition = '';
    appSettingModel.privacyPolicy = '';
    appSettingModel.contactInfo = '';

    //endregion

    await ref.get().then((value) async {
      if (value.docs.isNotEmpty) {
        appSettingModel = await ref.get().then((value) => AppSettingModel.fromJson(value.docs.first.data() as Map<String, dynamic>));
      } else {
        await addDocument(appSettingModel.toJson()).then((value) {
          id = value.id;
        });
      }

      await saveAppSettings(appSettingModel);

      LiveStream().emit(StreamRefresh, true);
    });
  }

  Future<void> saveAppSettings(AppSettingModel appSettingModel) async {
    await setValue(TERMS_AND_CONDITION_PREF, appSettingModel.termCondition.validate());
    await setValue(PRIVACY_POLICY_PREF, appSettingModel.privacyPolicy.validate());
    await setValue(CONTACT_PREF, appSettingModel.contactInfo.validate());
  }
}
