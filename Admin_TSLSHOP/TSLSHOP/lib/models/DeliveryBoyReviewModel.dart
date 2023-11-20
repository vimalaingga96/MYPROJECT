import 'package:food_delivery_admin/utils/ModelKeys.dart';

class DeliveryBoyReviewModel {
  String? id;
  String? review;
  int? rating;
  String? userId;
  String? userName;
  String? userImage;
  List<String>? reviewTags;
  String? deliveryBoyId;
  bool? isReview;
  String? orderID;

  DeliveryBoyReviewModel({this.id, this.review, this.rating, this.userId, this.userName, this.userImage, this.reviewTags, this.deliveryBoyId, this.isReview, this.orderID});

  factory DeliveryBoyReviewModel.fromJson(Map<String, dynamic> json) {
    return DeliveryBoyReviewModel(
      id: json[DeliveryBoyReviewKey.id],
      review: json[DeliveryBoyReviewKey.review],
      rating: json[DeliveryBoyReviewKey.rating],
      userId: json[DeliveryBoyReviewKey.userId],
      userName: json[DeliveryBoyReviewKey.userName],
      userImage: json[DeliveryBoyReviewKey.userImage],
      reviewTags: json[DeliveryBoyReviewKey.reviewTags] != null ? List<String>.from(json[DeliveryBoyReviewKey.reviewTags]) : [],
      deliveryBoyId: json[DeliveryBoyReviewKey.deliveryBoyId],
      isReview: json[DeliveryBoyReviewKey.isReview],
      orderID: json[DeliveryBoyReviewKey.orderID],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[DeliveryBoyReviewKey.id] = this.id;
    data[DeliveryBoyReviewKey.review] = this.review;
    data[DeliveryBoyReviewKey.rating] = this.rating;
    data[DeliveryBoyReviewKey.userId] = this.userId;
    data[DeliveryBoyReviewKey.userName] = this.userName;
    data[DeliveryBoyReviewKey.userImage] = this.userImage;
    data[DeliveryBoyReviewKey.reviewTags] = this.reviewTags;
    data[DeliveryBoyReviewKey.deliveryBoyId] = this.deliveryBoyId;
    data[DeliveryBoyReviewKey.isReview] = this.isReview;
    data[DeliveryBoyReviewKey.orderID] = this.orderID;
    return data;
  }
}
