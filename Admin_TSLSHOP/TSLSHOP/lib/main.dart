import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:food_delivery_admin/AppLocalizations.dart';
import 'package:food_delivery_admin/screens/SplashScreen.dart';
import 'package:food_delivery_admin/services/AppSettingService.dart';
import 'package:food_delivery_admin/services/AuthService.dart';
import 'package:food_delivery_admin/services/CategoryService.dart';
import 'package:food_delivery_admin/services/DeliveryBoyReviewService.dart';
import 'package:food_delivery_admin/services/MenuItemService.dart';
import 'package:food_delivery_admin/services/OrderService.dart';
import 'package:food_delivery_admin/services/RestaurantService.dart';
import 'package:food_delivery_admin/services/ReviewService.dart';
import 'package:food_delivery_admin/services/UserService.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_strategy/url_strategy.dart';

import 'AppTheme.dart';
import 'firebase_options.dart';
import 'store/AppStore.dart';

AppStore appStore = AppStore();
FirebaseFirestore db = FirebaseFirestore.instance;

AuthService service = AuthService();
UserService userService = UserService();
CategoryService categoryService = CategoryService();
OrderService orderService = OrderService();
RestaurantService restaurantService = RestaurantService();
MenuItemService menuItemService = MenuItemService();
ReviewService reviewService = ReviewService();
DeliveryBoyReviewService deliveryBoyReviewService = DeliveryBoyReviewService();
AppSettingService appSettingService = AppSettingService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setPathUrlStrategy();

  defaultSpreadRadius = 3;
  await initialize(aLocaleLanguageList: [
    LanguageDataModel(
        id: 1,
        name: 'English',
        languageCode: 'en',
        flag: 'images/flag/ic_us.png'),
    LanguageDataModel(
        id: 2,
        name: 'Hindi',
        languageCode: 'hi',
        flag: 'images/flag/ic_india.png'),
    LanguageDataModel(
        id: 3,
        name: 'Arabic',
        languageCode: 'ar',
        flag: 'images/flag/ic_ar.png'),
    LanguageDataModel(
        id: 4,
        name: 'Spanish',
        languageCode: 'es',
        flag: 'images/flag/ic_spain.png'),
    LanguageDataModel(
        id: 5,
        name: 'Afrikaans',
        languageCode: 'af',
        flag: 'images/flag/ic_south_africa.png'),
    LanguageDataModel(
        id: 6,
        name: 'French',
        languageCode: 'fr',
        flag: 'images/flag/ic_france.png'),
    LanguageDataModel(
        id: 7,
        name: 'German',
        languageCode: 'de',
        flag: 'images/flag/ic_germany.png'),
    LanguageDataModel(
        id: 8,
        name: 'Indonesian',
        languageCode: 'id',
        flag: 'images/flag/ic_indonesia.png'),
    LanguageDataModel(
        id: 9,
        name: 'Portuguese',
        languageCode: 'pt',
        flag: 'images/flag/ic_portugal.png'),
    LanguageDataModel(
        id: 10,
        name: 'Turkish',
        languageCode: 'tr',
        flag: 'images/flag/ic_turkey.png'),
    LanguageDataModel(
        id: 11,
        name: 'vietnam',
        languageCode: 'vi',
        flag: 'images/flag/ic_vitnam.png'),
    LanguageDataModel(
        id: 12,
        name: 'Dutch',
        languageCode: 'nl',
        flag: 'images/flag/ic_dutch.png'),
  ]);

  int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
  if (themeModeIndex == ThemeModeLight) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == ThemeModeDark) {
    appStore.setDarkMode(true);
  }

  selectedLanguageDataModel = getSelectedLanguageModel();
  if (selectedLanguageDataModel != null) {
    appStore.setLanguage(selectedLanguageDataModel!.languageCode.validate());
  } else {
    selectedLanguageDataModel = localeLanguageList.first;
    appStore.setLanguage(selectedLanguageDataModel!.languageCode.validate());
  }
  await Firebase.initializeApp(
      //  options: DefaultFirebaseOptions.currentPlatform,
      );
  // await Firebase.initializeApp(
  //   options: FirebaseOptions(
  //     apiKey: "AIzaSyBfBEJDgc3aTQsK7TTZBYkeyI2ZLeLpwU0",
  //     appId: "1:398951068879:web:660da4f9677a627991f3ba",
  //     messagingSenderId: "398951068879",
  //     projectId: "food-delivery-4e11c",
  //   ),
  // );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      ),
    );
  }
}
