import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:food_delivery_admin/components/AppWidgets.dart';
import 'package:food_delivery_admin/models/MenuModel.dart';
import 'package:food_delivery_admin/models/OrderModel.dart';
import 'package:food_delivery_admin/screens/RestaurantManager/component/ManagerCounterWidget.dart';
import 'package:food_delivery_admin/screens/RestaurantManager/component/RestaurantManagerChartWidget.dart';
import 'package:food_delivery_admin/utils/Common.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:food_delivery_admin/utils/ModelKeys.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class RestaurantManagerHomeWidget extends StatefulWidget {
  static String tag = '/RestaurantManagerHomeWidget';

  @override
  RestaurantManagerHomeWidgetState createState() => RestaurantManagerHomeWidgetState();
}

class RestaurantManagerHomeWidgetState extends State<RestaurantManagerHomeWidget> {
  ScrollController scrollController = ScrollController();
  ScrollController controller = ScrollController();

  bool mDeliveryBoyCard = false;
  bool mNewOrderCard = false;
  bool mCompOrderCard = false;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ManagerCounterWidget(),
        16.height,
        Container(
          width: context.width(),
          child: LayoutBuilder(
            builder: (context, constrain) {
              double width = context.isPhone() || context.isTablet() ? constrain.maxWidth : constrain.maxWidth / 2 - 16;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  Container(
                    width: width,
                    decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(),
                        shadowColor: appStore.isDarkMode ? context.cardColor : Colors.grey.shade200, spreadRadius: 3, backgroundColor: context.cardColor),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appStore.translate('new_orders'), style: boldTextStyle(size: 18)).paddingSymmetric(horizontal: 24, vertical: 8),
                        Divider(height: 0),
                        StreamBuilder<List<OrderModel>>(
                          stream: orderService.getOrders(id: getStringAsync(RESTAURANT_ID), orderStatus: [NEW]),
                          builder: (_, snap) {
                            if (snap.hasData) {
                              if (snap.data!.isEmpty) {
                                if (snap.data!.length == 0) {
                                  return Text(appStore.translate('no_data_found'), style: primaryTextStyle()).center();
                                }
                              }
                              List<OrderModel> orderModel = snap.data!;
                              return Container(
                                width: context.width(),
                                child: SingleChildScrollView(
                                  controller: controller,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columns: [
                                        DataColumn(label: Text(OrderTableKey.orderId, style: boldTextStyle(), overflow: TextOverflow.ellipsis)),
                                        DataColumn(label: Text(OrderTableKey.dateTime, style: boldTextStyle(), overflow: TextOverflow.ellipsis)),
                                        DataColumn(label: Text(OrderTableKey.amount, style: boldTextStyle(), overflow: TextOverflow.ellipsis)),
                                        DataColumn(label: Text(OrderTableKey.paymentStatus, style: boldTextStyle(), overflow: TextOverflow.ellipsis)),
                                        DataColumn(label: Text(OrderTableKey.paymentMethod, style: boldTextStyle(), overflow: TextOverflow.ellipsis)),
                                      ],
                                      rows: orderModel.map((e) {
                                        return DataRow(cells: [
                                          DataCell(Text(e.orderId.validate(), style: primaryTextStyle(), overflow: TextOverflow.ellipsis)),
                                          DataCell(Text('${DateFormat('dd-MM-yyyy hh:mm a').format(e.createdAt!)}', style: primaryTextStyle(), overflow: TextOverflow.ellipsis)),
                                          DataCell(Text('${e.totalPrice.toAmount()}', style: primaryTextStyle(), overflow: TextOverflow.ellipsis)),
                                          DataCell(Text(e.paymentStatus.validate(),
                                              style: primaryTextStyle(color: e.paymentStatus.validate() == PAYMENT_PENDING ? Colors.red : Colors.green), overflow: TextOverflow.ellipsis)),
                                          DataCell(Text(e.paymentMethod.validate(), style: primaryTextStyle(), overflow: TextOverflow.ellipsis)),
                                        ]);
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return snapWidgetHelper(snap);
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: width,
                    decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(),
                        shadowColor: appStore.isDarkMode ? context.cardColor : Colors.grey.shade200, spreadRadius: 3, backgroundColor: context.cardColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appStore.translate('menu_items'), style: boldTextStyle(size: 18)).paddingSymmetric(horizontal: 24, vertical: 8),
                        Divider(height: 0),
                        StreamBuilder<List<MenuModel>>(
                          stream: menuItemService.getMenuData(restId: getStringAsync(RESTAURANT_ID)),
                          builder: (_, snap) {
                            if (snap.hasData) {
                              if (snap.data!.isEmpty) {
                                return Text(appStore.translate('no_data_found'), style: primaryTextStyle()).center();
                              }
                              List<MenuModel> menuItem = snap.data!;
                              return Container(
                                width: context.width(),
                                color: context.cardColor,
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                        dataRowHeight: 70,
                                        columns: [
                                          DataColumn(label: Text(appStore.translate('image'), style: boldTextStyle(), overflow: TextOverflow.ellipsis)),
                                          DataColumn(label: Text(appStore.translate('name'), style: boldTextStyle(), overflow: TextOverflow.ellipsis)),
                                          DataColumn(label: Text(appStore.translate('description'), style: boldTextStyle(), overflow: TextOverflow.ellipsis)),
                                          DataColumn(label: Text(appStore.translate('category'), style: boldTextStyle(), overflow: TextOverflow.ellipsis)),
                                          DataColumn(label: Text(appStore.translate('price'), style: boldTextStyle(), overflow: TextOverflow.ellipsis)),
                                        ],
                                        rows: menuItem.map(
                                          (e) {
                                            return DataRow(
                                              cells: [
                                                DataCell(cachedImage(e.image.validate(), height: 50, width: 50, fit: BoxFit.cover).cornerRadiusWithClipRRect(60)),
                                                DataCell(Container(width: 150, child: Text(e.itemName.validate(), style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis))),
                                                DataCell(Container(width: 150, child: Text(e.description.validate(), style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis))),
                                                DataCell(Text(e.categoryName!, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                                DataCell(Text('${e.itemPrice.validate().toAmount()}', style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                              ],
                                            );
                                          },
                                        ).toList()),
                                  ),
                                ),
                              );
                            }
                            return snapWidgetHelper(snap);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        32.height,
        RestaurantManagerChartWidget()
      ],
    );
  }
}
