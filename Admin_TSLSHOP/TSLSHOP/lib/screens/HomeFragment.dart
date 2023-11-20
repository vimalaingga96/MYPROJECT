import 'package:flutter/material.dart';
import 'package:food_delivery_admin/components/AppWidgets.dart';
import 'package:food_delivery_admin/screens/Admin/components/AdminHomeWidget.dart';
import 'package:food_delivery_admin/screens/RestaurantManager/component/RestaurantManagerHomeWidget.dart';
import 'package:food_delivery_admin/utils/Colors.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class HomeFragment extends StatefulWidget {
  static String tag = '/HomeFragment';

  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends State<HomeFragment> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.isDesktop()
          ? AppBar(
              toolbarHeight: 80,
              title: Text(appStore.translate('dashboard'), style: boldTextStyle(size: 22)),
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                PopupMenuButton(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      cachedImage(getStringAsync(USER_IMAGE), height: 50, width: 50, fit: BoxFit.cover).cornerRadiusWithClipRRect(60),
                      8.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(getStringAsync(USER_NAME), style: boldTextStyle(size: 18)),
                          Text(getStringAsync(USER_EMAIL), style: secondaryTextStyle(size: 12)),
                        ],
                      )
                    ],
                  ).paddingRight(16).visible(context.isDesktop()),
                  onSelected: (dynamic value) {
                    if (value == 0) {
                      showInDialog(
                        context,
                        child: Text(appStore.translate('do_you_want_to_logout'), style: primaryTextStyle()),
                        actions: [
                          TextButton(
                            onPressed: () {
                              finish(context);
                            },
                            child: Text(appStore.translate('cancel'), style: primaryTextStyle()),
                          ),
                          4.width,
                          TextButton(
                            onPressed: () async {
                              service.signOutFromEmailPassword(context);
                              finish(context);
                            },
                            child: Text(appStore.translate('logout'), style: primaryTextStyle(color: colorPrimary)),
                          ),
                          4.width
                        ],
                      );
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Image.asset('images/ic_logout.png', height: 24, width: 24),
                            8.width,
                            Text(appStore.translate('logout'), style: primaryTextStyle()),
                          ],
                        ),
                        value: 0,
                      ),
                    ];
                  },
                )
              ],
            )
          : null,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        controller: controller,
        child: getBoolAsync(IS_ADMIN) ? AdminHomeWidget() : RestaurantManagerHomeWidget(),
      ),
    );
  }
}
