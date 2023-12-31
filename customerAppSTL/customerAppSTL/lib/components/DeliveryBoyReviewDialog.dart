import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/models/DeliveryBoyReviewModel.dart';
import 'package:fooddelivery/models/OrderModel.dart';
import 'package:fooddelivery/services/DeliveryBoyReviewDBService.dart';
import 'package:fooddelivery/utils/ChipsChoice.dart';
import 'package:fooddelivery/utils/Colors.dart';
import 'package:fooddelivery/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

class DeliveryBoyReviewDialog extends StatefulWidget {
  static String tag = '/DeliveryBoyReviewDialog';

  final OrderModel? order;

  DeliveryBoyReviewDialog({this.order});

  @override
  DeliveryBoyReviewDialogState createState() => DeliveryBoyReviewDialogState();
}

class DeliveryBoyReviewDialogState extends State<DeliveryBoyReviewDialog> {
  late DeliveryBoyReviewsDBService deliveryBoyReviewsDBService;

  int ratings = 0;

  TextEditingController tagCont = TextEditingController();
  List<String> tags = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    deliveryBoyReviewsDBService = DeliveryBoyReviewsDBService(restId: widget.order!.deliveryBoyId);
  }

  Future<void> addReview() async {
    if (ratings == 0) {
      toast(appStore.translate('give_rate'));
      return;
    }

    appStore.setLoading(true);

    DeliveryBoyReviewModel reviewModel = DeliveryBoyReviewModel();
    reviewModel.rating = ratings;
    reviewModel.review = tagCont.text;
    reviewModel.userId = appStore.userId;
    reviewModel.userImage = appStore.userProfileImage;
    reviewModel.userName = appStore.userFullName;
    reviewModel.reviewTags = tags;
    reviewModel.deliveryBoyId = widget.order!.deliveryBoyId;
    reviewModel.orderId = widget.order!.id;
    reviewModel.createdAt = DateTime.now();
    reviewModel.updatedAt = DateTime.now();

    deliveryBoyReviewsDBService.addDocument(reviewModel.toJson()).then((res) {
      appStore.setLoading(false);
      finish(context, true);
    }).catchError((error) {
      toast(error.toString());
      appStore.setLoading(false);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 16,
          top: 16,
          child: Icon(Icons.close).onTap(() {
            finish(context);
          }).onTap(() {
            finish(context);
          }),
        ),
        Container(
          color: appStore.isDarkMode ? scaffoldSecondaryDark : white,
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(appStore.translate('rate_experience'), style: boldTextStyle()),
                        10.height,
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 0,
                          allowHalfRating: false,
                          tapOnlyMode: true,
                          itemCount: 5,
                          maxRating: 5,
                          glow: false,
                          unratedColor: grey.withOpacity(0.5),
                          itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                          itemSize: 40,
                          onRatingUpdate: (rating) {
                            ratings = rating.toInt();
                            setState(() {});
                          },
                        ),
                      ],
                    ).paddingAll(16),
                    Divider(),
                    Column(
                      children: <Widget>[
                        Container(
                          child: Text(appStore.translate('rate_another_helps'),style: primaryTextStyle()),
                          padding: EdgeInsets.all(16),
                        ).visible(ratings == 0),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(appStore.translate('share_experience'), style: boldTextStyle()),
                                  4.height,
                                  TextField(
                                    decoration: InputDecoration(hintText: appStore.translate('search_tags'), hintStyle: secondaryTextStyle()),
                                    onSubmitted: (s) {
                                      tags.add(s);
                                      setState(() {});
                                    },
                                  ).visible(false),
                                ],
                              ).paddingAll(16),
                              ChipsChoice<String>.multiple(
                                value: tags,
                                options: ChipsChoiceOption.listFrom<String, String>(
                                  source: ratings >= 4 ? highDeliveryTags() : lowDeliveryTags(),
                                  value: (i, v) => v,
                                  label: (i, v) => v,
                                ),
                                onChanged: (val) => setState(() => tags = val),
                                isWrapped: true,
                                itemConfig: ChipsChoiceItemConfig(selectedColor: colorPrimary, unselectedColor: appStore.isDarkMode ? grey : black),
                              ),
                              Divider(thickness: 3, height: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(appStore.translate('write_review'), style: boldTextStyle()),
                                  4.height,
                                  TextField(
                                    style: primaryTextStyle(),
                                    controller: tagCont,
                                    decoration: InputDecoration(hintText: appStore.translate('hint_review'), hintStyle: secondaryTextStyle()),
                                    textCapitalization: TextCapitalization.sentences,
                                    keyboardType: TextInputType.multiline,
                                    minLines: 4,
                                    maxLines: 10,
                                  ),
                                ],
                              ).paddingAll(16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                AppButton(
                  onTap: () {
                    addReview();
                  },
                  color: colorPrimary,
                  width: context.width() - 10,
                  child: Text(appStore.translate('submit'), style: primaryTextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        ),
        Observer(builder: (_) => Loader().visible(appStore.isLoading)),
      ],
    );
  }
}
