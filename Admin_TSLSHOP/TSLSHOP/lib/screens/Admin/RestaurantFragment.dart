import 'package:flutter/material.dart';
import 'package:food_delivery_admin/main.dart';
import 'package:food_delivery_admin/models/RestaurantModel.dart';
import 'package:food_delivery_admin/screens/RestaurantManager/AddRestaurantDetailScreen.dart';
import 'package:food_delivery_admin/services/RestaurantService.dart';
import 'package:food_delivery_admin/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

import 'components/RestaurantWidget.dart';

class RestaurantFragment extends StatefulWidget {
  static String tag = '/RestaurantFragment';

  @override
  RestaurantFragmentState createState() => RestaurantFragmentState();
}

class RestaurantFragmentState extends State<RestaurantFragment> {
  RestaurantService restaurantService = RestaurantService();
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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(appStore.translate('restaurants'), showBack: false, elevation: 0),
      body: StreamBuilder<List<RestaurantModel>>(
        stream: restaurantService.getAllRestaurants(),
        builder: (_, snap) {
          if (snap.hasData) {
            return SingleChildScrollView(
              controller: controller,
              padding: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 70),
              child: LayoutBuilder(builder: (context, constrain) {
                return Wrap(
                  children: snap.data!.map((e) {
                    return RestaurantWidget(data: e, width: constrain.maxWidth);
                  }).toList(),
                );
              }),
            );
          } else {
            return snapWidgetHelper(snap);
          }
        },
      ),
      floatingActionButton: Container(
        height: 50,
        width: 185,
        color: colorPrimary,
        padding: EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: white),
            4.width,
            Text(appStore.translate('add_restaurant'), style: boldTextStyle(color: white)),
          ],
        ),
      ).cornerRadiusWithClipRRect(defaultRadius).onTap(() {
        AddRestaurantDetailScreen().launch(context);
      }),
    );
  }
}
