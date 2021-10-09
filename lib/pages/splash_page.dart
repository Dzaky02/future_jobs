import 'dart:async';

import 'package:flutter/material.dart';
import 'package:future_jobs/shared/shared_value.dart';
import 'package:future_jobs/shared/sharedpref_keys.dart';
import 'package:future_jobs/shared/theme.dart';
import 'package:future_jobs/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<bool> _isLogin;

  @override
  void initState() {
    super.initState();

    _isLogin = _prefs.then((SharedPreferences prefs) {
      return (prefs.getBool(SharedPrefKey.IS_LOGIN) ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: _buildImage(),
          ),
          Center(
            child: _buildFutureBuilder(),
          ),
        ],
      ),
    );
  }

  Image _buildImage() {
    return Image.asset(
      'assets/image_splash.png',
      width: 182,
      height: 174,
    );
  }

  FutureBuilder<bool> _buildFutureBuilder() {
    return FutureBuilder<bool>(
      future: _isLogin,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        print('IS LOGIN? ${snapshot.data}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _buildImage();
          default:
            if (snapshot.hasError) {
              _buildShowSnackBar(snapshot.error.toString());
              _navigatePage(context, RouteName.onBoarding);
              return _buildImage();
            } else {
              _navigatePage(
                  context,
                  (snapshot.data ?? false)
                      ? RouteName.home
                      : RouteName.onBoarding);
              return _buildImage();
            }
        }
      },
    );
  }

  void _buildShowSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text('Error: $error')),
        duration: const Duration(milliseconds: 1500),
        width: SizeConfig.scaleWidth(280),
        // Width of the SnackBar.
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0, // Inner padding for SnackBar content.
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Timer _navigatePage(BuildContext context, String routeName) {
    return Timer(
      Duration(milliseconds: 500),
      () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          routeName,
          (route) => false,
        );
      },
    );
  }
}
