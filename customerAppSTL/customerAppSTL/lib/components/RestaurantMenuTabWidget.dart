import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fooddelivery/models/MenuModel.dart';
import 'package:fooddelivery/models/RestaurantModel.dart';
import 'package:fooddelivery/screens/CartScreen.dart';
import 'package:fooddelivery/utils/Constants.dart';
import 'package:fooddelivery/utils/Widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../main.dart';
import 'FoodMenuItemWidget.dart';

// ignore: must_be_immutable
class RestaurantMenuTabWidget extends StatefulWidget {
  static String tag = '/RestaurantMenuTabWidget';
  RestaurantModel? restaurantData;

  RestaurantMenuTabWidget({this.restaurantData});

  @override
  RestaurantMenuTabWidgetState createState() => RestaurantMenuTabWidgetState();
}

class RestaurantMenuTabWidgetState extends State<RestaurantMenuTabWidget> {
  UniqueKey uniqueKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: uniqueKey,
      children: [
        PaginateFirestore(
          itemBuilderType: PaginateBuilderType.listView,
          itemBuilder: (context, documentSnapshot,index) {
            MenuModel food = MenuModel.fromJson(documentSnapshot[index].data() as Map<String, dynamic>);

            String tag = '';
            food.ingredientsTags!.forEach((e) {
              tag = '$tag${tag.isEmpty ? '' : ', '}$e';
            });

            return FoodMenuItemWidget(
              food: food,
              tag: tag,
              onUpdate: () {
                uniqueKey = UniqueKey();
                setState(() {});
              },
            );
          },
          padding: EdgeInsets.all(8),
          query: foodItemDBService.restaurantsFoodMenuQuery(widget.restaurantData!.id.validate()),
          isLive: true,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemsPerPage: DocLimit,
          bottomLoader: Loader(),
          initialLoader: Loader(),
          onEmpty: noDataWidget(errorMessage: appStore.translate('noDataFound')),
          onError: (e) => Text(e.toString(), style: primaryTextStyle()).center(),
          separator: Divider(),
        ),
        Observer(
          builder: (_) => viewCartWidget(
              context: context,
              totalItemLength: '${appStore.mCartList.length}',
              onTap: () {
                CartScreen(isRemove: true, deliveryCharge: widget.restaurantData!.deliveryCharge).launch(context);
              }).visible(appStore.mCartList.isNotEmpty),
        )
      ],
    );
  }
}
