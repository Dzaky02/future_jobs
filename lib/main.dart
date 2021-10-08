import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:future_jobs/pages/home_page.dart';
import 'package:future_jobs/pages/onboarding_page.dart';
import 'package:future_jobs/pages/sign_in_page.dart';
import 'package:future_jobs/pages/sign_up_page.dart';
import 'package:future_jobs/pages/splash_page.dart';
import 'package:future_jobs/providers/auth_provider.dart';
import 'package:future_jobs/providers/category_provider.dart';
import 'package:future_jobs/providers/job_provider.dart';
import 'package:future_jobs/providers/user_provider.dart';
import 'package:future_jobs/shared/shared_value.dart';
import 'package:future_jobs/shared/theme.dart';
import 'package:future_jobs/widgets/FadePageTransitionsBuilder.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set Device Orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (create) => AuthProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (create) => UserProvider(),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (create) => CategoryProvider(),
        ),
        ChangeNotifierProvider<JobProvider>(
          create: (create) => JobProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Future Job',
        color: primaryColor,
        theme: ThemeData(
          fontFamily: 'Poppins',
          hintColor: hintColor,
          primarySwatch: myPrimarySwatch,
          backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: myPrimarySwatch,
            backgroundColor: Colors.white,
            errorColor: errorColor,
          ).copyWith(
            primary: primaryColor,
            primaryVariant: myPrimarySwatch.shade800,
            secondary: Colors.white,
            surface: surfaceColor,
            onPrimary: Colors.white,
            onSecondary: hintColor,
            onSurface: onSurfaceColor,
            onBackground: blackColor,
            onError: Colors.white,
          ),
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.iOS: FadePageTransitionsBuilder(),
            TargetPlatform.android: FadePageTransitionsBuilder(),
          }),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              elevation: 0,
              primary: Colors.white,
              onSurface: Colors.white,
              fixedSize: Size(200, 45),
              alignment: Alignment.center,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(double.infinity)),
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              onSurface: Colors.white,
              fixedSize: Size(200, 45),
              alignment: Alignment.center,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(double.infinity)),
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: hintColor,
              elevation: 0,
              alignment: Alignment.center,
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(double.infinity),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(double.infinity),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(double.infinity),
              borderSide: BorderSide(color: primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(double.infinity),
              borderSide: BorderSide(color: errorColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(double.infinity),
              borderSide: BorderSide(color: errorColor),
            ),
          ),
          textTheme: TextTheme(
            headline4: TextStyle(
              fontSize: 32,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
            headline5: TextStyle(
              fontSize: 24,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
            ),
            headline6: TextStyle(
              fontSize: 20,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
            ),
            subtitle1: TextStyle(
              fontSize: 16,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
            ),
            subtitle2: TextStyle(
              fontSize: 14,
              letterSpacing: 0,
              fontWeight: FontWeight.w500,
            ),
            bodyText1: TextStyle(
              fontSize: 16,
              letterSpacing: 0,
              fontWeight: FontWeight.w500,
            ),
            bodyText2: TextStyle(
              fontSize: 14,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
            ),
            caption: TextStyle(
              fontSize: 14,
              letterSpacing: 0,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        routes: {
          RouteName.splash: (context) => SplashPage(),
          RouteName.onBoarding: (context) => OnBoardingPage(),
          RouteName.signIn: (context) => SignInPage(),
          RouteName.signUp: (context) => SignUpPage(),
          RouteName.home: (context) => HomePage(),
        },
      ),
    );
  }
}
