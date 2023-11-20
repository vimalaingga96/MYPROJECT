import 'package:flutter/material.dart';
import 'package:food_delivery_admin/main.dart';
import 'package:food_delivery_admin/screens/DashboardScreen.dart';
import 'package:food_delivery_admin/screens/SignInScreen.dart';
import 'package:food_delivery_admin/utils/Colors.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await 2.seconds.delay;
    if (getBoolAsync(IS_LOGGED_IN)) {
      DashboardScreen().launch(context, isNewTask: true);
    } else {
      SignInScreen().launch(context, isNewTask: true);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    appStore.setAppLocalization(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/logo.png', height: 150, fit: BoxFit.cover),
          8.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('TSL',
                  style:
                  boldTextStyle(color: colorPrimary, size: 24)),
              2.width,
              Text('Shop', style: boldTextStyle(size: 24)),
              2.width,
              Text('Admin', style: boldTextStyle(size: 24)),
            ],
          ),
        ],
      ).center(),
    );
  }
}
