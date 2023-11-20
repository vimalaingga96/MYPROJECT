import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fooddelivery/utils/ModalKeys.dart';

class MenuModel {
  String? id;
  String? itemName;
  List<String>? ingredientsTags;
  int? itemPrice;
  bool? inStock;
  String? categoryId;
  String? restaurantId;
  String? restaurantName;
  String? categoryName;
  String? image;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isDeleted;

  //local
  int? qty;
  bool? isCheck;

  MenuModel({
    this.itemName,
    this.id,
    this.ingredientsTags,
    this.image,
    this.itemPrice,
    this.inStock,
    this.categoryId,
    this.categoryName,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.restaurantId,
    this.restaurantName,
    this.qty = 1,
    this.isDeleted,
    this.isCheck= false,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json[CommonKeys.id],
      itemName: json[CommonKeys.itemName],
      image: json[CommonKeys.image],
      itemPrice: json[CommonKeys.itemPrice],
      inStock: json[MenuKeys.inStock],
      categoryId: json[CommonKeys.categoryId],
      categoryName: json[CommonKeys.categoryName],
      description: json[MenuKeys.description],
      restaurantId: json[MenuKeys.restaurantId],
      qty: json['qty'] != null ? json['qty'] : 1,
      restaurantName: json[RestaurantKeys.restaurantName],
      ingredientsTags: json[MenuKeys.ingredientsTags] != null ? List<String>.from(json[MenuKeys.ingredientsTags]) : [],
      createdAt: json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[CommonKeys.updatedAt] != null ? (json[CommonKeys.updatedAt] as Timestamp).toDate() : null,
      isDeleted: json[CommonKeys.isDeleted],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[CommonKeys.itemName] = this.itemName;
    data[CommonKeys.image] = this.image;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    data[CommonKeys.itemPrice] = this.itemPrice;
    data[MenuKeys.inStock] = this.inStock;
    data[CommonKeys.categoryId] = this.categoryId;
    data[CommonKeys.categoryName] = this.categoryName;
    data[MenuKeys.ingredientsTags] = this.ingredientsTags;
    data[MenuKeys.description] = this.description;
    data[MenuKeys.restaurantId] = this.restaurantId;
    data[RestaurantKeys.restaurantName] = this.restaurantName;
    data[CommonKeys.isDeleted] = this.isDeleted;
    data['qty'] = this.qty;
    return data;
  }
}
