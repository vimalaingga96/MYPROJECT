import 'package:flutter/material.dart';
import 'package:food_delivery_admin/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class ThemeSelectionDialog extends StatefulWidget {
  static String tag = '/ThemeSelectionDialog';

  @override
  ThemeSelectionDialogState createState() => ThemeSelectionDialogState();
}

List<String> themeModeList = ['Light', 'Dark'];

class ThemeSelectionDialogState extends State<ThemeSelectionDialog> {
  int? currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    currentIndex = getIntAsync(THEME_MODE_INDEX);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width() * 0.3,
      padding: EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: themeModeList.length,
        itemBuilder: (BuildContext context, int index) {
          return RadioListTile(
            value: index,
            groupValue: currentIndex,
            title: Text(themeModeList[index], style: primaryTextStyle()),
            onChanged: (dynamic val) {
              setState(() {
                currentIndex = val;

                if (val == ThemeModeLight) {
                  appStore.setDarkMode(false);
                } else if (val == ThemeModeDark) {
                  appStore.setDarkMode(true);
                }

                setValue(THEME_MODE_INDEX, val);
              });

              /*if (appStore.isLoggedIn) {
                updateProfile(showToast: false).then((value) {}).catchError(log);
              }*/

              finish(context);
            },
          );
        },
      ),
    );
  }
}
