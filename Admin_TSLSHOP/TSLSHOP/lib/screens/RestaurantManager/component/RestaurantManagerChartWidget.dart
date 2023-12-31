import 'package:flutter/material.dart';
import 'package:food_delivery_admin/models/FoodOrderModel.dart';
import 'package:food_delivery_admin/models/OrderModel.dart';
import 'package:food_delivery_admin/utils/Colors.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../main.dart';

class RestaurantManagerChartWidget extends StatefulWidget {
  @override
  RestaurantManagerChartWidgetState createState() => RestaurantManagerChartWidgetState();
}

class RestaurantManagerChartWidgetState extends State<RestaurantManagerChartWidget> {
  int selected = 0;
  List<String> orderData = [Week, Month, Year];
  DateTime endDate = DateTime.now();

  List<FoodOrderModel> allDate = [];
  List<DateTime> dateTime1 = [
    DateTime.now().subtract(Duration(days: 7)),
    DateTime.now().subtract(Duration(days: 30)),
    DateTime.now().subtract(Duration(days: 365)),
  ];
  List<FoodOrderModel> chartData = [];
  late TooltipBehavior tooltipBehavior;
  late TooltipBehavior tooltipBehavior1;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    orderService.restaurantTotalAmount(startDate: dateTime1[selected]).listen((event) {
      chartData = getAllData(duration: orderData[selected], orderData: event);
      setState(() {});
    });
    tooltipBehavior = TooltipBehavior(enable: true);
    tooltipBehavior1 = TooltipBehavior(enable: true);

  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: boxDecorationRoundedWithShadow(
        defaultRadius.toInt(),
        shadowColor: appStore.isDarkMode ? context.cardColor : Colors.grey.shade200,
        spreadRadius: 3,
        backgroundColor: context.cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(appStore.translate('analytics'), style: boldTextStyle(size: 25)),
          Text(appStore.translate('restaurant_summary_graph'), style: secondaryTextStyle(size: 17)),
          16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: StreamBuilder<List<OrderModel>>(
                  stream: orderService.restaurantTotalAmount(startDate: dateTime1[selected]),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                      );
                    }
                    return SizedBox();
                  },
                ),
              ),
              Container(
                child: Row(
                  children: orderData
                      .asMap()
                      .map((i, e) {
                        return MapEntry(
                          i,
                          Container(
                            color: selected == i ? colorPrimary : containerColor,
                            padding: EdgeInsets.all(8),
                            child: Text(e, style: primaryTextStyle(color: selected == i ? white : ChartColor)),
                          ).onTap(() {
                            selected = i;
                            init();
                            setState(() {});
                          }),
                        );
                      })
                      .values
                      .toList(),
                ),
              ).cornerRadiusWithClipRRect(10)
            ],
          ),
          16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(appStore.translate('chart_total_amount_order'), style: boldTextStyle()),
              Text(appStore.translate('chart_total_order'), style: boldTextStyle()),
            ],
          ),
          32.height,
          Row(
            children: [
              SfCartesianChart(
                tooltipBehavior: tooltipBehavior,
                series: <ChartSeries>[
                  StackedColumnSeries<FoodOrderModel, String>(
                    color: ChartColor,
                    markerSettings: MarkerSettings(isVisible: true),
                    dataSource: chartData,
                    xValueMapper: (FoodOrderModel exp, _) => exp.expanseCategory,
                    yValueMapper: (FoodOrderModel exp, _) => exp.amount,
                  ),
                ],
                primaryXAxis: CategoryAxis(),
              ).expand(),
              32.width,
              SfCartesianChart(
                tooltipBehavior: tooltipBehavior1,
                series: <ChartSeries>[
                  StackedColumnSeries<FoodOrderModel, String>(
                    color: ChartColor1,
                    markerSettings: MarkerSettings(isVisible: true),
                    dataSource: chartData,
                    xValueMapper: (FoodOrderModel exp, _) => exp.expanseCategory,
                    yValueMapper: (FoodOrderModel exp, _) => exp.total,
                  ),
                ],
                primaryXAxis: CategoryAxis(isVisible: true),
              ).expand(),
            ],
          )
        ],
      ),
    );


  }

  getAllData({String? duration, List<OrderModel>? orderData}) {
    allDate.clear();
    int totalAmount = 0;
    String keyName = "";
    int totalOrder = 0;
    for (int i = 0; i < orderData!.length; i++) {
      String dateName = "";
      if (duration == Week) {
        dateName = DateFormat("EEEE, d MMM").format(orderData[i].createdAt!);
      } else if (duration == Month) {
        dateName = DateFormat("yyyy-MM-dd").format(orderData[i].createdAt!);
      } else if (duration == Year) {
        dateName = DateFormat("MMM").format(orderData[i].createdAt!);
      }
      if (keyName.isEmpty) {
        keyName = dateName;
      } else if (keyName != dateName) {
        allDate.add(FoodOrderModel(expanseCategory: keyName, amount: totalAmount, total: totalOrder));
        totalOrder = 0;
        totalAmount = 0;
        keyName = dateName;
      }
      totalAmount = totalAmount + orderData[i].totalAmount!;
      totalOrder = totalOrder + 1;
      if (i == orderData.length - 1) {
        allDate.add(FoodOrderModel(expanseCategory: keyName, amount: totalAmount, total: totalOrder));
      }
    }
    return allDate;
  }
}
