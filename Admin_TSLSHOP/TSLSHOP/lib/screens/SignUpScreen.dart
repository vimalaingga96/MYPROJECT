import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:food_delivery_admin/screens/RestaurantManager/AddRestaurantDetailScreen.dart';
import 'package:food_delivery_admin/screens/SignInScreen.dart';
import 'package:food_delivery_admin/utils/Colors.dart';
import 'package:food_delivery_admin/utils/Common.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailTextCont = TextEditingController();
  TextEditingController nameTextCont = TextEditingController();
  TextEditingController passWordCont = TextEditingController();
  TextEditingController confirmPassWordCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  FocusNode confPassFocus = FocusNode();

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
      body: Container(
        alignment: Alignment.center,
        width: 500,
        height: 600,
        decoration: boxDecorationWithShadow(
          borderRadius: radius(),
          backgroundColor: context.cardColor,
          shadowColor: shadowColorGlobal,
          spreadRadius: defaultSpreadRadius,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Image.asset('images/logo.png', height: 150, fit: BoxFit.cover),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('TSL',
                            style:
                            boldTextStyle(color: colorPrimary, size: 24)),
                        2.width,
                        Text('Shop', style: boldTextStyle(size: 24)),
                        2.width,
                        Text('Admin', style: boldTextStyle(size: 24)),
                      ],
                    ),
                    16.height,
                    AppTextField(
                      controller: nameTextCont,
                      textFieldType: TextFieldType.NAME,
                      keyboardType: TextInputType.name,
                      decoration: inputDecoration(hintText: appStore.translate('enter_your_username'), labelText: appStore.translate('username')),
                      nextFocus: emailFocus,
                      autoFocus: true,
                      errorThisFieldRequired: appStore.translate('this_field_is_required'),
                    ),
                    16.height,
                    AppTextField(
                      controller: emailTextCont,
                      textFieldType: TextFieldType.EMAIL,
                      focus: passFocus,
                      decoration: inputDecoration(hintText: appStore.translate('enter_email_address'), labelText: appStore.translate('email_address')),
                      errorInvalidEmail: emailError,
                      errorThisFieldRequired: appStore.translate('this_field_is_required'),
                      onFieldSubmitted: (s) {
                        //
                      },
                    ),
                    16.height,
                    AppTextField(
                      controller: passWordCont,
                      textFieldType: TextFieldType.PASSWORD,
                      focus: confPassFocus,
                      decoration: inputDecoration(hintText: appStore.translate('enter_your_password'), labelText: appStore.translate('password')),
                      errorThisFieldRequired: appStore.translate('this_field_is_required'),
                      onFieldSubmitted: (s) {
                        //
                      },
                    ),
                    16.height,
                    AppTextField(
                      controller: confirmPassWordCont,
                      textFieldType: TextFieldType.PASSWORD,
                      decoration: inputDecoration(hintText: appStore.translate('enter_your_confirm_password'), labelText: appStore.translate('confirm_password')),
                      onFieldSubmitted: (s) {
                        signUp();
                      },
                      validator: (value) {
                        if (value!.trim().isEmpty) return appStore.translate('this_field_is_required');
                        if (value.trim().length < passwordLengthGlobal) return '${appStore.translate('password_length_should_be_more_than')} $passwordLengthGlobal';
                        return passWordCont.text == value.trim() ? null : '${appStore.translate('password_does_not_match')}';
                      },
                    ),
                    16.height,
                    Container(
                      child: AppButton(
                        height: 50,
                        text: appStore.translate('sign_up'),
                        textStyle: primaryTextStyle(color: white),
                        color: colorPrimary,
                        onTap: () {
                          signUp();
                        },
                        width: context.width(),
                      ),
                    ).cornerRadiusWithClipRRect(defaultRadius),
                    16.height,
                    Text(appStore.translate('have_an_account'), style: primaryTextStyle()).onTap(() {
                      SignInScreen().launch(context);
                    })
                  ],
                ),
              ),
            ),
            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
          ],
        ),
      ).center(),
    );
  }

  void signUp() {
    if (formKey.currentState!.validate()) {
      appStore.setLoading(true);
      service.signUpWithEmailPassword(email: emailTextCont.text.trim(), password: passWordCont.text.trim(), displayName: nameTextCont.text.trim(), role: REST_MANAGER).then((value) async {
        await setValue(IS_LOGGED_IN, true);

        if (getBoolAsync(IS_ADMIN) || getBoolAsync(IS_TESTER)) {
          SignInScreen().launch(context);
        } else {
          AddRestaurantDetailScreen().launch(context, isNewTask: true);
        }

        appStore.setLoading(false);
      }).catchError((error) {
        appStore.setLoading(false);

        toast(error.toString());
      });
    }
  }
}
