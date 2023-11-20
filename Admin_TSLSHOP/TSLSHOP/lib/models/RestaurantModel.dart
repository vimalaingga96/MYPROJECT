import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_admin/utils/ModelKeys.dart';

class RestaurantModel {
  String? id;
  String? restaurantName;
  String? restaurantEmail;
  String? restaurantDesc;
  String? photoUrl;
  String? openTime;
  String? closeTime;
  String? restaurantAddress;
  String? restaurantState;
  String? restaurantCity;
  GeoPoint? restaurantLatLng;
  String? restaurantContact;
  bool? isVegRestaurant;
  bool? isNonVegRestaurant;
  bool? isDealOfTheDay;
  String? couponCode;
  String? couponDesc;
  List<String>? caseSearch;
  List<String?>? catList;
  String? ownerId;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isDeleted;
  int?deliveryCharge;

  RestaurantModel({
    this.id,
    this.restaurantName,
    this.restaurantEmail,
    this.restaurantDesc,
    this.photoUrl,
    this.openTime,
    this.closeTime,
    this.restaurantAddress,
    this.restaurantState,
    this.restaurantCity,
    this.restaurantLatLng,
    this.restaurantContact,
    this.isVegRestaurant,
    this.isNonVegRestaurant,
    this.isDealOfTheDay,
    this.couponCode,
    this.couponDesc,
    this.caseSearch,
    this.catList,
    this.ownerId,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.deliveryCharge,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json[RestaurantKey.id],
      restaurantName: json[RestaurantKey.restaurantName],
      restaurantEmail: json[RestaurantKey.restaurantEmail],
      restaurantDesc: json[RestaurantKey.restaurantDesc],
      photoUrl: json[RestaurantKey.photoUrl],
      openTime: json[RestaurantKey.openTime],
      closeTime: json[RestaurantKey.closeTime],
      restaurantAddress: json[RestaurantKey.restaurantAddress],
      restaurantState: json[RestaurantKey.restaurantState],
      restaurantCity: json[RestaurantKey.restaurantCity],
      restaurantLatLng: json[RestaurantKey.restaurantLatLng],
      restaurantContact: json[RestaurantKey.restaurantContact],
      isVegRestaurant: json[RestaurantKey.isVegRestaurant],
      isNonVegRestaurant: json[RestaurantKey.isNonVegRestaurant],
      isDealOfTheDay: json[RestaurantKey.isDealOfTheDay],
      couponCode: json[RestaurantKey.couponCode],
      couponDesc: json[RestaurantKey.couponDesc],
      caseSearch: json[RestaurantKey.caseSearch] != null ? List<String>.from(json[RestaurantKey.caseSearch]) : [],
      catList: json[RestaurantKey.catList] != null ? List<String>.from(json[RestaurantKey.catList]) : [],
      ownerId: json[RestaurantKey.ownerId],
      createdAt: json[TimeDataKey.createdAt] != null ? (json[TimeDataKey.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[TimeDataKey.updatedAt] != null ? (json[TimeDataKey.updatedAt] as Timestamp).toDate() : null,
      isDeleted: json[RestaurantKey.isDeleted],
      deliveryCharge: json[RestaurantKey.deliveryCharge],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data[RestaurantKey.id] = this.id;
    data[RestaurantKey.restaurantName] = this.restaurantName;
    data[RestaurantKey.restaurantEmail] = this.restaurantEmail;
    data[RestaurantKey.restaurantDesc] = this.restaurantDesc;
    data[RestaurantKey.photoUrl] = this.photoUrl;
    data[RestaurantKey.openTime] = this.openTime;
    data[RestaurantKey.closeTime] = this.closeTime;
    data[RestaurantKey.restaurantAddress] = this.restaurantAddress;
    data[RestaurantKey.restaurantState] = this.restaurantState;
    data[RestaurantKey.restaurantCity] = this.restaurantCity;
    data[RestaurantKey.restaurantLatLng] = this.restaurantLatLng;
    data[RestaurantKey.restaurantContact] = this.restaurantContact;
    data[RestaurantKey.isVegRestaurant] = this.isVegRestaurant;
    data[RestaurantKey.isNonVegRestaurant] = this.isNonVegRestaurant;
    data[RestaurantKey.isDealOfTheDay] = this.isDealOfTheDay;
    data[RestaurantKey.couponCode] = this.couponCode;
    data[RestaurantKey.couponDesc] = this.couponDesc;
    data[RestaurantKey.caseSearch] = this.caseSearch;
    data[RestaurantKey.catList] = this.catList;
    data[RestaurantKey.ownerId] = this.ownerId;
    data[TimeDataKey.createdAt] = this.createdAt;
    data[TimeDataKey.updatedAt] = this.updatedAt;
    data[RestaurantKey.isDeleted] = this.isDeleted;
    data[RestaurantKey.deliveryCharge] = this.deliveryCharge;

    return data;
  }
}
