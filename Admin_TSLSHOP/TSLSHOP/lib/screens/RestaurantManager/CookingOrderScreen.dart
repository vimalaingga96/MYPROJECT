import 'package:flutter/material.dart';
import 'package:food_delivery_admin/main.dart';
import 'package:food_delivery_admin/models/OrderModel.dart';
import 'package:food_delivery_admin/screens/RestaurantManager/component/OrderItemWidget.dart';
import 'package:food_delivery_admin/utils/Common.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:food_delivery_admin/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

class CookingOrderScreen extends StatefulWidget {
  static String tag = '/CookingOrderScreen';

  @override
  CookingOrderScreenState createState() => CookingOrderScreenState();
}

class CookingOrderScreenState extends State<CookingOrderScreen> {
  ScrollController controller = ScrollController();
  String deliveryBoyPlayerId = '';

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
      appBar: appBarWidget(appStore.translate('cooking_order'),
          showBack: false, elevation: 0),
      body: StreamBuilder<List<OrderModel>>(
        stream: orderService.getOrders(
            id: getStringAsync(RESTAURANT_ID),
            orderStatus: [COOKING, ASSIGNED]),
        builder: (_, snap) {
          if (snap.hasData) {
            if (snap.data!.length == 0) {
              return Text(appStore.translate('no_data_found'),
                      style: primaryTextStyle())
                  .center();
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

                  return OrderItemWidget(
                    orderModel: data,
                    buttonTitle: 'Complete Order',
                    buttonOneColor: Colors.green,
                    onTap: () {
                      // if (data.deliveryBoyId != null) {
                      orderService.updateDocument({
                        OrderKey.orderStatus: COMPLETED,
                        TimeDataKey.updatedAt: DateTime.now(),
                      }, data.id).then((value) {
                        //   sendNotification(data.orderId, data.deliveryBoyId, data.restaurantName);
                        log('Order id ${data.orderId}');
                        log('Delivery boy id ${data.deliveryBoyId}');
                        log('Restaurant name ${data.restaurantName}');
                      }).catchError((error) {
                        toast(error.toString());
                      });
                      // } else {
                      //   toast(appStore.translate('notAcceptOrderByDeliveryBoy'));
                      // }
                    },
                  ).paddingAll(8);
                },
              ),
            );
          }
          return snapWidgetHelper(snap);
        },
      ),
    );
  }

  Future<void> sendNotification(
      String? orderId, String? deliveryBoyId, String? restaurantName) async {
    await userService.getUserById(userId: deliveryBoyId).then((userModel) {
      if (userModel.oneSignalPlayerId!.validate().isNotEmpty) {
        sendPushNotifications(
          listUser: [userModel.oneSignalPlayerId!],
          title: appStore.translate('your_order_is_ready'),
          content: '${appStore.translate('collect_from')} $restaurantName',
          orderId: orderId,
        );
        log('user p id ${userModel.oneSignalPlayerId!}');
        log('order id$orderId');
      }
    }).catchError((error) {
      log(error);
    });
  }
}
