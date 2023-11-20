import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery_admin/components/AppWidgets.dart';
import 'package:food_delivery_admin/components/ThemeSelectionDialog.dart';
import 'package:food_delivery_admin/models/AppSettingModel.dart';
import 'package:food_delivery_admin/utils/Colors.dart';
import 'package:food_delivery_admin/utils/Common.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class SettingFragment extends StatefulWidget {
  static String tag = '/AdminSettingScreen';

  @override
  _SettingFragmentState createState() => _SettingFragmentState();
}

class _SettingFragmentState extends State<SettingFragment> {
  TextEditingController termConditionCont = TextEditingController();
  TextEditingController privacyPolicyCont = TextEditingController();
  TextEditingController contactInfoCont = TextEditingController();
  TextEditingController flutterWebBuildVersionCont = TextEditingController();

  bool? disableAd = false;

  String termCondition = '';
  String privacyPolicy = '';
  String contactInfo = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    appStore.setLoading(true);

    await appSettingService.getAppSettings().then((value) async {
      disableAd = value.disableAd.validate();
      termConditionCont.text = value.termCondition!;
      privacyPolicyCont.text = value.privacyPolicy!;
      contactInfoCont.text = value.contactInfo!;
      setState(() {});
    });

    appStore.setLoading(false);
  }

  Future<void> saveData() async {
    // if (appStore.isTester) return toast(appStore.translate('mTesterNotAllowedMsg'));

    appStore.setLoading(true);

    AppSettingModel appSettingModel = AppSettingModel();

    appSettingModel.disableAd = disableAd;

    appSettingModel.termCondition = termConditionCont.text.trim();
    appSettingModel.privacyPolicy = privacyPolicyCont.text.trim();
    appSettingModel.contactInfo = contactInfoCont.text.trim();
    appSettingModel.disableAd = disableAd;

    await appSettingService.updateDocument(appSettingModel.toJson(), appSettingService.id).then((value) async {
      await appSettingService.saveAppSettings(appSettingModel);

      toast(appStore.translate('save_successfully'));
    }).catchError((e) {
      e.toString().toastString();
    });

    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    appStore.setAppLocalization(context);

    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(appStore.translate('setting'), showBack: false, elevation: 0),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SettingItemWidget(
                        leading: Icon(MaterialCommunityIcons.theme_light_dark),
                        title: appStore.translate('select_theme'),
                        titleTextStyle: primaryTextStyle(),
                        subTitle: themeModeList[getIntAsync(THEME_MODE_INDEX)],
                        onTap: () async {
                          await showInDialog(
                            context,
                            child: ThemeSelectionDialog(),
                            contentPadding: EdgeInsets.zero,
                            title: Text(appStore.translate('select_theme'), style: primaryTextStyle(size: 20)),
                          );
                          setStatusBarColor(
                            appStore.isDarkMode ? scaffoldColorDark : white,
                            statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
                            delayInMilliSeconds: 100,
                          );
                          setState(() {});
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(appStore.translate('app_lang'), style: boldTextStyle()),
                          LanguageListWidget(
                            widgetType: WidgetType.DROPDOWN,
                            onLanguageChange: (val) async {
                              appStore.setLanguage(val.languageCode.validate());
                              await setValue(SELECTED_LANGUAGE_CODE, val.languageCode);
                              setState(() {});
                            },
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                      Column(
                        children: [
                          AppTextField(
                            controller: termConditionCont,
                            textFieldType: TextFieldType.NAME,
                            decoration: inputDecoration(
                              labelText: appStore.translate('term_condition'),
                            ),
                          ).paddingAll(16),
                          AppTextField(
                            controller: privacyPolicyCont,
                            textFieldType: TextFieldType.NAME,
                            decoration: inputDecoration(
                              labelText: appStore.translate('privacy_policy'),
                            ),
                          ).paddingAll(16),
                          AppTextField(
                            controller: contactInfoCont,
                            textFieldType: TextFieldType.NAME,
                            decoration: inputDecoration(
                              labelText: appStore.translate('contact_info'),
                            ),
                          ).paddingAll(16),
                          Row(
                            children: [
                              Checkbox(
                                  value: disableAd,
                                  onChanged: (val) {
                                    disableAd = !disableAd!;
                                    setState(() {});
                                  }),
                              16.width,
                              Text(appStore.translate('disable_admob'), style: primaryTextStyle())
                            ],
                          ).paddingAll(16).onTap(() {
                            disableAd = !disableAd!;
                            setState(() {});
                          }),
                          AppButton(
                            text: appStore.translate('save'),
                            textStyle: primaryTextStyle(color: white),
                            color: colorPrimary,
                            onTap: () {
                              if (getBoolAsync(IS_TESTER)) {
                                toast(appStore.translate('mTesterNotAllowedMsg'));
                              } else {
                                saveData();
                              }
                            },
                            height: 60,
                            width: context.width(),
                          ).paddingAll(16),
                        ],
                      ).visible(getBoolAsync(IS_ADMIN)),
                    ],
                  ).expand(),
                  Container(
                    child: cachedImage('images/setting_img.png', height: context.height() * 0.75, fit: BoxFit.cover),
                  ).expand().visible(getBoolAsync(IS_ADMIN)),
                ],
              ),
            ),
            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
