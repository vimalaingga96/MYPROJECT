import 'package:flutter/material.dart';
import 'package:food_delivery_admin/main.dart';
import 'package:food_delivery_admin/models/OrderModel.dart';
import 'package:food_delivery_admin/screens/RestaurantManager/component/OrderItemWidget.dart';
import 'package:food_delivery_admin/utils/Common.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:food_delivery_admin/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

class NewOrderScreen extends StatefulWidget {
  static String tag = '/NewOrderScreen';

  @override
  NewOrderScreenState createState() => NewOrderScreenState();
}

class NewOrderScreenState extends State<NewOrderScreen> {
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
  void didUpdateWidget(covariant NewOrderScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
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
      appBar: appBarWidget(appStore.translate('new_order'), showBack: false, elevation: 0),
      body: StreamBuilder<List<OrderModel>>(
        stream: orderService.getOrders(id: getStringAsync(RESTAURANT_ID), orderStatus: [NEW]),
        builder: (_, snap) {
          if (snap.hasData) {
            if (snap.data!.length == 0) {
              return Text(appStore.translate('no_new_order'), style: primaryTextStyle()).center();
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
                    buttonTitle: appStore.translate('accept'),
                    buttonOneColor: Colors.green,
                    onTap: () async {
                      bool? isAccept = await showInDialog(
                        context,
                        child: Text(appStore.translate('accept_order'), style: primaryTextStyle()),
                        actions: [
                          TextButton(
                            onPressed: () {
                              finish(context, false);
                            },
                            child: Text(appStore.translate('cancel'), style: primaryTextStyle()),
                          ),
                          8.width,
                          TextButton(
                            onPressed: () {
                              finish(context, true);
                            },
                            child: Text(appStore.translate('accept'), style: primaryTextStyle(color: Colors.green)),
                          ),
                          8.width,
                        ],
                      );
                      if (isAccept ?? false) {
                        await orderService.updateDocument({OrderKey.orderStatus: COOKING, TimeDataKey.updatedAt: DateTime.now()}, data.id).then((value) async {
                          sendNotification(data.userID, data.orderId, data.restaurantCity);
                          log('user id is ${data.userID}');
                          log('order id is ${data.orderId}');
                          log('restaurantCity ${data.restaurantCity}');
                        }).catchError((error) {
                          toast(error.toString());
                        });
                      }
                    },
                    isSecondBtn: true,
                    secondBtnTitle: appStore.translate('reject'),
                    buttonTwoColor: Colors.red,
                    secondBtnOnTap: () async {
                      bool isReject = await (showInDialog(
                        context,
                        child: Text(appStore.translate('reject_order'), style: primaryTextStyle()),
                        actions: [
                          TextButton(
                            onPressed: () {
                              finish(context, false);
                            },
                            child: Text(appStore.translate('cancel'), style: primaryTextStyle()),
                          ),
                          8.width,
                          TextButton(
                            onPressed: () {
                              finish(context, true);
                            },
                            child: Text(appStore.translate('reject'), style: primaryTextStyle(color: Colors.red)),
                          ),
                          8.width,
                        ],
                      ));
                      if (isReject) {
                        orderService.updateDocument({
                          OrderKey.orderStatus: CANCELED,
                          TimeDataKey.updatedAt: DateTime.now(),
                        }, data.id).then((value) {
                          //
                        }).catchError((error) {
                          log(error);
                        });
                      }
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

  Future<void> sendNotification(String? userID, String? orderId, String? restaurantCity) async {
    await userService.getDeliveryBoys(role: DELIVERY_BOY, city: restaurantCity ?? getStringAsync(RESTAURANT_CITY)).then((value) {
      List<String> deliveryBoyPlayerIdList = [];

      value.forEach((element) {
        if (element.oneSignalPlayerId.validate().isNotEmpty) {
          deliveryBoyPlayerIdList.add(element.oneSignalPlayerId.validate());
        }
      });

      if (deliveryBoyPlayerIdList.validate().isNotEmpty) {
        userService.getUserById(userId: userID).then((userModel) {
          sendPushNotifications(
            listUser: deliveryBoyPlayerIdList,
            title: appStore.translate('new_order'),
            content: '${appStore.translate('new_order_received_from')} ${userModel.name}',
            orderId: orderId,
          );
          log('delivery p id list $deliveryBoyPlayerIdList');
        });
      }
    }).catchError((error) {
      log(error.toString());
      // toast(error.toString());
    });
  }
}
