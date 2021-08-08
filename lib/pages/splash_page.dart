import 'dart:async';

import 'package:flutter/material.dart';
import 'package:future_jobs/shared/sharedpref_keys.dart';
import 'package:future_jobs/size_config.dart';
import 'package:future_jobs/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<bool> _isLogin;

  // Future<void> _checkLoginState() async {
  //   final SharedPreferences prefs = await _prefs;
  //   final bool isLogin = (prefs.getBool(SharedPrefConfig.IS_LOGIN) ?? false);
  //
  //   setState(() {
  //     _isLogin = prefs
  //         .setBool(SharedPrefConfig.IS_LOGIN, isLogin)
  //         .then((bool success) {
  //       return isLogin;
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();

    _isLogin = _prefs.then((SharedPreferences prefs) {
      return (prefs.getBool(SharedPrefConfig.IS_LOGIN) ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: SizeConfig.scaleWidth(59),
              height: SizeConfig.scaleHeight(76),
            ),
            SizedBox(
              height: SizeConfig.scaleHeight(50),
            ),
            Text(
              'FUTUREJOB',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: SizeConfig.scaleText(32),
                fontWeight: FontWeight.w600,
              ),
            ),
            _buildFutureBuilder(),
          ],
        ),
      ),
    );
  }

  FutureBuilder<bool> _buildFutureBuilder() {
    return FutureBuilder<bool>(
      future: _isLogin,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _buildLinearProgressIndicator();
          default:
            if (snapshot.hasError) {
              _buildShowSnackBar(snapshot.error.toString());
              _NavigatePage(context);
              return _buildLinearProgressIndicator();
            } else {
              _NavigatePage(context);
              return _buildLinearProgressIndicator();
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

  Timer _NavigatePage(BuildContext context) {
    return Timer(
      Duration(seconds: 2),
      () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/onboarding',
          (route) => false,
        );
      },
    );
  }

  Container _buildLinearProgressIndicator() {
    return Container(
      width: SizeConfig.scaleWidth(180),
      height: SizeConfig.scaleWidth(4),
      margin: EdgeInsets.only(top: SizeConfig.scaleHeight(16)),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: LinearProgressIndicator(
        backgroundColor: blackColor,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }
}
