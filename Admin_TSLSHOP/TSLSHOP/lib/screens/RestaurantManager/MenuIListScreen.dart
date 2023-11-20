import 'package:flutter/material.dart';
import 'package:food_delivery_admin/components/AppWidgets.dart';
import 'package:food_delivery_admin/models/MenuModel.dart';
import 'package:food_delivery_admin/models/RestaurantModel.dart';
import 'package:food_delivery_admin/screens/RestaurantManager/AddMenuItemDetails.dart';
import 'package:food_delivery_admin/utils/Colors.dart';
import 'package:food_delivery_admin/utils/Common.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:food_delivery_admin/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

// ignore: must_be_immutable
class MenuIListScreen extends StatefulWidget {
  static String tag = '/MenuIListScreen';
  RestaurantModel? restaurantModel;

  MenuIListScreen({this.restaurantModel});

  @override
  MenuIListScreenState createState() => MenuIListScreenState();
}

class MenuIListScreenState extends State<MenuIListScreen> {
  ScrollController scrollController = ScrollController();

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
      appBar: appBarWidget(appStore.translate('menu_list'), showBack: getBoolAsync(IS_ADMIN) ? true : false, elevation: 0),
      body: StreamBuilder<List<MenuModel>>(
        stream: menuItemService.getMenuData(restId: widget.restaurantModel == null ? getStringAsync(RESTAURANT_ID) : widget.restaurantModel!.id),
        builder: (_, snap) {
          if (snap.hasData) {
            if (snap.data!.isEmpty) {
              return Text(appStore.translate('no_data_found'), style: primaryTextStyle()).center();
            }
            List<MenuModel> menuItem = snap.data!;
            return Container(
              width: context.width(),
              child: SingleChildScrollView(
                controller: scrollController,
                child: SingleChildScrollView(
                  scrollDirection: context.isDesktop() ? Axis.vertical : Axis.horizontal,
                  child: DataTable(
                    dataRowHeight: 70,
                    columns: [
                      DataColumn(label: Text(MenuTableKey.image, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text(MenuTableKey.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text(MenuTableKey.description, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text(MenuTableKey.category, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text(MenuTableKey.price, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text(MenuTableKey.action, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    ],
                    rows: menuItem.map(
                      (e) {
                        return DataRow(
                          cells: [
                            DataCell(cachedImage(e.image.validate(), height: 50, width: 50, fit: BoxFit.cover).cornerRadiusWithClipRRect(60)),
                            DataCell(Container(width: 200, child: Text(e.itemName.validate(), style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis))),
                            DataCell(Container(width: 200, child: Text(e.description.validate(), style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis))),
                            DataCell(Text(e.categoryName!, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis)),
                            DataCell(Text('${e.itemPrice.validate().toAmount()}', style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis)),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit_outlined),
                                    color: Colors.green,
                                    onPressed: () {
                                      AddMenuItemDetails(menuModel: e).launch(context);
                                    },
                                  ),
                                  8.width,
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.delete_forever_outlined),
                                    color: Colors.red,
                                    onPressed: () async {
                                      bool? isDeleted = await showInDialog(
                                        context,
                                        child: Text(appStore.translate('delete_item'), style: primaryTextStyle()),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                finish(context, false);
                                              },
                                              child: Text(appStore.translate('cancel'), style: primaryTextStyle())),
                                          TextButton(
                                              onPressed: () {
                                                finish(context, true);
                                              },
                                              child: Text(appStore.translate('delete'), style: primaryTextStyle())),
                                        ],
                                      );
                                      if (getBoolAsync(IS_TESTER)) {
                                        return toast(appStore.translate('mTesterNotAllowedMsg'));
                                      } else {
                                        if (isDeleted!) {
                                          menuItemService.removeDocument(e.id).then((value) {
                                            toast(appStore.translate('successfully_delete_Item'));
                                          }).catchError((error) {
                                            toast(error.toString());
                                          });
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            );
          }
          return snapWidgetHelper(snap);
        },
      ),
      floatingActionButton: Container(
        height: 50,
        width: 185,
        color: colorPrimary,
        padding: EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: white),
            4.width,
            Text(appStore.translate('add_item'), style: boldTextStyle(color: white)),
          ],
        ),
      ).cornerRadiusWithClipRRect(defaultRadius).onTap(() {
        if (getBoolAsync(IS_TESTER)) {
          return toast(appStore.translate('mTesterNotAllowedMsg'));
        } else {
          AddMenuItemDetails(restaurantModel: widget.restaurantModel).launch(context);
        }
      }),
    );
  }
}
