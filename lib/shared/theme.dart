import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './shared_method.dart';
import '../size_config.dart';

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

// Note: Text Styles
TextStyle purpleTextStyle = GoogleFonts.poppins(
  color: primaryColor,
);

TextStyle blackTextStyle = GoogleFonts.poppins(
  color: blackColor,
);

TextStyle whiteTextStyle = GoogleFonts.poppins(
  color: whiteColor,
);

TextStyle redTextStyle = GoogleFonts.poppins(
  color: redColor,
);

TextStyle greyTextStyle = GoogleFonts.poppins(
  color: greyColor,
);

// Note: Font Weights
FontWeight light = FontWeight.w300;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w700;
FontWeight bold = FontWeight.bold;

// Decoration
InputDecoration kInputDecorTheme() {
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(
      vertical: SizeConfig.scaleWidth(10),
      horizontal: SizeConfig.scaleWidth(20),
    ),
    fillColor: Color(0xffF1F0F5),
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(100)),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(100)),
      borderSide: BorderSide(
        color: primaryColor,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(100)),
      borderSide: BorderSide(
        color: redColor,
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(100)),
    ),
    hintText: '',
  );
}

ButtonStyle primaryElevatedStyle() {
  return ElevatedButton.styleFrom(
    primary: primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        SizeConfig.scaleWidth(66),
      ),
    ),
    padding: EdgeInsets.all(SizeConfig.scaleWidth(13)),
  );
}
