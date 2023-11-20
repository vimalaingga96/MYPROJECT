import 'package:food_delivery_admin/models/SideDrawerModel.dart';
import 'package:food_delivery_admin/screens/Admin/CategoryScreen.dart';
import 'package:food_delivery_admin/screens/Admin/RestaurantFragment.dart';
import 'package:food_delivery_admin/screens/Admin/UserFragment.dart';
import 'package:food_delivery_admin/screens/HomeFragment.dart';
import 'package:food_delivery_admin/screens/RestaurantManager/CompletedOrderScreen.dart';
import 'package:food_delivery_admin/screens/RestaurantManager/CookingOrderScreen.dart';
import 'package:food_delivery_admin/screens/RestaurantManager/DeliveringOrderScreen.dart';
import 'package:food_delivery_admin/screens/RestaurantManager/MenuIListScreen.dart';
import 'package:food_delivery_admin/screens/RestaurantManager/NewOrderScreen.dart';
import 'package:food_delivery_admin/screens/RestaurantManager/RestaurantDetailScreen.dart';
import 'package:food_delivery_admin/screens/SettingFragment.dart';
import 'package:nb_utils/nb_utils.dart';

import 'Constants.dart';

List<SideDrawerModel> getDrawerList() {
  List<SideDrawerModel> list = [];

  list.add(SideDrawerModel(
      img: 'images/ic_home.png', title: 'dashboard', widget: HomeFragment()));

  list.add(SideDrawerModel(
      img: 'images/ic_order.png',
      title: 'order',
      widget: NewOrderScreen(),
      items: [

        SideDrawerModel(title: 'new_order', widget: NewOrderScreen()),
         SideDrawerModel(title: 'cooking', widget: CookingOrderScreen()),
        //SideDrawerModel(title: 'delivering', widget: DeliveringOrderScreen()),
        SideDrawerModel(title: 'completed', widget: CompletedOrderScreen()),



      ]));
  if (!getBoolAsync(IS_ADMIN)) {
    list.add(SideDrawerModel(
        img: 'images/ic_menu.png',
        title: 'Menu',
        widget: RestaurantDetailScreen(),
        items: [
          SideDrawerModel(
              title: 'restaurant_detail', widget: RestaurantDetailScreen()),
          SideDrawerModel(title: 'menu_details', widget: MenuIListScreen()),
        ]));
  }
  if (getBoolAsync(IS_ADMIN)) {
    list.add(SideDrawerModel(
        img: 'images/ic_menu.png',
        title: 'categories',
        widget: CategoryScreen()));
    list.add(SideDrawerModel(
        img: 'images/ic_restaurant.png',
        title: 'restaurant',
        widget: RestaurantFragment()));
    list.add(SideDrawerModel(
        img: 'images/ic_user.png',
        title: 'users',
        widget: UserFragment(),
        items: [
          SideDrawerModel(title: 'all_user', widget: UserFragment(role: '')),
          SideDrawerModel(title: 'users', widget: UserFragment(role: USER)),
      //    SideDrawerModel(title: 'delivery_boy', widget: UserFragment(role: DELIVERY_BOY)),
          SideDrawerModel(
              title: 'restaurant_manager',
              widget: UserFragment(role: REST_MANAGER)),
        ]));
  }
  list.add(SideDrawerModel(
      img: 'images/ic_settings.png',
      title: 'setting',
      widget: SettingFragment()));

  return list;
}
