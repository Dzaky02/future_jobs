import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;
  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double _paddingTop;
  static double _paddingBottom;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);

    // Width and Height
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    // 360x792 is width from figma design you can use 100 for 100% scaling.
    blockSizeHorizontal = screenWidth / 360;
    blockSizeVertical = screenHeight / 792;

    // Padding
    _paddingTop = _mediaQueryData.padding.top; // For status bar
    _paddingBottom = _mediaQueryData.padding.bottom; // For keyboard dll

    // Safe Area
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _paddingTop) / 100;
  }

  /// Calculates the height depending on the device's screen siz
  double scaleHeigth(double pixel) => blockSizeVertical * pixel;

  /// Calculates the width depending on the device's screen size
  double scaleWidth(double pixel) => blockSizeHorizontal * pixel;

  /// Calculates the sp (Scalable Pixel) depending on the device's screen size
  double scaleText(double pixel) => (screenWidth / 3) / 100;
}
