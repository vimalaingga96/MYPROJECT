import 'package:flutter/material.dart';
import 'package:food_delivery_admin/components/AppWidgets.dart';
import 'package:food_delivery_admin/utils/Common.dart';

import '../../../main.dart';

class CountWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        double width = context.isMobile()
            ? constraint.maxWidth / 1
            : context.isTab()
                ? constraint.maxWidth / 2
                : constraint.maxWidth / 4;
        return Wrap(
          children: [
            Container(
              width: width,
              child: streamBuilderWidget(stream: userService.getAllUsers(role: ''), title: appStore.translate('total_user')),
            ),
            Container(
              width: width,
              child: streamBuilderWidget(stream: orderService.getOrders(), title: appStore.translate('total_order')),
            ),
            Container(
              width: width,
              child: streamBuilderWidget(stream: restaurantService.getAllRestaurants(), title: appStore.translate('total_restaurant')),
            ),
            Container(
              width: width,
              child: streamBuilderWidget(stream: categoryService.getCategory(), title: appStore.translate('total_category')),
            ),
            Container(
              width: width,
              child: streamBuilderWidget(stream: menuItemService.getMenuData(), title: appStore.translate('total_food')),
            ),
            Container(
              width: width,
              child: streamBuilderWidget(stream: reviewService.getReviews(), title: appStore.translate('total_review')),
            ),
            Container(
              width: width,
              child: streamBuilderWidget(stream: deliveryBoyReviewService.getDeliveryBoyReviews(), title: appStore.translate('total_Delivery_boy')),
            ),
          ],
        );
      },
    );
  }
}
