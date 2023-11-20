import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:food_delivery_admin/main.dart';
import 'package:food_delivery_admin/models/CategoryModel.dart';
import 'package:food_delivery_admin/utils/Colors.dart';
import 'package:food_delivery_admin/utils/Common.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:food_delivery_admin/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

class NewCategoryDialog extends StatefulWidget {
  static String tag = '/NewCategoryDialog';

  final CategoryModel? data;

  NewCategoryDialog({this.data});

  @override
  NewCategoryDialogState createState() => NewCategoryDialogState();
}

class NewCategoryDialogState extends State<NewCategoryDialog> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController nameCont = TextEditingController();
  TextEditingController imageCont = TextEditingController();
  TextEditingController inputPrimaryColor = TextEditingController();

  Color pickerColor = colorPrimary;

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.data != null;

    if (isUpdate) {
      nameCont.text = widget.data!.categoryName.validate();
      imageCont.text = widget.data!.image.validate();
      inputPrimaryColor.text = widget.data!.color.validate();
      pickerColor = widget.data!.color.toColor();
    } else {
      inputPrimaryColor.text = pickerColor.toString();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> addCategory() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      appStore.setLoading(true);

      Map<String, dynamic> data = {
        CategoryKey.categoryName: nameCont.text,
        CategoryKey.color: inputPrimaryColor.text,
        CategoryKey.image: imageCont.text,
        CategoryKey.isDeleted: false,
        TimeDataKey.updatedAt: DateTime.now(),
      };

      if (isUpdate) {
        await categoryService.updateDocument(data, widget.data!.id.validate()).then((value) {
          finish(context);
        }).catchError((e) {
          toast(e.toString());
          log(e.toString());
        });
      } else {
        await categoryService.addDocument(data).then((value) {
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
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(appStore.translate('add_category'), style: boldTextStyle()),
              16.height,
              AppTextField(
                controller: nameCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(labelText: appStore.translate('category_name')),
                autoFocus: true,
                errorThisFieldRequired: appStore.translate('this_field_is_required'),
              ),
              16.height,
              AppTextField(
                controller: imageCont,
                textFieldType: TextFieldType.OTHER,
                decoration: inputDecoration(labelText: appStore.translate('image_url')),
                keyboardType: TextInputType.url,
                validator: (s) {
                  if (s!.isEmpty) return  appStore.translate('this_field_is_required');
                  if (!s.validateURL()) return appStore.translate('url_invalid');
                  return null;
                },
              ),
              16.height,
              Row(
                children: [
                  AppTextField(
                    controller: inputPrimaryColor,
                    textFieldType: TextFieldType.OTHER,
                    onFieldSubmitted: (s) {
                      try {
                        pickerColor = s.toColor();
                        inputPrimaryColor.text = pickerColor.toHex(includeAlpha: true).toUpperCase();

                        setState(() {});
                      } catch (e) {
                        print(e);
                      }
                    },
                    decoration: inputDecoration(labelText: appStore.translate('category_color')).copyWith(
                      suffixIcon: Text(appStore.translate('pick_color'), style: primaryTextStyle()).paddingAll(8).onTap(() {
                        showInDialog(
                          context,
                          backgroundColor: context.cardColor,
                          title: Text(appStore.translate('select_color')),
                          actions: [
                            TextButton(
                              child: Text(appStore.translate('done'), style: boldTextStyle()),
                              onPressed: () {
                                inputPrimaryColor.text = pickerColor.toHex(includeAlpha: true).toUpperCase();
                                finish(context);
                              },
                            )
                          ],
                          child: Container(
                            color: appStore.isDarkMode ? Colors.white24 : null,
                            width: 600,
                            height: 200,
                            child: ColorPicker(
                              pickerColor: pickerColor,
                              enableAlpha: true,
                              displayThumbColor: true,
                              onColorChanged: (color) {
                                setState(() {
                                  pickerColor = color;
                                  inputPrimaryColor.text = pickerColor.toHex(includeAlpha: true).toUpperCase();
                                });
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ).expand(),
                  8.width,
                  Container(
                    decoration: BoxDecoration(color: pickerColor, shape: BoxShape.circle),
                    padding: EdgeInsets.all(20),
                  ),
                ],
              ),
              16.height,
              AppButton(
                text: isUpdate ? appStore.translate('edit') : appStore.translate('save'),
                width: context.width(),
                color: colorPrimary,
                textStyle: primaryTextStyle(color: white),
                padding: EdgeInsets.all(20),
                onTap: () {
                  if (getBoolAsync(IS_TESTER)) {
                    finish(context);
                    return toast(appStore.translate('mTesterNotAllowedMsg'));
                  } else {
                    addCategory();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
