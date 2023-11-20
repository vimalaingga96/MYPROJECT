import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_admin/AppLocalizations.dart';
import 'package:food_delivery_admin/main.dart';
import 'package:food_delivery_admin/utils/Colors.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'AppStore.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  bool isLoggedIn = false;

  @observable
  bool isAdmin = false;

  @observable
  bool isDarkMode = false;

  @observable
  bool isLoading = false;

  @observable
  String userProfileImage = '';

  @observable
  String userFullName = '';

  @observable
  String userEmail = '';

  @observable
  String userId = '';

  @observable
  String selectedLanguage = defaultLanguage;

  @observable
  AppBarTheme appBarTheme = AppBarTheme();

  @observable
  AppLocalizations? appLocale;

  @action
  void setAppLocalization(BuildContext context) {
    appLocale = AppLocalizations.of(context);
  }

  String translate(String key) {
    return appLocale!.translate(key);
  }

  @action
  void setLanguage(String val) {
    selectedLanguage = val;
  }

  @action
  void setUserProfile(String image) {
    userProfileImage = image;
  }

  @action
  void setUserId(String val) {
    userId = val;
  }

  @action
  void setUserEmail(String email) {
    userEmail = email;
  }

  @action
  void setFullName(String name) {
    userFullName = name;
  }

  @action
  Future<void> setLoggedIn(bool val) async {
    isLoggedIn = val;
    await setValue(IS_LOGGED_IN, val);
  }

  @action
  void setLoading(bool val, {String? toastMsg}) {
    isLoading = val;

    if (toastMsg != null) {
      log(toastMsg);
      toast(toastMsg);
    }
  }

  @action
  void setAdmin(bool val) {
    isAdmin = val;
  }

  @action
  Future<void> setDarkMode(bool aIsDarkMode) async {
    isDarkMode = aIsDarkMode;

    if (isDarkMode) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = scaffoldSecondaryDark;
      appButtonBackgroundColorGlobal = appButtonColorDark;
      shadowColorGlobal = Colors.white12;

      appBarBackgroundColorGlobal = scaffoldSecondaryDark;
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = Colors.white;
      shadowColorGlobal = Colors.black12;

      appBarBackgroundColorGlobal = Colors.white;
    }
    appBarTheme = AppBarTheme(
      brightness: appStore.isDarkMode ? Brightness.dark : Brightness.light,
      systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: appStore.isDarkMode ? Brightness.dark : Brightness.light),
    );
  }
}
