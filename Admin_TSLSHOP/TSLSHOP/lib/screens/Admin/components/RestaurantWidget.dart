import 'package:flutter/material.dart';
import 'package:food_delivery_admin/components/AppWidgets.dart';
import 'package:food_delivery_admin/main.dart';
import 'package:food_delivery_admin/models/RestaurantModel.dart';
import 'package:food_delivery_admin/screens/RestaurantManager/AddRestaurantDetailScreen.dart';
import 'package:food_delivery_admin/screens/RestaurantManager/MenuIListScreen.dart';
import 'package:food_delivery_admin/utils/Common.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:food_delivery_admin/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

class RestaurantWidget extends StatefulWidget {
  static String tag = '/RestaurantWidget';
  final RestaurantModel? data;
  final double? width;

  RestaurantWidget({this.data, this.width});

  @override
  RestaurantWidgetState createState() => RestaurantWidgetState();
}

class RestaurantWidgetState extends State<RestaurantWidget> {
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

  Future restDelete({bool? isDelete, String? restId}) async {
    appStore.setLoading(true);
    Map<String, dynamic> data = {
      RestaurantKey.isDeleted: isDelete,
      TimeDataKey.updatedAt: DateTime.now(),
    };
    await restaurantService.updateDocument(data, restId).then((value) async {
      //
    }).catchError((error) {
      toast(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MenuIListScreen(restaurantModel: widget.data).launch(context);
      },
      child: Container(
        width: context.isPhone()
            ? widget.width! / 1 - 16
            : context.isTablet()
                ? widget.width! / 3 - 16
                : widget.width! / 4 - 16,
        decoration: boxDecorationWithShadow(
          borderRadius: radius(),
          backgroundColor: context.cardColor,
          shadowColor: shadowColorGlobal,
          spreadRadius: defaultSpreadRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            cachedImage(
              widget.data!.photoUrl,
              height: 250,
              width: context.width(),
              fit: BoxFit.fill,
            ).cornerRadiusWithClipRRect(defaultRadius),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                4.height,
                Row(
                  children: [
                    Text('${widget.data!.restaurantName.validate()}', style: boldTextStyle()).expand(),
                    8.width,
                    Row(
                      children: [
                        vegNonVegIcon(color: Colors.green).visible(widget.data!.isVegRestaurant!),
                        4.width,
                        vegNonVegIcon(color: Colors.red).visible(widget.data!.isNonVegRestaurant!),
                      ],
                    )
                  ],
                ),
                8.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.pin_drop, size: 18, color: grey),
                    6.width,
                    Text('${widget.data!.restaurantAddress.validate().capitalizeFirstLetter()}', style: secondaryTextStyle(), maxLines: 2).expand(),
                  ],
                ),
                16.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.call, size: 18, color: grey),
                    12.width,
                    Text('${widget.data!.restaurantContact.validate().capitalizeFirstLetter()}', style: secondaryTextStyle()),
                  ],
                ),
              ],
            ).center().paddingAll(8),
            8.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.edit, size: 18, color: grey),
                    4.width,
                    Text(appStore.translate('edit'), style: secondaryTextStyle()),
                  ],
                ).onTap(() async {
                  AddRestaurantDetailScreen(restaurantModel: widget.data, isEdit: true).launch(context);
                }),
                12.width,
                // Text(!widget.data!.isDeleted! ? appStore.translate('active') : appStore.translate('inActive'), style: secondaryTextStyle(color: !widget.data!.isDeleted! ? Colors.green : Colors.red)).onTap(() async {
                //   bool? res = await showConfirmDialog(
                //     context,
                //     widget.data!.isDeleted! ? appStore.translate('active_restaurant') : appStore.translate('inactive_restaurant'),
                //     positiveText: appStore.translate('yes'),
                //     negativeText: appStore.translate('no'),
                //   );
                //
                //   widget.data!.isDeleted = !widget.data!.isDeleted!;
                //   if (getBoolAsync(IS_TESTER)) {
                //     return toast(appStore.translate('mTesterNotAllowedMsg'));
                //   } else {
                //     if (res ?? false) {
                //       restDelete(restId: widget.data!.id, isDelete: widget.data!.isDeleted);
                //     }
                //   }
                // }
                // ),
              ],
            ).paddingOnly(left: 8, bottom: 8, right: 8),
            16.height,
          ],
        ),
      ).paddingAll(8),
    );
  }
}
