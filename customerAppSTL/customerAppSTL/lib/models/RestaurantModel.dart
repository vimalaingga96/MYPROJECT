import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fooddelivery/utils/ModalKeys.dart';

class RestaurantModel {
  String? id;
  String? restaurantName;
  String? categoryId;
  String? photoUrl;
  String? openTime;
  String? closeTime;
  String? restaurantAddress;
  String? restaurantContact;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isVegRestaurant;
  bool? isNonVegRestaurant;
  bool? isDealOfTheDay;
  String? couponCode;
  String? couponDesc;
  List<String>? caseSearch;
  String? restaurantDesc;
  List<String>? catList;
  String? restaurantCity;
  int?deliveryCharge;

  RestaurantModel({
    this.restaurantName,
    this.id,
    this.photoUrl,
    this.openTime,
    this.closeTime,
    this.restaurantAddress,
    this.restaurantContact,
    this.isVegRestaurant,
    this.isNonVegRestaurant,
    this.createdAt,
    this.updatedAt,
    this.isDealOfTheDay,
    this.couponCode,
    this.couponDesc,
    this.caseSearch,
    this.restaurantDesc,
    this.catList,
    this.restaurantCity,
    this.deliveryCharge,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json[CommonKeys.id],
      restaurantName: json[RestaurantKeys.restaurantName],
      photoUrl: json[RestaurantKeys.photoUrl],
      openTime: json[RestaurantKeys.openTime],
      closeTime: json[RestaurantKeys.closeTime],
      restaurantAddress: json[RestaurantKeys.restaurantAddress],
      restaurantContact: json[RestaurantKeys.restaurantContact],
      isVegRestaurant: json[RestaurantKeys.isVegRestaurant],
      isNonVegRestaurant: json[RestaurantKeys.isNonVegRestaurant],
      isDealOfTheDay: json[RestaurantKeys.isDealOfTheDay],
      couponCode: json[RestaurantKeys.couponCode],
      couponDesc: json[RestaurantKeys.couponDesc],
      caseSearch: json[RestaurantKeys.caseSearch] != null ? List<String>.from(json[RestaurantKeys.caseSearch]) : [],
      createdAt: json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[CommonKeys.updatedAt] != null ? (json[CommonKeys.updatedAt] as Timestamp).toDate() : null,
      restaurantDesc: json[RestaurantKeys.restaurantDesc],
      catList: json[RestaurantKeys.catList] != null ? List<String>.from(json[RestaurantKeys.catList]) : [],
      restaurantCity: json[RestaurantKeys.restaurantCity],
      deliveryCharge: json[RestaurantKeys.deliveryCharge],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[RestaurantKeys.restaurantName] = this.restaurantName;
    data[RestaurantKeys.photoUrl] = this.photoUrl;
    data[RestaurantKeys.openTime] = this.openTime;
    data[RestaurantKeys.closeTime] = this.closeTime;
    data[RestaurantKeys.restaurantAddress] = this.restaurantAddress;
    data[RestaurantKeys.restaurantContact] = this.restaurantContact;
    data[RestaurantKeys.isVegRestaurant] = this.isVegRestaurant;
    data[RestaurantKeys.isNonVegRestaurant] = this.isNonVegRestaurant;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    data[RestaurantKeys.isDealOfTheDay] = this.isDealOfTheDay;
    data[RestaurantKeys.couponCode] = this.couponCode;
    data[RestaurantKeys.couponDesc] = this.couponDesc;
    data[RestaurantKeys.caseSearch] = this.caseSearch;
    data[RestaurantKeys.restaurantDesc] = this.restaurantDesc;
    data[RestaurantKeys.catList] = this.catList;
    data[RestaurantKeys.restaurantCity] = this.restaurantCity;
    data[RestaurantKeys.deliveryCharge] = this.deliveryCharge;
    return data;
  }
}
