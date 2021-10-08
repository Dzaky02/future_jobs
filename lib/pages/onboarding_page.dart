import 'package:flutter/material.dart';
import 'package:future_jobs/size_config.dart';
import 'package:future_jobs/theme.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Widget backgroundImage() {
      return Image.asset(
        'assets/onboarding.png',
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.fill,
      );
    }

    Widget content() {
      return SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.scaleWidth(30),
            vertical: SizeConfig.scaleHeight(50),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Build Your Next\nFuture Career Like\na Master',
                style: whiteTextStyle.copyWith(
                  fontSize: SizeConfig.scaleText(32),
                ),
              ),
              SizedBox(height: SizeConfig.scaleHeight(20)),
              Text(
                '18,000 jobs available',
                style: whiteTextStyle.copyWith(
                  fontSize: SizeConfig.scaleText(14),
                  fontWeight: light,
                ),
              ),
              Spacer(),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/sign-up');
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: whiteColor,
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.scaleWidth(12),
                      horizontal: SizeConfig.scaleWidth(60),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(66),
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: purpleTextStyle.copyWith(
                      fontSize: SizeConfig.scaleText(14),
                      fontWeight: medium,
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.scaleHeight(16)),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/sign-in');
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: transparentColor,
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.scaleWidth(12),
                      horizontal: SizeConfig.scaleWidth(76),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(66),
                      side: BorderSide(
                        color: whiteColor,
                      ),
                    ),
                  ),
                  child: Text(
                    'Sign In',
                    style: whiteTextStyle.copyWith(
                      fontSize: SizeConfig.scaleText(14),
                      fontWeight: medium,
                    ),
                  ),
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
