import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:food_delivery_admin/components/AppWidgets.dart';
import 'package:food_delivery_admin/main.dart';
import 'package:food_delivery_admin/models/AddressModel.dart';
import 'package:food_delivery_admin/models/CategoryModel.dart';
import 'package:food_delivery_admin/models/RestaurantModel.dart';
import 'package:food_delivery_admin/models/UserModel.dart';
import 'package:food_delivery_admin/utils/Colors.dart';
import 'package:food_delivery_admin/utils/Common.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../DashboardScreen.dart';

class AddRestaurantDetailScreen extends StatefulWidget {
  static String tag = '/EditRestaurantDetailScreen';

  final RestaurantModel? restaurantModel;
  final bool isEdit;

  AddRestaurantDetailScreen({this.restaurantModel, this.isEdit = false});

  @override
  AddRestaurantDetailScreenState createState() => AddRestaurantDetailScreenState();
}

class AddRestaurantDetailScreenState extends State<AddRestaurantDetailScreen> {
  final kGoogleApiKey = googleMapKey;

  GlobalKey<FormState> _form = GlobalKey<FormState>();
  ScrollController controller = ScrollController();

  TextEditingController restPhotoUrlCont = TextEditingController();
  TextEditingController restNameCont = TextEditingController();
  TextEditingController restAddressCont = TextEditingController();
  TextEditingController restNumberCont = TextEditingController();
  TextEditingController restEmailCont = TextEditingController();
  TextEditingController restDescCont = TextEditingController();
  TextEditingController deliveryCharge = TextEditingController();

  TextEditingController openTimeCont = TextEditingController();
  TextEditingController closeTimeCont = TextEditingController();

  TimeOfDay initialTime = TimeOfDay(hour: 00, minute: 00);

  FocusNode restPhotoUrlNode = FocusNode();
  FocusNode restNameNode = FocusNode();
  FocusNode restAddressNode = FocusNode();
  FocusNode restNumberNode = FocusNode();
  FocusNode restEmailNode = FocusNode();
  FocusNode restDescNode = FocusNode();

  bool? isVeg = false;
  bool? isNonVeg = false;

  List<CategoryModel> category = [];

  List<String?> selectedCatName = [];

  List<UserModel> restaurantManagerList = [];
  UserModel? restaurantManager;

  bool isUpdate = false;

  String? restaurantCity = '';
  String? restaurantAddress = '';
  String? restaurantState = '';

  GeoPoint? restaurantGeoPoint;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.restaurantModel != null;

    categoryService.getCategory(showDeletedItem: false).listen((event) {
      category.addAll(event);
      if (isUpdate) {
        category.forEach((element) {
          if (selectedCatName.contains(element.categoryName)) {
            element.isCheck = true;
          } else {
            element.isCheck = false;
          }
        });
      }
      setState(() {});
    });

    if (getBoolAsync(IS_ADMIN)) {
      userService.getAllUsers(role: REST_MANAGER).listen((event) {
        restaurantManagerList.clear();
        restaurantManagerList.addAll(event);
        restaurantManager = restaurantManagerList.first;
        setState(() {});
      });
    }

