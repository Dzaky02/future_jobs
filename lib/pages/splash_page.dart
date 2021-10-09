import 'package:flutter/material.dart';

import '../shared/theme.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: _buildImage(),
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
}
