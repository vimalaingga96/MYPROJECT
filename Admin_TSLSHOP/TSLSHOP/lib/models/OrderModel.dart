import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_admin/utils/ModelKeys.dart';

class OrderModel {
  String? id;
  String? orderId;
  List<OrderItem>? listOfOrder;
  String? restaurantId;
  String? restaurantName;
  String? restaurantCity;
  int? totalPrice;
  int? totalItem;
  String? userAddress;
  String? userID;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? orderStatus;
  String? deliveryBoyId;
  String? paymentMethod;
  String? paymentStatus;
  int?totalAmount;
  int?deliveryCharge;

  OrderModel({
    this.id,
    this.orderId,
    this.listOfOrder,
    this.restaurantId,
    this.restaurantName,
    this.totalPrice,
    this.totalItem,
    this.userAddress,
    this.userID,
    this.createdAt,
    this.updatedAt,
    this.orderStatus,
    this.deliveryBoyId,
    this.paymentMethod,
    this.paymentStatus,
    this.restaurantCity,
    this.totalAmount,
    this.deliveryCharge,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json[OrderKey.id],
      orderId: json[OrderKey.orderId],
      listOfOrder: json[OrderKey.listOfOrder] != null ? (json[OrderKey.listOfOrder] as List).map((e) => OrderItem.fromJson(e)).toList() : null,
      restaurantId: json[OrderKey.restaurantId],
      restaurantName: json[OrderKey.restaurantName],
      totalPrice: json[OrderKey.totalPrice],
      totalItem: json[OrderKey.totalItem],
      userAddress: json[OrderKey.userAddress],
      userID: json[OrderKey.userID],
      createdAt: json[TimeDataKey.createdAt] != null ? (json[TimeDataKey.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[TimeDataKey.updatedAt] != null ? (json[TimeDataKey.updatedAt] as Timestamp).toDate() : null,
      orderStatus: json[OrderKey.orderStatus],
      deliveryBoyId: json[OrderKey.deliveryBoyId],
      paymentMethod: json[OrderKey.paymentMethod],
      paymentStatus: json[OrderKey.paymentStatus],
      restaurantCity: json[OrderKey.restaurantCity],
      totalAmount: json[OrderKey.totalAmount],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();

    data[OrderKey.id] = this.id;
    data[OrderKey.orderId] = this.orderId;
    data[OrderKey.listOfOrder] = this.listOfOrder;
    data[OrderKey.restaurantId] = this.restaurantId;
    data[OrderKey.restaurantName] = this.restaurantName;
    data[OrderKey.totalPrice] = this.totalPrice;
    data[OrderKey.totalItem] = this.totalItem;
    data[OrderKey.userAddress] = this.userAddress;
    data[OrderKey.userID] = this.userID;
    data[TimeDataKey.createdAt] = this.createdAt;
    data[TimeDataKey.updatedAt] = this.updatedAt;
    data[OrderKey.orderStatus] = this.orderStatus;
    data[OrderKey.deliveryBoyId] = this.deliveryBoyId;
    data[OrderKey.paymentStatus] = this.paymentStatus;
    data[OrderKey.restaurantCity] = this.restaurantCity;
    data[OrderKey.totalAmount] = this.totalAmount;
    return data;
  }
}

class OrderItem {
  String? id;
  String? catId;
  String? catName;
  String? itemName;
  int? itemPrice;
  int? qty;

  OrderItem({
    this.id,
    this.catId,
    this.catName,
    this.itemName,
    this.itemPrice,
    this.qty,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json[OrderItemKey.id],
      catId: json[OrderItemKey.catId],
      catName: json[OrderItemKey.catName],
      itemName: json[OrderItemKey.itemName],
      itemPrice: json[OrderItemKey.itemPrice],
      qty: json[OrderItemKey.qty],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();

    data[OrderItemKey.id] = this.id;
    data[OrderItemKey.catId] = this.catId;
    data[OrderItemKey.catName] = this.catName;
    data[OrderItemKey.itemName] = this.itemName;
    data[OrderItemKey.itemPrice] = this.itemPrice;
    data[OrderItemKey.qty] = this.qty;

    return data;
  }
}
