import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fooddelivery/AppLocalizations.dart';
import 'package:fooddelivery/services/AppSettingService.dart';
import 'package:fooddelivery/services/CategoryDBService.dart';
import 'package:fooddelivery/services/FoodItemDBService.dart';
import 'package:fooddelivery/services/MyCartService.dart';
import 'package:fooddelivery/services/MyOrderDBService.dart';
import 'package:fooddelivery/services/RestaurantDBService.dart';
import 'package:fooddelivery/services/UserDBService.dart';
import 'package:fooddelivery/store/AppStore.dart';
import 'package:fooddelivery/utils/Colors.dart';
import 'package:fooddelivery/utils/Common.dart';
import 'package:fooddelivery/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'AppTheme.dart';
import 'screens/SplashScreen.dart';
import 'utils/Constants.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

MyCartDBService myCartDBService = MyCartDBService();
UserDBService userDBService = UserDBService();
CategoryDBService categoryDBService = CategoryDBService();
MyOrderDBService myOrderDBService = MyOrderDBService();
RestaurantDBService restaurantDBService = RestaurantDBService();
AppSettingService appSettingService = AppSettingService();
FoodItemDBService foodItemDBService = FoodItemDBService();

AppStore appStore = AppStore();

String? restaurantName = '';
String? restaurantId = '';

List<String?> favRestaurantList = [];

String userAddressGlobal = '';
String? userCityNameGlobal = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initMethod();

  runApp(MyApp());
}

Future<void> initMethod() async {
  await initialize(aLocaleLanguageList: [
    LanguageDataModel(
        id: 1,
        name: 'English',
        languageCode: 'en',
        flag: 'assets/flag/ic_us.png'),
    LanguageDataModel(
        id: 2,
        name: 'Hindi',
        languageCode: 'hi',
        flag: 'assets/flag/ic_india.png'),
    LanguageDataModel(
        id: 3,
        name: 'Arabic',
        languageCode: 'ar',
        flag: 'assets/flag/ic_ar.png'),
    LanguageDataModel(
        id: 4,
        name: 'Spanish',
        languageCode: 'es',
        flag: 'assets/flag/ic_spain.png'),
    LanguageDataModel(
        id: 5,
        name: 'Afrikaans',
        languageCode: 'af',
        flag: 'assets/flag/ic_south_africa.png'),
    LanguageDataModel(
        id: 6,
        name: 'French',
        languageCode: 'fr',
        flag: 'assets/flag/ic_france.png'),
    LanguageDataModel(
        id: 7,
        name: 'German',
        languageCode: 'de',
        flag: 'assets/flag/ic_germany.png'),
    LanguageDataModel(
        id: 8,
        name: 'Indonesian',
        languageCode: 'id',
        flag: 'assets/flag/ic_indonesia.png'),
    LanguageDataModel(
        id: 9,
        name: 'Portuguese',
        languageCode: 'pt',
        flag: 'assets/flag/ic_portugal.png'),
    LanguageDataModel(
        id: 10,
        name: 'Turkish',
        languageCode: 'tr',
        flag: 'assets/flag/ic_turkey.png'),
    LanguageDataModel(
        id: 11,
        name: 'vietnam',
        languageCode: 'vi',
        flag: 'assets/flag/ic_vitnam.png'),
    LanguageDataModel(
        id: 12,
        name: 'Dutch',
        languageCode: 'nl',
        flag: 'assets/flag/ic_dutch.png'),
  ]);
  defaultLoaderAccentColorGlobal = colorPrimary;

  selectedLanguageDataModel =
      getSelectedLanguageModel(defaultLanguage: defaultLanguage);
  if (selectedLanguageDataModel != null) {
    appStore.setLanguage(selectedLanguageDataModel!.languageCode.validate());
  } else {
    selectedLanguageDataModel = localeLanguageList.first;
    appStore.setLanguage(selectedLanguageDataModel!.languageCode.validate());
  }

  if (isMobile) {
    await Firebase.initializeApp();

    await OneSignal.shared.setAppId(mOneSignalAppId);

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      event.complete(event.notification);
    });

    saveOneSignalPlayerId();
  }

  appStore.setDarkMode(appStore.isDarkMode);
  appStore
      .setNotification(getBoolAsync(IS_NOTIFICATION_ON, defaultValue: true));

  appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));
  if (appStore.isLoggedIn) {
    appStore.setUserId(getStringAsync(USER_ID));
    appStore.setAdmin(getBoolAsync(ADMIN));
    appStore.setFullName(getStringAsync(USER_DISPLAY_NAME));
    appStore.setUserEmail(getStringAsync(USER_EMAIL));
    appStore.setUserProfile(getStringAsync(USER_PHOTO_URL));

    myCartDBService = MyCartDBService();
  }

  int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
  if (themeModeIndex == ThemeModeLight) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == ThemeModeDark) {
    appStore.setDarkMode(true);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setOrientationPortrait();

    return Observer(
      builder: (_) => MaterialApp(
        title: mAppName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        locale: Locale(appStore.selectedLanguage),
        supportedLocales: LanguageDataModel.languageLocales(),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        home: SplashScreen(),
        builder: scrollBehaviour(),
      ),
    );
  }
}
