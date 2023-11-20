import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:fooddelivery/components/DeliveryBoyReviewDialog.dart';
import 'package:fooddelivery/components/OrderDetailsComponent.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/models/OrderItemData.dart';
import 'package:fooddelivery/models/OrderModel.dart';
import 'package:fooddelivery/services/DeliveryBoyReviewDBService.dart';
import 'package:fooddelivery/utils/Colors.dart';
import 'package:fooddelivery/utils/Common.dart';
import 'package:fooddelivery/utils/Constants.dart';
import 'package:fooddelivery/utils/ModalKeys.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import 'OrderTrackingScreen.dart';

// ignore: must_be_immutable
class OrderDetailsScreen extends StatefulWidget {
  static String tag = '/OrderDetailsScreen';
  List<OrderItemData>? listOfOrder;
  OrderModel? orderData;

  OrderDetailsScreen({this.listOfOrder, this.orderData});

  @override
  OrderDetailsScreenState createState() => OrderDetailsScreenState();
}

class OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late DeliveryBoyReviewsDBService deliveryBoyReviewsDBService;
  bool isReview = false;
  String orderStatus = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(
      appStore.isDarkMode ? scaffoldColorDark : Colors.white,
      statusBarIconBrightness: Brightness.light,
    );
    review();

    myOrderDBService.orderById(id: widget.orderData!.id).listen((event) async {
      widget.orderData = event;
      setState(() {});
    });
  }

  review() async {
    deliveryBoyReviewsDBService = DeliveryBoyReviewsDBService(restId: widget.orderData!.id);

    deliveryBoyReviewsDBService.deliveryBoyReviews(orderID: widget.orderData!.id).listen((event) async {
      isReview = event;
      setState(() {});
    });
  }

  void cancelOrder() async {
    Map<String, dynamic> data = {
      OrderKeys.orderStatus: ORDER_CANCELLED,
      CommonKeys.updatedAt: DateTime.now(),
    };

    myOrderDBService.updateDocument(data, widget.orderData!.id).then((res) async {
      toast(appStore.translate('order_cancelled'));

      widget.orderData!.orderStatus = ORDER_CANCELLED;

      setState(() {});
    }).catchError((error) {
      toast(error.toString());
      setState(() {});
    });
  }

  @override
  void dispose() {
    setStatusBarColor(appStore.isDarkMode ? scaffoldColorDark : Colors.white);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('#${widget.orderData!.orderId}', color: context.cardColor),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(appStore.translate('order_id'), style: boldTextStyle()).paddingOnly(left: 16, top: 16),
            Text('${widget.orderData!.orderId.validate()}', style: boldTextStyle(size: 12)).paddingLeft(16),
            8.height,
            Text(appStore.translate('date'), style: boldTextStyle()).paddingOnly(left: 16, top: 16),
            Text(
              '${appStore.translate('delivery_by')} ${DateFormat('EEE d, MMM yyyy HH:mm:ss').format(widget.orderData!.createdAt!)}',
              style: boldTextStyle(size: 12),
            ).paddingLeft(16),
            8.height,
            Text(appStore.translate('deliver_to'), style: boldTextStyle()).paddingOnly(left: 16, top: 16),
            Text(widget.orderData!.userAddress.validate(), style: boldTextStyle(size: 12)).paddingOnly(left: 16, right: 16),
            16.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.edit, color: Colors.orangeAccent),
                    4.width,
                    Text(appStore.translate('add_review'), style: secondaryTextStyle(color: Colors.orangeAccent, size: 14)),
                  ],
                ).onTap(() async {
                  bool? res = await showInDialog(
                    context,
                    barrierDismissible: true,
                    child: DeliveryBoyReviewDialog(order: widget.orderData),
                    contentPadding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(borderRadius: radius(16)),
                  );
                  if (res ?? false) {
                    review();
                  }
                }).paddingLeft(16),
                16.height,
              ],
            ).visible(!isReview && widget.orderData!.orderStatus == ORDER_COMPLETE),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                  decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8), backgroundColor: Colors.red),
                  child: Text(appStore.translate('cancel_order'), style: secondaryTextStyle(color: Colors.white, size: 12)),
                ).onTap(() async {
                  bool? res = await showConfirmDialog(context, appStore.translate('cancel_order_confirmation'), negativeText: appStore.translate('no'), positiveText: appStore.translate('yes'));
                  if (res ?? false) {
                    cancelOrder();
                  }
                }).paddingOnly(left: 16),
                16.height,
              ],
            ).visible((widget.orderData!.orderStatus == ORDER_ASSIGNED) || widget.orderData!.orderStatus == ORDER_COOKING),
            AppButton(
              padding: EdgeInsets.all(8),
              color: Colors.green,
              child: Text(appStore.translate('track_order'), style: boldTextStyle(color: Colors.white, size: 14)),
              onTap: () {
                OrderTrackingScreen(orderData: widget.orderData).launch(context).then((value) {
                  setState(() {});
                });
              },
            ).paddingLeft(16).visible(widget.orderData!.orderStatus == ORDER_DELIVERING),
            8.height,
            Divider(thickness: 3),
            16.height,
            Text(appStore.translate('order_items'), style: boldTextStyle()).paddingLeft(16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(16),
              itemCount: widget.listOfOrder!.length,
              itemBuilder: (context, index) {
                return OrderDetailsComponent(orderDetailsData: widget.listOfOrder![index]);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 16),
        color: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appStore.translate('total'), style: primaryTextStyle(size: 18)),
                Text(getAmount(widget.orderData!.totalAmount.validate()), style: boldTextStyle(size: 22)),
              ],
            ).paddingOnly(left: 16, right: 16),
          ],
        ),
      ),
    );
  }
}
