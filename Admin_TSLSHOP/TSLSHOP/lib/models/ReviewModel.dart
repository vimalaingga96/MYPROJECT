import 'package:food_delivery_admin/utils/ModelKeys.dart';

class ReviewModel {
  String? id;
  String? review;
  int? rating;
  String? reviewerId;
  String? reviewerName;
  String? reviewerImage;
  String? reviewerLocation;
  List<String>? reviewTags;
  String? restaurantId;

  ReviewModel({this.id, this.restaurantId, this.review, this.rating, this.reviewerId, this.reviewerName, this.reviewerImage, this.reviewerLocation, this.reviewTags});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json[ReviewKey.id],
      review: json[ReviewKey.review],
      rating: json[ReviewKey.rating],
      reviewerId: json[ReviewKey.reviewerId],
      reviewerName: json[ReviewKey.reviewerName],
      reviewerImage: json[ReviewKey.reviewerImage],
      reviewerLocation: json[ReviewKey.reviewerLocation],
      restaurantId: json[ReviewKey.restaurantId],
      reviewTags: json[ReviewKey.reviewTags] != null ? List<String>.from(json[ReviewKey.reviewTags]) : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[ReviewKey.id] = this.id;
    data[ReviewKey.review] = this.review;
    data[ReviewKey.rating] = this.rating;
    data[ReviewKey.reviewerId] = this.reviewerId;
    data[ReviewKey.reviewerName] = this.reviewerName;
    data[ReviewKey.reviewerImage] = this.reviewerImage;
    data[ReviewKey.reviewerLocation] = this.reviewerLocation;
    data[ReviewKey.restaurantId] = this.restaurantId;
    data[ReviewKey.reviewTags] = this.reviewTags;
    return data;
  }
}
