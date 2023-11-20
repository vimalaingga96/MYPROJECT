import 'package:flutter/material.dart';
import 'package:fooddelivery/components/RestaurantItemComponent.dart';
import 'package:fooddelivery/models/RestaurantModel.dart';
import 'package:fooddelivery/utils/Constants.dart';
import 'package:fooddelivery/utils/Widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class FavouriteRestaurantListScreen extends StatefulWidget {
  static String tag = '/FavouriteRestaurantListScreen';

  @override
  FavouriteRestaurantListScreenState createState() => FavouriteRestaurantListScreenState();
}

class FavouriteRestaurantListScreenState extends State<FavouriteRestaurantListScreen> {
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
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(appStore.translate('fav_restaurant'), color: context.cardColor),
        body: FutureBuilder<List<RestaurantModel>>(
          future: restaurantDBService.getFavRestaurantList(),
          builder: (_, snap) {
            if (snap.hasData) {
              if (snap.data!.isEmpty) {
                return Center(child: noDataWidget(errorMessage: appStore.translate('noFavouriteRestaurantFound')));
              }
              return ListView.builder(
                padding: EdgeInsets.all(8),
                physics: ClampingScrollPhysics(),
                itemBuilder: (_, index) {
                  return RestaurantItemComponent(restaurant: snap.data![index]);
                },
                itemCount: snap.data!.length,
                shrinkWrap: true,
              );
            } else {
              return snapWidgetHelper(snap);
            }
          },
        ),
      ),
    );
  }
}
