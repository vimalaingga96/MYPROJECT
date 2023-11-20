import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_admin/utils/ModelKeys.dart';

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

  DocumentReference? restRef;

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
    this.isDeleted,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json[MenuItemKey.id],
      itemName: json[MenuItemKey.itemName],
      image: json[MenuItemKey.image],
      itemPrice: json[MenuItemKey.itemPrice],
      inStock: json[MenuItemKey.inStock],
      categoryId: json[MenuItemKey.categoryId],
      categoryName: json[MenuItemKey.categoryName],
      description: json[MenuItemKey.description],
      restaurantId: json[MenuItemKey.restaurantId],
      restaurantName: json[MenuItemKey.restaurantName],
      ingredientsTags: json[MenuItemKey.ingredientsTags] != null ? List<String>.from(json[MenuItemKey.ingredientsTags]) : [],
      createdAt: json[TimeDataKey.createdAt] != null ? (json[TimeDataKey.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[TimeDataKey.updatedAt] != null ? (json[TimeDataKey.updatedAt] as Timestamp).toDate() : null,
      isDeleted: json[MenuItemKey.isDeleted],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[MenuItemKey.id] = this.id;
    data[MenuItemKey.itemName] = this.itemName;
    data[MenuItemKey.image] = this.image;
    data[MenuItemKey.itemPrice] = this.itemPrice;
    data[MenuItemKey.inStock] = this.inStock;
    data[MenuItemKey.categoryId] = this.categoryId;
    data[MenuItemKey.categoryName] = this.categoryName;
    data[MenuItemKey.ingredientsTags] = this.ingredientsTags;
    data[MenuItemKey.description] = this.description;
    data[MenuItemKey.restaurantId] = this.restaurantId;
    data[MenuItemKey.restaurantName] = this.restaurantName;
    data[TimeDataKey.createdAt] = this.createdAt;
    data[TimeDataKey.updatedAt] = this.updatedAt;
    data[MenuItemKey.isDeleted] = this.isDeleted;
    return data;
  }
}
