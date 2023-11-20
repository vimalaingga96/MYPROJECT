import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/models/RestaurantModel.dart';
import 'package:fooddelivery/screens/RestaurantMenuScreen.dart';
import 'package:fooddelivery/services/RestaurantReviewDBService.dart';
import 'package:fooddelivery/utils/Colors.dart';
import 'package:fooddelivery/utils/Common.dart';
import 'package:fooddelivery/utils/Images.dart';
import 'package:nb_utils/nb_utils.dart';

class RestaurantItemComponent extends StatefulWidget {
  final RestaurantModel? restaurant;
  final String? tag;

  RestaurantItemComponent({this.restaurant, this.tag});

  @override
  RestaurantItemComponentState createState() => RestaurantItemComponentState();
}

class RestaurantItemComponentState extends State<RestaurantItemComponent> {
  RestaurantReviewsDBService? restaurantReviewsDBService;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await 1.microseconds.delay;

    restaurantReviewsDBService = RestaurantReviewsDBService(widget.restaurant!.id);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      width: context.width(),
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: context.scaffoldBackgroundColor,
        boxShadow: defaultBoxShadow(spreadRadius: 0.0, blurRadius: 0.0),
        border: Border.all(color: context.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              cachedImage(
                widget.restaurant!.photoUrl.validate(),
                height: 180,
                width: context.width(),
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRectOnly(topLeft: 8, topRight: 8),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.restaurant!.restaurantName.validate(), style: boldTextStyle(size: 20)),
              Text(
                widget.restaurant!.restaurantAddress.validate(),
                style: secondaryTextStyle(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ).paddingAll(8),
          Container(
            width: context.width(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset(ic_shield, height: 20, color: Colors.blue),
                10.width,
                Text(appStore.translate('safety_measured_followed_here'), style: primaryTextStyle(color: grey)),
              ],
            ),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.2)),
          ).cornerRadiusWithClipRRectOnly(bottomLeft: 8, bottomRight: 8),
        ],
      ),
    ).onTap(() {
      hideKeyboard(context);
      RestaurantMenuScreen(restaurant: widget.restaurant).launch(context);
    }, highlightColor: appStore.isDarkMode ? scaffoldColorDark : context.cardColor);
  }
}