    if (isUpdate) {
      RestaurantModel restModel = widget.restaurantModel!;

      restNameCont.text = restModel.restaurantName!;
      restAddressCont.text = restModel.restaurantAddress!;
      restNumberCont.text = restModel.restaurantContact!;
      restEmailCont.text = restModel.restaurantEmail!;
      restDescCont.text = restModel.restaurantDesc!;
      selectedCatName.addAll(restModel.catList!);
      openTimeCont.text = restModel.openTime!;
      closeTimeCont.text = restModel.closeTime!;
      isNonVeg = restModel.isNonVegRestaurant;
      isVeg = restModel.isVegRestaurant;
      restPhotoUrlCont.text = restModel.photoUrl!;
      restaurantCity = restModel.restaurantCity;
      restaurantState = restModel.restaurantState;
      deliveryCharge.text = restModel.deliveryCharge == null ? '' : restModel.deliveryCharge.toString();
    }
  }

  Future<TimeOfDay> timerPicker(BuildContext context) async {
    TimeOfDay? time = await showTimePicker(context: context, initialTime: initialTime);

    if (time != null) {
      return time;
    } else {
      throw appStore.translate('something_went_wrong');
    }
  }

  Future<void> saveDetails() async {
    if (restaurantGeoPoint == null) {
      await getGeoPoint(restAddressCont.text.trim()).then((value) {
        restaurantGeoPoint = value;
        return toast('Please select valid address for restaurant');
      }).catchError((e) {
        return toast(e.toString());
      });
    }

    if (_form.currentState!.validate()) {
      appStore.setLoading(true);
      _form.currentState!.save();

      RestaurantModel restModel = RestaurantModel();

      restModel.restaurantName = restNameCont.text.trim().validate();
      restModel.restaurantAddress = restAddressCont.text.trim().validate();
      restModel.restaurantCity = restaurantCity;
      restModel.restaurantState = restaurantState;
      restModel.restaurantContact = restNumberCont.text.trim().validate();
      restModel.restaurantEmail = restEmailCont.text.trim().validate();
      restModel.restaurantDesc = restDescCont.text.trim().validate();
      restModel.catList = selectedCatName;
      restModel.openTime = openTimeCont.text.trim().validate();
      restModel.closeTime = closeTimeCont.text.trim().validate();
      restModel.caseSearch = setSearchParam(restNameCont.text.trim().validate());
      restModel.isNonVegRestaurant = isNonVeg.validate();
      restModel.isVegRestaurant = isVeg.validate();
      restModel.restaurantLatLng = restaurantGeoPoint;
      restModel.deliveryCharge = deliveryCharge.text.toInt().validate();

      if (restPhotoUrlCont.text.isNotEmpty) {
        restModel.photoUrl = restPhotoUrlCont.text.trim();
      }

      if (isUpdate) {
        restModel.id = widget.restaurantModel!.id;
        restModel.createdAt = widget.restaurantModel!.createdAt;
        restModel.updatedAt = DateTime.now();
        restModel.ownerId = widget.restaurantModel!.ownerId;
        restModel.isDeleted = widget.restaurantModel!.isDeleted;

        //discount and coupon
        restModel.isDealOfTheDay = widget.restaurantModel!.isDealOfTheDay;
        restModel.couponCode = widget.restaurantModel!.couponCode;
        restModel.couponDesc = widget.restaurantModel!.couponDesc;

        await restaurantService.updateDocument(restModel.toJson(), widget.restaurantModel!.id).then((value) async {
          await setValue(RESTAURANT_ID, widget.restaurantModel!.id);
          finish(context);
        }).catchError((error) {
          toast(error.toString());
        });

        appStore.setLoading(false);
      } else {
        restModel.createdAt = DateTime.now();
        restModel.updatedAt = DateTime.now();
        restModel.isDeleted = false;

        if (getBoolAsync(IS_ADMIN)) {
          restModel.ownerId = restaurantManager!.uid;
        } else {
          restModel.ownerId = getStringAsync(USER_ID);
        }

        //discount and coupon
        restModel.isDealOfTheDay = false;
        restModel.couponCode = '';
        restModel.couponDesc = '';

        await restaurantService.addDocument(restModel.toJson()).then((value) async {
          await setValue(RESTAURANT_ID, value.id);
          if (getBoolAsync(IS_ADMIN)) {
            finish(context);
          } else {
            DashboardScreen().launch(context, isNewTask: true);
          }
        }).catchError((error) {
          toast(error.toString());
        });

        await setValue(RESTAURANT_NAME, restNameCont.text.trim());
        await setValue(RESTAURANT_CITY, restaurantCity);

        appStore.setLoading(false);
      }
    }
  }

  Future<GeoPoint?> getGeoPoint(String address) async {
    String url = 'https://maps.google.com/maps/api/geocode/json?key=$googleMapKey&address=${Uri.encodeComponent(address)}';
    Response res = await get(Uri.parse(url));

    if (res.statusCode.isSuccessful()) {
      AddressModel addressModel = AddressModel.fromJson(jsonDecode(res.body));

      if (addressModel.results!.isNotEmpty) {
        AddressResult addressResult = addressModel.results!.first;
        restaurantAddress = addressResult.formatted_address;

        addressResult.address_components!.forEach((element) {
          if (element.types!.contains('locality') || element.types!.contains('sublocality')) {
            restaurantCity = element.long_name;
          }
          if (element.types!.contains('administrative_area_level_1')) {
            restaurantState = element.long_name;
          }
        });

        restaurantGeoPoint = GeoPoint(addressResult.geometry!.location!.lat!, addressResult.geometry!.location!.lng!);
        restAddressCont.text = restaurantAddress!;

        return restaurantGeoPoint;
      } else {
        throw 'Location Not found';
      }
    } else {
      throw appStore.translate('something_went_wrong');
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(appStore.translate('add_restaurant'), showBack: widget.restaurantModel != null || getBoolAsync(IS_ADMIN)),
      body: Container(
        width: context.width(),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appStore.translate('restaurant_detail'), style: boldTextStyle(size: 24)),
                    Divider(height: 32),
                    Row(
                      children: [
                        16.height,
                        Text('${appStore.translate('restaurant_managers')} : ', style: primaryTextStyle()),
                        8.width,
                        DropdownButton<UserModel>(
                            dropdownColor: context.cardColor,
                            value: restaurantManager,
                            hint: Text(appStore.translate('select_restaurant_owner'), style: primaryTextStyle()),
                            onChanged: (manager) {
                              restaurantManager = manager;
                              setState(() {});
                            },
                            items: restaurantManagerList.map<DropdownMenuItem<UserModel>>(
                              (value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value.name.validate(), style: primaryTextStyle()),
                                );
                              },
                            ).toList()),
                      ],
                    ).visible(getBoolAsync(IS_ADMIN) && !widget.isEdit),
                    16.height,
                    Row(
                      children: [
                        cachedImage(restPhotoUrlCont.text.trim(), fit: BoxFit.cover, width: 100, height: 100, radius: 80),
                        24.width,
                        Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(appStore.translate('restaurant_name'), style: primaryTextStyle()),
                                    8.height,
                                    AppTextField(
                                      controller: restNameCont,
                                      focus: restNameNode,
                                      nextFocus: restAddressNode,
                                      textFieldType: TextFieldType.NAME,
                                      errorThisFieldRequired: appStore.translate('this_field_is_required'),
                                      decoration: inputDecoration(hintText: appStore.translate('enter_restaurant_name')),
                                    ),
                                  ],
                                ).expand(),
                                16.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(appStore.translate('restaurant_email'), style: primaryTextStyle()),
                                    8.height,
                                    AppTextField(
                                      controller: restEmailCont,
                                      focus: restEmailNode,
                                      nextFocus: restDescNode,
                                      textFieldType: TextFieldType.EMAIL,
                                      errorThisFieldRequired: appStore.translate('this_field_is_required'),
                                      errorInvalidEmail: emailError,
                                      decoration: inputDecoration(hintText: appStore.translate('enter_email_address')),
                                    ),
                                  ],
                                ).expand(),
                              ],
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(appStore.translate('restaurant_image_url'), style: primaryTextStyle()),
                                    8.height,
                                    AppTextField(
                                      controller: restPhotoUrlCont,
                                      focus: restPhotoUrlNode,
                                      nextFocus: restNameNode,
                                      textFieldType: TextFieldType.NAME,
                                      errorThisFieldRequired: appStore.translate('this_field_is_required'),
                                      decoration: inputDecoration(hintText: appStore.translate('enter_restaurant_image_url')),
                                      onFieldSubmitted: (val) {
                                        restPhotoUrlCont.text = val;
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ).expand(),
                                16.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(appStore.translate('restaurant_contact'), style: primaryTextStyle()),
                                    8.height,
                                    AppTextField(
                                      controller: restNumberCont,
                                      focus: restNumberNode,
                                      nextFocus: restEmailNode,
                                      textFieldType: TextFieldType.PHONE,
                                      maxLength: 10,
                                      errorThisFieldRequired: appStore.translate('this_field_is_required'),
                                      decoration: inputDecoration(hintText: appStore.translate('enter_contact_number')),
                                    ),
                                  ],
                                ).expand(),
                              ],
                            ),
                          ],
                        ).expand()
                      ],
                    ),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 230,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.3)), borderRadius: BorderRadius.circular(8)),
                          child: Scrollbar(
                            controller: controller,
                            isAlwaysShown: true,
                            showTrackOnHover: true,
                            child: SingleChildScrollView(
                              controller: controller,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(appStore.translate('select_categories'), style: primaryTextStyle(size: 22)),
                                  Divider(),
                                  Column(
                                    children: category.map((e) {
                                      return Row(
                                        children: [
                                          Checkbox(
                                            value: e.isCheck,
                                            onChanged: (val) {
                                              e.isCheck = val;
                                              if (e.isCheck!) {
                                                selectedCatName.add(e.categoryName);
                                              } else if (!e.isCheck!) {
                                                selectedCatName.remove(e.categoryName);
                                              }
                                              setState(() {});
                                            },
                                          ),
                                          Text(e.categoryName.validate(), style: primaryTextStyle())
                                        ],
                                      ).paddingOnly(top: 4, bottom: 4).onTap(() {
                                        e.isCheck = !e.isCheck!;
                                        if (e.isCheck!) {
                                          selectedCatName.add(e.categoryName);
                                        } else if (!e.isCheck!) {
                                          selectedCatName.remove(e.categoryName);
                                        }
                                        setState(() {});
                                      });
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ).expand(),
                        16.width,
                        Container(
                          height: 230,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.3)), borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(appStore.translate('select_food_types'), style: primaryTextStyle(size: 22)),
                              Divider(),
                              Row(
                                children: [
                                  Checkbox(
                                    value: isVeg,
                                    onChanged: (val) {
                                      isVeg = val;
                                      setState(() {});
                                    },
                                  ),
                                  Text(appStore.translate('vegetarian'), style: primaryTextStyle())
                                ],
                              ).paddingOnly(top: 4, bottom: 4).onTap(() {
                                isVeg = !isVeg!;
                                setState(() {});
                              }),
                              Row(
                                children: [
                                  Checkbox(
                                    value: isNonVeg,
                                    onChanged: (val) {
                                      isNonVeg = val;
                                      setState(() {});
                                    },
                                  ),
                                  Text(appStore.translate('nonVegetarian'), style: primaryTextStyle())
                                ],
                              ).paddingOnly(top: 4, bottom: 4).onTap(() {
                                isNonVeg = !isNonVeg!;
                                setState(() {});
                              }),
                            ],
                          ),
                        ).expand(),
                      ],
                    ),
                    16.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appStore.translate('delivery_charges'), style: primaryTextStyle()),
                        8.height,
                        AppTextField(
                          controller: deliveryCharge,
                          textFieldType: TextFieldType.PHONE,
                          maxLength: 10,
                          decoration: inputDecoration(hintText: 'Delivery Charge'),
                          errorThisFieldRequired: appStore.translate('this_field_is_required'),
                        ),
                        Text(appStore.translate('restaurant_address'), style: primaryTextStyle()),
                        8.height,
                        AppTextField(
                          controller: restAddressCont,
                          focus: restAddressNode,
                          nextFocus: restNumberNode,
                          minLines: 3,
                          maxLines: 10,
                          textFieldType: TextFieldType.ADDRESS,
                          decoration: inputDecoration(hintText: appStore.translate('enter_restaurant_address')),
                          onTap: () {
                            //getAddress();
                          },
                          validator: (s) {
                            if (s!.isEmpty) {
                              return appStore.translate('this_field_is_required');
                            }
                            return null;
                          },
                        ),
                        16.height,
                        AppButton(
                          text: appStore.translate('get_address'),
                          textStyle: primaryTextStyle(),
                          onTap: () async {
                            await getGeoPoint(restAddressCont.text.trim()).then((value) {
                              restaurantGeoPoint = value;
                              setState(() {});
                            }).catchError((e) {
                              toast(e.toString());
                            });
                          },
                        )
                      ],
                    ),
                    16.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appStore.translate('description'), style: primaryTextStyle()),
                        8.height,
                        AppTextField(
                          controller: restDescCont,
                          focus: restDescNode,
                          minLines: 3,
                          maxLines: 10,
                          textFieldType: TextFieldType.ADDRESS,
                          errorThisFieldRequired: appStore.translate('this_field_is_required'),
                          decoration: inputDecoration(hintText: appStore.translate('enter_description')),
                          isValidationRequired: false,
                        ),
                      ],
                    ),
                    16.height,
                    Row(
                      children: [
                        Text('Shop Timing : ', style: primaryTextStyle(size: 10)),
                        8.width,
                        Container(
                          width: 100,
                          child: AppTextField(
                            controller: openTimeCont,
                            textFieldType: TextFieldType.OTHER,
                            errorInvalidEmail: emailError,
                            decoration: inputDecoration(hintText: appStore.translate('open_time')),
                            validator: (s) {
                              if (s!.isEmpty) {
                                return appStore.translate('this_field_is_required');
                              }
                              return null;
                            },
                            onTap: () {
                              timerPicker(context).then((value) {
                                openTimeCont.text = '${value.format(context)}';
                              }).catchError((error) {
                                toast(error.toString());
                              });
                            },
                          ),
                        ),
                        8.width,
                        Text(appStore.translate('to'), style: primaryTextStyle(size: 10)),
                        8.width,
                        Container(
                          width: 100,
                          child: AppTextField(
                            controller: closeTimeCont,
                            textFieldType: TextFieldType.OTHER,
                            errorInvalidEmail: 'Invalid email address',
                            decoration: inputDecoration(hintText: appStore.translate('close_time')),
                            validator: (s) {
                              if (s!.isEmpty) {
                                return appStore.translate('this_field_is_required');
                                ;
                              }
                              return null;
                            },
                            onTap: () {
                              timerPicker(context).then((value) {
                                closeTimeCont.text = '${value.format(context)}';
                              }).catchError((error) {
                                toast(error.toString());
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    16.height,
                    AppButton(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                      onTap: () async {
                        if (getBoolAsync(IS_TESTER)) {
                          finish(context);
                          return toast(appStore.translate('mTesterNotAllowedMsg'));
                        } else {
                          saveDetails();
                        }
                      },
                      textStyle: primaryTextStyle(color: white),
                      color: colorPrimary,
                      child: Text(appStore.translate('save_details'), style: primaryTextStyle(size: 18, color: white)),
                    ),
                  ],
                ),
              ),
            ),
            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
