import 'package:flutter/material.dart';
import 'package:food_delivery_admin/components/AppWidgets.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class ManagerCounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        double width = context.isPhone()
            ? constraint.maxWidth / 1
            : context.isTablet()
                ? constraint.maxWidth / 2
                : constraint.maxWidth / 4;
        return Wrap(
          children: [
            Container(
              width: width,
              child: streamBuilderWidget(stream: userService.getAllUsers(role: DELIVERY_BOY), title: appStore.translate('total_Delivery_boy')),
            ),
            Container(
              width: width,
              child: streamBuilderWidget(stream: orderService.getOrders(id: getStringAsync(RESTAURANT_ID), orderStatus: [NEW]), title: appStore.translate('total_new_order')),
            ),
            Container(
              width: width,
              child: streamBuilderWidget(stream: orderService.getOrders(id: getStringAsync(RESTAURANT_ID), orderStatus: [COMPLETED]), title: appStore.translate('total_completed_order')),
            ),
          ],
        );
      },
    );
  }
}
