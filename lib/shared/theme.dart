import 'package:flutter/material.dart';

import './shared_method.dart';
import '../extension/extensions.dart';

// Note: Constant Values
const double defaultMargin = 24.0;

// Note: Colors
Color primaryColor = Color(0xff4141A4);
Color hintColor = Color(0xffB3B5C4);
Color surfaceColor = Color(0xffECEDF1); // for modal on top and input field
Color onSurfaceColor = Color(0xffA2A6B4);
Color errorColor = Color(0xffFD4F56);
Color blackColor = Color(0xff272C2F);
//----------------------------------------
MaterialColor myPrimarySwatch = generateMaterialColor(primaryColor);
//----------------------------------------
Color whiteColor = Color(0xffFFFFFF);
Color redColor = Color(0xffFD4F56);
Color greyColor = Color(0xffB3B5C4);
Color transparentColor = Colors.transparent;
Color inputFieldColor = Color(0xffF1F0F5);

// Decoration
InputDecoration kInputDecorTheme(BuildContext context, bool validator,
    [Widget? suffixIcon]) {
  return InputDecoration(
    focusColor: validator ? context.primaryColor : context.errorColor,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(300),
      borderSide: BorderSide(
          color: validator ? context.primaryColor : context.errorColor),
    ),
    suffixIcon: suffixIcon,
  );
}