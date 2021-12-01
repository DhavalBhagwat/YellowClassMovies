import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ScreenUtils {

  int? width;
  int? height;
  bool? allowFontScaling;
  static MediaQueryData? _mediaQueryData;
  static double? _screenWidth;
  static double? _screenHeight;
  static double? _pixelRatio;
  static double? _statusBarHeight;
  static double? _bottomBarHeight;
  static double? _textScaleFactor;

  static ScreenUtils? _instance;
  ScreenUtils._();
  factory ScreenUtils({width = 1080, height = 1920, allowFontScaling = false}) => getInstance;

  static ScreenUtils get getInstance {
    if (_instance == null) {
      _instance = new ScreenUtils._();
    }
    return _instance!;
  }

  void init(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _mediaQueryData = mediaQuery;
    _pixelRatio = mediaQuery.devicePixelRatio;
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = _mediaQueryData?.padding.bottom;
    _textScaleFactor = mediaQuery.textScaleFactor;
  }

  static MediaQueryData get mediaQueryData => _mediaQueryData!;

  static double get textScaleFactory => _textScaleFactor!;

  static double get pixelRatio => _pixelRatio!;

  static double get screenWidthDp => _screenWidth!;

  static double get screenHeightDp => _screenHeight!;

  static double get screenWidth => _screenWidth! * _pixelRatio!;

  static double get screenHeight => _screenHeight! * _pixelRatio!;

  static double get statusBarHeightSimple => _statusBarHeight!;

  static double get statusBarHeight => _statusBarHeight! * _pixelRatio!;

  static double get bottomBarHeight => _bottomBarHeight! * _pixelRatio!;

  get scaleWidth => _screenWidth! / getInstance.width!;

  get scaleHeight => _screenHeight! / getInstance.height!;

  setWidth(int width) => width * scaleWidth;

  setHeight(int height) => height * scaleHeight;

  setSp(int fontSize) => allowFontScaling! ? setWidth(fontSize) : setWidth(fontSize) / _textScaleFactor;

}
