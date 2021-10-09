import 'package:flutter/material.dart';

import '../extension/screen_utils_extension.dart';
import '../shared/shared_value.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget backgroundImage() {
      return ColorFiltered(
        colorFilter: ColorFilter.mode(
          context.primaryColor.withOpacity(0.8),
          BlendMode.hardLight,
        ),
        child: Image.asset(
          'assets/bg_on_boarding.png',
          width: context.dw,
          height: context.dh,
          fit: BoxFit.cover,
          alignment: Alignment.centerLeft,
        ),
      );
    }

    Widget content() {
      return SafeArea(
        child: Container(
          width: context.dw,
          padding: EdgeInsets.symmetric(
              horizontal: context.dp(30), vertical: context.h(50)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Build Your Next\nFuture Career Like\na Master',
                textScaleFactor: context.ts,
                style: context.text.headline4,
              ),
              SizedBox(height: context.dp(20)),
              Text(
                '18,000 jobs available',
                textScaleFactor: context.ts,
                style: context.text.caption?.copyWith(color: Colors.white),
              ),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, RouteName.signUp),
                  child: Text('Get Started'),
                  style: ElevatedButton.styleFrom(
                      primary: context.secondaryColor,
                      onPrimary: context.primaryColor),
                ),
              ),
              SizedBox(height: context.dp(16)),
              Center(
                child: OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, RouteName.signIn),
                  child: Text('Sign In'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          backgroundImage(),
          content(),
        ],
      ),
    );
  }
}
