class Collect {
  static String restaurants = 'restaurants';
  static String users = 'users';
  static String orders = 'orders';
  static String menu = 'menu';
  static String categories = 'categories';
  static String reviews = 'reviews';
  static String deliveryBoyReviews = 'deliveryBoyReviews';
}

class TimeDataKey {
  static String createdAt = 'createdAt';
  static String updatedAt = 'updatedAt';
}

class UserKeys {
  static String uid = 'uid';
  static String name = 'name';
  static String email = 'email';
  static String password = 'password';
  static String loginType = 'loginType';
  static String isAdmin = 'isAdmin';
  static String role = 'role';
  static String photoUrl = 'photoUrl';
  static String type = 'type';
  static String isDeleted = 'isDeleted';
  static String oneSignalPlayerId = 'oneSignalPlayerId';
  static String isTester = 'isTester';
  static String availabilityStatus = 'availabilityStatus';
}

class RestaurantKey {
  static String id = 'id';
  static String restaurantName = 'restaurantName';
  static String restaurantEmail = 'restaurantEmail';
  static String restaurantDesc = 'restaurantDesc';
  static String photoUrl = 'photoUrl';
  static String openTime = 'openTime';
  static String closeTime = 'closeTime';
  static String restaurantAddress = 'restaurantAddress';
  static String restaurantState = 'restaurantState';
  static String restaurantCity = 'restaurantCity';
  static String restaurantLatLng = 'restaurantLatLng';
  static String restaurantContact = 'restaurantContact';
  static String isVegRestaurant = 'isVegRestaurant';
  static String isNonVegRestaurant = 'isNonVegRestaurant';
  static String isDealOfTheDay = 'isDealOfTheDay';
  static String couponCode = 'couponCode';
  static String couponDesc = 'couponDesc';
  static String caseSearch = 'caseSearch';
  static String catList = 'catList';
  static String ownerId = 'ownerId';
  static String isDeleted = 'isDeleted';
  static String deliveryCharge = 'deliveryCharge';
}

class CategoryKey {
  static String id = 'id';
  static String categoryName = 'categoryName';
  static String image = 'image';
  static String color = 'color';
  static String isDeleted = 'isDeleted';
}

class OrderKey {
  static String id = 'id';
  static String orderId = 'orderId';
  static String listOfOrder = 'listOfOrder';
  static String restaurantId = 'restaurantId';
  static String restaurantName = 'restaurantName';
  static String restaurantCity = 'restaurantCity';
  static String totalPrice = 'totalAmount';
  static String totalItem = 'totalItem';
  static String userAddress = 'userAddress';
  static String userID = 'userId';
  static String orderStatus = 'orderStatus';
  static String deliveryBoyId = 'deliveryBoyId';
  static String paymentMethod = 'paymentMethod';
  static String city = 'city';
  static String paymentStatus = 'paymentStatus';
  static String totalAmount = 'totalAmount';
}

class OrderItemKey {
  static String id = 'id';
  static String catId = 'catId';
  static String catName = 'catName';
  static String itemName = 'itemName';
  static String itemPrice = 'itemPrice';
  static String qty = 'qty';
}

class MenuItemKey {
  static String id = 'id';
  static String itemName = 'itemName';
  static String ingredientsTags = 'ingredientsTags';
  static String itemPrice = 'itemPrice';
  static String inStock = 'inStock';
  static String categoryId = 'categoryId';
  static String restaurantId = 'restaurantId';
  static String restaurantName = 'restaurantName';
  static String categoryName = 'categoryName';
  static String image = 'image';
  static String description = 'description';
  static String isDeleted = 'isDeleted';
}

class DeliveryBoyReviewKey {
  static String deliveryBoyId = 'deliveryBoyId';
  static String id = 'id';
  static String isReview = 'isReview';
  static String orderID = 'orderID';
  static String rating = 'rating';
  static String review = 'review';
  static String reviewTags = 'reviewTags';
  static String userId = 'userId';
  static String userName = 'userName';
  static String userImage = 'userImage';
}

class ReviewKey {
  static String id = 'id';
  static String rating = 'rating';
  static String restaurantId = 'restaurantId';
  static String review = 'review';
  static String reviewerId = 'reviewerId';
  static String reviewTags = 'reviewTags';
  static String reviewerName = 'reviewerName';
  static String reviewerImage = 'reviewerImage';
  static String reviewerLocation = 'reviewerLocation';
}

class OrderTableKey {
  static String orderId = 'OrderID';
  static String dateTime = 'Date & Time';
  static String amount = 'Amount';
  static String orderStatus = 'Order status';
  static String restaurantName = 'Restaurant name';
  static String paymentStatus = 'Payment status';
  static String paymentMethod = 'Payment method';
}

class MenuTableKey {
  static String image = 'Image';
  static String name = 'Name';
  static String description = 'Description';
  static String category = 'Category';
  static String price = 'Price';
  static String action = 'Action';
}

class DeliverTableKey {
  static String name = 'Name';
  static String email = 'Email';
  static String deliveryStatus = 'Delivery Status';
}

class AppSettingKeys {
  static String disableAd = 'disableAd';
  static String termCondition = 'termCondition';
  static String privacyPolicy = 'privacyPolicy';
  static String contactInfo = 'contactInfo';
}

class AddressKey {
  static String results = 'results';
  static String status = 'status';
}

class AddressResultKey {
  static String address_components = 'address_components';
  static String formatted_address = 'formatted_address';
  static String geometry = 'geometry';
  static String place_id = 'place_id';
}

class AddressComponentKey {
  static String long_name = 'long_name';
  static String short_name = 'short_name';
  static String types = 'types';
}

class GeometryKey {
  static String location = 'location';
}

class LocationKey {
  static String lat = 'lat';
  static String lng = 'lng';
}
