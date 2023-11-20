import 'package:flutter/material.dart';
import 'package:food_delivery_admin/main.dart';
import 'package:food_delivery_admin/models/UserModel.dart';
import 'package:food_delivery_admin/utils/Colors.dart';
import 'package:food_delivery_admin/utils/Common.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:food_delivery_admin/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

class AddUserDialog extends StatefulWidget {
  static String tag = '/AddUserDialog';

  final UserModel? userData;

  AddUserDialog({this.userData});

  @override
  AddUserDialogState createState() => AddUserDialogState();
}

class AddUserDialogState extends State<AddUserDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController userNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController roleCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController confirmPwdCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode roleFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode cPasswordFocus = FocusNode();

  List<String> roleList = [USER, REST_MANAGER, DELIVERY_BOY];

  String? roleVal = USER;
  bool isUpdate = false;
  final dropdownState = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.userData != null;

    if (isUpdate) {
      userNameCont.text = widget.userData!.name!;
      emailCont.text = widget.userData!.email!;
      roleVal = widget.userData!.role;
    }
  }

  Future<void> addUser() async {
    if (formKey.currentState!.validate()) {
      appStore.setLoading(true);

      if (!isUpdate) {
        await service.signUpWithEmailPassword(email: emailCont.text.trim(), password: passwordCont.text.trim(), displayName: userNameCont.text.trim(), role: roleVal).then((value) async {
          finish(context, true);
        }).catchError((error) {
          toast(error.toString());
        });
      } else {
        Map<String, dynamic> data = {
          UserKeys.role: roleVal,
          UserKeys.email: emailCont.text,
          UserKeys.name: userNameCont.text,
          TimeDataKey.updatedAt: DateTime.now(),
        };
        await userService.updateDocument(data, widget.userData!.uid.validate()).then((value) {
          toast(appStore.translate('successfully_update_user'));
          finish(context);
        }).catchError((e) {
          toast(e.toString());
          log(e.toString());
        });
      }
      appStore.setLoading(false);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isUpdate ? appStore.translate('edit_user') : appStore.translate('add_user'), style: boldTextStyle()),
            16.height,
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  Row(
                    children: [
                      AppTextField(
                        controller: userNameCont,
                        textFieldType: TextFieldType.NAME,
                        decoration: inputDecoration(hintText: appStore.translate('enter_your_username'), labelText: appStore.translate('username')),
                        nextFocus: emailFocus,
                        errorThisFieldRequired:  appStore.translate('this_field_is_required'),
                      ).expand(),
                      8.width,
                      AppTextField(
                        controller: emailCont,
                        textFieldType: TextFieldType.EMAIL,
                        decoration: inputDecoration(hintText: appStore.translate('enter_email_address'), labelText: appStore.translate('email_address')),
                        nextFocus: roleFocus,
                        enabled: isUpdate ? false : true,
                        errorThisFieldRequired:  appStore.translate('this_field_is_required'),
                        errorInvalidEmail: emailError,
                      ).expand(),
                    ],
                  ),
                  16.height,
                  Row(
                    children: [
                      AppTextField(
                        controller: passwordCont,
                        textFieldType: TextFieldType.PASSWORD,
                        focus: cPasswordFocus,
                        errorThisFieldRequired:  appStore.translate('this_field_is_required'),
                        decoration: inputDecoration(hintText: appStore.translate('enter_your_password'), labelText: appStore.translate('password')),
                      ).expand(),
                      8.width,
                      AppTextField(
                        controller: confirmPwdCont,
                        textFieldType: TextFieldType.PASSWORD,
                        decoration: inputDecoration(hintText: appStore.translate('enter_your_confirm_password'), labelText: appStore.translate('confirm_password')),
                        validator: (value) {
                          if (value!.trim().isEmpty) return appStore.translate('this_field_is_required');
                          if (value.trim().length < passwordLengthGlobal) return '${appStore.translate('password_length_should_be_more_than')} $passwordLengthGlobal';
                          return passwordCont.text == value.trim() ? null : '${appStore.translate('password_does_not_match')}';
                        },
                      ).expand(),
                    ],
                  ).visible(!isUpdate),
                  16.height,
                  Container(
                    alignment: Alignment.center,
                    width: context.width(),
                    child: DropdownButtonFormField(
                      dropdownColor: context.cardColor,
                      key: dropdownState,
                      value: roleVal,
                      decoration: inputDecoration(hintText: appStore.translate('select_role')),
                      focusNode: roleFocus,
                      items: roleList.map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(getUserRoleText(value), style: primaryTextStyle()),
                        );
                      }).toList(),
                      onChanged: (dynamic value) {
                        roleVal = value;
                        setState(() {});
                      },
                    ),
                  ),
                  16.height,
                  Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            finish(context);
                          },
                          child: Text(appStore.translate('cancel'), style: secondaryTextStyle()),
                        ),
                        8.width,
                        AppButton(
                          height: 50,
                          text: isUpdate ? appStore.translate('update_user') : appStore.translate('add_user'),
                          textStyle: primaryTextStyle(color: white),
                          color: appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary,
                          onTap: () {
                            if (getBoolAsync(IS_TESTER)) {
                              finish(context);
                              return toast(appStore.translate('mTesterNotAllowedMsg'));
                            } else {
                              addUser();
                            }
                          },
                        ),
                      ],
                    ),
                  ).cornerRadiusWithClipRRect(defaultRadius),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
