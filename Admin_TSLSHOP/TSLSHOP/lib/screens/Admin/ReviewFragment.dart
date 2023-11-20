import 'package:flutter/material.dart';
import 'package:food_delivery_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewFragment extends StatefulWidget {
  static String tag = '/ReviewFragment';
  final bool isRestReview;

  ReviewFragment({this.isRestReview = false});

  @override
  ReviewFragmentState createState() => ReviewFragmentState();
}

class ReviewFragmentState extends State<ReviewFragment> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(widget.isRestReview ? appStore.translate('restaurant_review') : appStore.translate('delivery_boy_review'), showBack: false, elevation: 0),
    );
  }
}
