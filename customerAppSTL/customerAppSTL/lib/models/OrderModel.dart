import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fooddelivery/utils/ModalKeys.dart';

import 'OrderItemData.dart';

class OrderModel {
  List<OrderItemData>? listOfOrder;
  int? totalAmount;
  int? totalItem;
  String? userId;
  String? orderStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? orderId;
  String? restaurantId;
  String? restaurantName;
  GeoPoint? userLocation;
  String? userAddress;
  GeoPoint? deliveryBoyLocation;
  String? deliveryBoyId;
  String? paymentMethod;
  String? restaurantCity;
  String? paymentStatus;
  String? id;
  int?deliveryCharge;

  OrderModel({
    this.listOfOrder,
    this.totalAmount,
    this.totalItem,
    this.userId,
    this.orderStatus,
    this.createdAt,
    this.updatedAt,
    this.orderId,
    this.restaurantId,
    this.restaurantName,
    this.userLocation,
    this.userAddress,
    this.deliveryBoyLocation,
    this.deliveryBoyId,
    this.paymentMethod,
    this.restaurantCity,
    this.paymentStatus,
    this.id,
    this.deliveryCharge,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      listOfOrder: json[OrderKeys.listOfOrder] != null ? (json[OrderKeys.listOfOrder] as List).map<OrderItemData>((e) => OrderItemData.fromJson(e)).toList() : null,
      totalAmount: json[OrderKeys.totalAmount],
      totalItem: json[OrderKeys.totalItem],
      userId: json[OrderKeys.userId],
      orderStatus: json[OrderKeys.orderStatus],
      createdAt: json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[CommonKeys.updatedAt] != null ? (json[CommonKeys.updatedAt] as Timestamp).toDate() : null,
      orderId: json[OrderKeys.orderId],
      restaurantId: json[CommonKeys.restaurantId],
      restaurantName: json[RestaurantKeys.restaurantName],
      userLocation: json[OrderKeys.userLocation],
      userAddress: json[OrderKeys.userAddress],
      deliveryBoyLocation: json[OrderKeys.deliveryBoyLocation],
      deliveryBoyId: json[OrderKeys.deliveryBoyId],
      paymentMethod: json[OrderKeys.paymentMethod],
      restaurantCity: json[RestaurantKeys.restaurantCity],
      paymentStatus: json[OrderKeys.paymentStatus],
      deliveryCharge: json[OrderKeys.deliveryCharge],
      id: json[CommonKeys.id],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[OrderKeys.listOfOrder] = this.listOfOrder!.map((e) => e.toJson()).toList();

    data[OrderKeys.totalAmount] = this.totalAmount;
    data[OrderKeys.totalItem] = this.totalItem;
    data[OrderKeys.userId] = this.userId;
    data[OrderKeys.orderId] = this.orderId;
    data[OrderKeys.orderStatus] = this.orderStatus;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    data[CommonKeys.restaurantId] = this.restaurantId;
    data[RestaurantKeys.restaurantName] = this.restaurantName;
    data[OrderKeys.userLocation] = this.userLocation;
    data[OrderKeys.userAddress] = this.userAddress;
    data[OrderKeys.deliveryBoyLocation] = this.deliveryBoyLocation;
    data[OrderKeys.deliveryBoyId] = this.deliveryBoyId;
    data[OrderKeys.paymentMethod] = this.paymentMethod;
    data[RestaurantKeys.restaurantCity] = this.restaurantCity;
    data[OrderKeys.paymentStatus] = this.paymentStatus;
    data[CommonKeys.id] = this.id;
    data[OrderKeys.deliveryCharge] = this.deliveryCharge;
    return data;
  }
}
