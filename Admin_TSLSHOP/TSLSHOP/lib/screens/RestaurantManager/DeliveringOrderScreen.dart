import 'package:flutter/material.dart';
import 'package:food_delivery_admin/models/OrderModel.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import 'component/OrderItemWidget.dart';

class DeliveringOrderScreen extends StatefulWidget {
  static String tag = '/DeliveryOrderScreen';

  @override
  DeliveringOrderScreenState createState() => DeliveringOrderScreenState();
}

class DeliveringOrderScreenState extends State<DeliveringOrderScreen> {
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
      appBar: appBarWidget(appStore.translate('delivering_order'), showBack: false, elevation: 0),
      body: StreamBuilder<List<OrderModel>>(
        stream: orderService.getOrders(id: getStringAsync(RESTAURANT_ID), orderStatus: [READY, DELIVERING]),
        builder: (_, snap) {
          if (snap.hasData) {
            if (snap.data!.length == 0) {
              return Text(appStore.translate('no_data_found'), style: primaryTextStyle()).center();
            }
            return SingleChildScrollView(
              controller: controller,
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snap.data!.length,
                itemBuilder: (_, index) {
                  OrderModel data = snap.data![index];
                  return OrderItemWidget(orderModel: data).paddingAll(8);
                },
              ),
            );
          }
          return snapWidgetHelper(snap);
        },
      ),
    );
  }
}
