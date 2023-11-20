import 'package:flutter/material.dart';
import 'package:food_delivery_admin/components/AppWidgets.dart';
import 'package:food_delivery_admin/models/CategoryModel.dart';
import 'package:food_delivery_admin/models/MenuModel.dart';
import 'package:food_delivery_admin/models/RestaurantModel.dart';
import 'package:food_delivery_admin/utils/Common.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

class AddMenuItemDetails extends StatefulWidget {
  static String tag = '/AddMenuItemDetails';
  final MenuModel? menuModel;

  final RestaurantModel? restaurantModel;

  AddMenuItemDetails({this.menuModel, this.restaurantModel});

  @override
  AddMenuItemDetailsState createState() => AddMenuItemDetailsState();
}

class AddMenuItemDetailsState extends State<AddMenuItemDetails> {
  ScrollController controller = ScrollController();
  GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController itemImageUrlCont = TextEditingController();
  TextEditingController itemNameCont = TextEditingController();
  TextEditingController itemPriceCont = TextEditingController();
  TextEditingController itemDescriptionCont = TextEditingController();
  TextEditingController ingredientCont = TextEditingController();

  FocusNode itemImageUrlNode = FocusNode();
  FocusNode itemNameNode = FocusNode();
  FocusNode itemPriceNode = FocusNode();
  FocusNode itemDescriptionNode = FocusNode();
  FocusNode itemIngredientNode = FocusNode();

  List<CategoryModel> categoryList = [];

  String? categoryName = '';
  String? categoryId = '';
  List<String>? ingredientList = [];

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.menuModel != null;

    categoryService.getCategory(showDeletedItem: false).listen((event) {
      categoryList.clear();
      categoryList.addAll(event);
      if (isUpdate) {
        categoryName = widget.menuModel!.categoryName;
      } else {
        categoryName = categoryList[0].categoryName;
        categoryId = categoryList[0].id;
      }
      setState(() {});
    });

