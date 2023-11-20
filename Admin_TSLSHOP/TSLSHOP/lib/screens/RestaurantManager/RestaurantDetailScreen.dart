import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery_admin/components/AppWidgets.dart';
import 'package:food_delivery_admin/models/RestaurantModel.dart';
import 'package:food_delivery_admin/utils/Colors.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import 'AddRestaurantDetailScreen.dart';

class RestaurantDetailScreen extends StatefulWidget {
  static String tag = '/RestaurantDetailScreen';

  @override
  RestaurantDetailScreenState createState() => RestaurantDetailScreenState();
}

class RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  RestaurantModel? restModel = RestaurantModel();

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
      appBar: appBarWidget(
        'Shop Details',
        showBack: false,
        elevation: 0,
        actions: [
          Icon(Icons.edit_outlined, color: colorPrimary)
              .onTap(() async {
                await AddRestaurantDetailScreen(restaurantModel: restModel).launch(context);
                setState(() {});
              })
              .paddingRight(16)
              .visible(restModel != null)
        ],
      ),
      body: Container(
        child: FutureBuilder<RestaurantModel>(
          future: restaurantService.getRestaurantDetails(ownerId: getStringAsync(USER_ID), isDeleted: false),
          builder: (context, snap) {
            if (snap.hasData) {
              if (snap.data == null) {
                return Text(appStore.translate('no_data_found'), style: primaryTextStyle());
              }
              restModel = snap.data;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cachedImage(restModel!.photoUrl.validate(), fit: BoxFit.cover, width: 150, height: 150).cornerRadiusWithClipRRect(100).paddingAll(16),
                    Divider(),
                    detailItemWidget(title: appStore.translate('name'), data: restModel!.restaurantName),
                    detailItemWidget(title: appStore.translate('email'), data: restModel!.restaurantEmail),
                    detailItemWidget(title: appStore.translate('contact'), data: restModel!.restaurantContact),
                    detailItemWidget(title: appStore.translate('description'), data: restModel!.restaurantDesc),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          child: Text(appStore.translate('categories'), style: secondaryTextStyle(), textAlign: TextAlign.justify, overflow: TextOverflow.ellipsis),
                        ),
                        32.width,
                        Row(
                          children: restModel!.catList!.map((e) => Text(e.validate(), style: primaryTextStyle()).paddingRight(8)).toList(),
                        ),
                      ],
                    ).paddingAll(16),
                    Row(
                      children: [
                        Container(
                          width: 150,
                          child: Text(appStore.translate('food_type'), style: secondaryTextStyle(), textAlign: TextAlign.justify, overflow: TextOverflow.ellipsis),
                        ),
                        32.width,
                        Container(
                          decoration: boxDecorationWithRoundedCorners(border: Border.all(color: Colors.red), borderRadius: BorderRadius.circular(4)),
                          child: Icon(Octicons.primitive_dot, size: 20, color: Colors.red),
                        ).paddingRight(16).visible(restModel!.isNonVegRestaurant!),
                        Container(
                          decoration: boxDecorationWithRoundedCorners(border: Border.all(color: Colors.green), borderRadius: BorderRadius.circular(4)),
                          child: Icon(Octicons.primitive_dot, size: 20, color: Colors.green).center(),
                        ).visible(restModel!.isVegRestaurant!),
                      ],
                    ).paddingAll(16),
                  ],
                ),
              );
            }
            return snapWidgetHelper(snap);
          },
        ),
      ),
    );
  }

  Widget detailItemWidget({String? title, String? data, Widget? widget}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 150,
          child: Text(title.validate(), style: secondaryTextStyle(), textAlign: TextAlign.justify, overflow: TextOverflow.ellipsis),
        ),
        32.width,
        Text(data.validate(), style: primaryTextStyle(), textAlign: TextAlign.justify).expand(),
      ],
    ).paddingAll(16);
  }
}
