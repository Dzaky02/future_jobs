import 'dart:async';

import 'package:flutter/material.dart';
import 'package:future_jobs/size_config.dart';
import 'package:future_jobs/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/onboarding',
        (route) => false,
      );
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
          ],
        ),
      ),
    );
  }
}