    if (isUpdate) {
      itemNameCont.text = widget.menuModel!.itemName!;
      itemPriceCont.text = widget.menuModel!.itemPrice.toString();
      itemDescriptionCont.text = widget.menuModel!.description!;
      ingredientList = widget.menuModel!.ingredientsTags;
      categoryId = widget.menuModel!.categoryId;
      itemImageUrlCont.text = widget.menuModel!.image!;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        appStore.translate('add_menu_item_details'),
        actions: [
          TextButton(
            child: Text(appStore.translate('save'), style: primaryTextStyle()),
            onPressed: () {
              if (getBoolAsync(IS_TESTER)) {
                finish(context);
                return toast(appStore.translate('mTesterNotAllowedMsg'));
              } else {
                finish(context);
                saveItemData();
              }
            },
          ).paddingRight(8)
        ],
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(appStore.translate('select_image'), style: primaryTextStyle()),
              8.height,
              cachedImage(itemImageUrlCont.text.validate().validate(), fit: BoxFit.cover, width: 150, height: 150).cornerRadiusWithClipRRect(100),
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: context.width(),
                          decoration: BoxDecoration(
                            color: appStore.isDarkMode ? context.cardColor : Colors.grey.shade200,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                          ),
                          child: Text(appStore.translate('item_details'), style: primaryTextStyle(size: 18)).paddingAll(16),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(appStore.translate('image_url'), style: primaryTextStyle()),
                            8.height,
                            AppTextField(
                              controller: itemImageUrlCont,
                              focus: itemImageUrlNode,
                              nextFocus: itemNameNode,
                              textFieldType: TextFieldType.NAME,
                              errorThisFieldRequired : appStore.translate('this_field_is_required'),
                              decoration: inputDecoration(hintText: appStore.translate('image_url')),
                              onFieldSubmitted: (val) {
                                itemImageUrlCont.text = val;
                                setState(() {});
                              },
                            ),
                          ],
                        ).paddingAll(8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(appStore.translate('item_name'), style: primaryTextStyle()),
                            8.height,
                            AppTextField(
                              controller: itemNameCont,
                              focus: itemNameNode,
                              nextFocus: itemPriceNode,
                              textFieldType: TextFieldType.NAME,
                              errorThisFieldRequired : appStore.translate('this_field_is_required'),
                              decoration: inputDecoration(hintText: appStore.translate('item_name')),
                            ),
                          ],
                        ).paddingAll(8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(appStore.translate('price'), style: primaryTextStyle()),
                            8.height,
                            AppTextField(
                              controller: itemPriceCont,
                              focus: itemPriceNode,
                              nextFocus: itemDescriptionNode,
                              textFieldType: TextFieldType.NAME,
                              errorThisFieldRequired : appStore.translate('this_field_is_required'),
                              decoration: inputDecoration(hintText: appStore.translate('price')),
                            ),
                          ],
                        ).paddingAll(8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(appStore.translate('description'), style: primaryTextStyle()),
                            8.height,
                            AppTextField(
                              controller: itemDescriptionCont,
                              focus: itemDescriptionNode,
                              nextFocus: itemIngredientNode,
                              errorThisFieldRequired : appStore.translate('this_field_is_required'),
                              textFieldType: TextFieldType.ADDRESS,
                              // minLines: 3,
                              decoration: inputDecoration(hintText: appStore.translate('description')),
                            ),
                          ],
                        ).paddingAll(8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(appStore.translate('ingredients'), style: primaryTextStyle()),
                            8.height,
                            TextField(
                              controller: ingredientCont,
                              focusNode: itemIngredientNode,
                              decoration: inputDecoration(hintText: appStore.translate('ingredients')),
                              onEditingComplete: () {
                                if (ingredientCont.text.isNotEmpty) {
                                  ingredientList!.add(ingredientCont.text);
                                  ingredientCont.clear();
                                  setState(() {});
                                }
                              },
                            ),
                            16.height,
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: ingredientList!.map(
                                (e) {
                                  return InputChip(
                                    label: Text(e, style: TextStyle(color: Colors.white, fontSize: 16)),
                                    backgroundColor: Colors.redAccent,
                                    deleteIconColor: Colors.white,
                                    onDeleted: () {
                                      ingredientList!.remove(e);
                                      setState(() {});
                                    },
                                  );
                                },
                              ).toList(),
                            )
                          ],
                        ).paddingAll(8),
                      ],
                    ),
                  ).expand(),
                  16.width,
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: context.width(),
                          decoration: BoxDecoration(
                            color: appStore.isDarkMode ? context.cardColor : Colors.grey.shade200,
                            border: Border.all(color: appStore.isDarkMode ? context.cardColor : Colors.grey.shade300),
                            borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                          ),
                          child: Text(appStore.translate('item_category'), style: primaryTextStyle(size: 18)).paddingAll(16),
                        ),
                        SingleChildScrollView(
                          controller: controller,
                          child: Column(
                            children: categoryList.map((e) {
                              return RadioListTile(
                                value: e.categoryName,
                                groupValue: categoryName,
                                onChanged: (dynamic val) {
                                  categoryName = val;
                                  categoryId = e.id;
                                  setState(() {});
                                },
                                title: Text(e.categoryName.validate(), style: primaryTextStyle()),
                              );
                            }).toList(),
                          ).paddingAll(8),
                        ),
                      ],
                    ),
                  ).expand(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveItemData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      MenuModel data = MenuModel();

      data.itemName = itemNameCont.text.trim();
      data.itemPrice = itemPriceCont.text.trim().toInt();
      data.description = itemDescriptionCont.text.trim();
      data.ingredientsTags = ingredientList;
      data.categoryId = categoryId;
      data.categoryName = categoryName;
      if (itemImageUrlCont.text.isNotEmpty) {
        data.image = itemImageUrlCont.text.trim();
      }

      if (isUpdate) {
        data.id = widget.menuModel!.id;
        data.restaurantId = widget.menuModel!.restaurantId;
        data.restaurantName = widget.menuModel!.restaurantName;
        data.inStock = widget.menuModel!.inStock;
        data.createdAt = widget.menuModel!.createdAt;
        data.updatedAt = DateTime.now();
        data.isDeleted = widget.menuModel!.isDeleted;

        menuItemService.updateDocument(data.toJson(), widget.menuModel!.id).then((value) {
          //
        }).catchError((error) {
          toast(error.toString());
        });
      } else {
        if (getBoolAsync(IS_ADMIN)) {
          data.restaurantId = widget.restaurantModel!.id;
          data.restaurantName = widget.restaurantModel!.restaurantName;
        } else {
          data.restaurantId = getStringAsync(RESTAURANT_ID);
          data.restaurantName = getStringAsync(RESTAURANT_NAME);
        }

        data.inStock = true;
        data.createdAt = DateTime.now();
        data.updatedAt = DateTime.now();
        data.isDeleted = false;

        menuItemService.addDocument(data.toJson()).then((value) {
          //
        }).catchError((error) {
          toast(error.toString());
        });
      }
      finish(context);
    }
  }
}
