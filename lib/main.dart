import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './pages/main_page.dart';
import './pages/onboarding_page.dart';
import './pages/sign_in_page.dart';
import './pages/sign_up_page.dart';
import './pages/splash_page.dart';
import './providers/auth_provider.dart';
import './providers/category_provider.dart';
import './providers/job_provider.dart';
import './shared/shared_value.dart';
import './shared/theme.dart';

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
        ChangeNotifierProvider.value(value: AuthProvider()),
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
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          }),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              elevation: 0,
              primary: Colors.white,
              onSurface: Colors.white,
              fixedSize: Size(200, 45),
              alignment: Alignment.center,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(300),
              ),
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ).copyWith(
              side: MaterialStateProperty.resolveWith<BorderSide>(
                (Set<MaterialState> states) => BorderSide(color: Colors.white),
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              fixedSize: Size(200, 45),
              alignment: Alignment.center,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(300)),
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(300),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(300),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(300),
                borderSide: BorderSide(color: primaryColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(300),
                borderSide: BorderSide(color: errorColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(300),
                borderSide: BorderSide(color: errorColor),
              ),
              errorStyle: TextStyle(height: 0, fontSize: 1)),
          textTheme: TextTheme(
            headline4: TextStyle(
              fontSize: 30,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
            headline5: TextStyle(
              height: 1.6,
              fontSize: 24,
              letterSpacing: 0,
              color: blackColor,
              fontWeight: FontWeight.w600,
            ),
            headline6: TextStyle(
              fontSize: 20,
              letterSpacing: 0,
              color: blackColor,
              fontWeight: FontWeight.w600,
            ),
            subtitle1: TextStyle(
              fontSize: 16,
              letterSpacing: 0,
              color: blackColor,
              fontWeight: FontWeight.normal,
            ),
            subtitle2: TextStyle(
              fontSize: 14,
              letterSpacing: 0,
              color: blackColor,
              fontWeight: FontWeight.w500,
            ),
            bodyText1: TextStyle(
              fontSize: 16,
              letterSpacing: 0,
              color: blackColor,
              fontWeight: FontWeight.w500,
            ),
            bodyText2: TextStyle(
              fontSize: 14,
              letterSpacing: 0,
              color: hintColor,
              fontWeight: FontWeight.normal,
            ),
            caption: TextStyle(
              fontSize: 14,
              letterSpacing: 0,
              color: blackColor,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        home: Consumer<AuthProvider>(
          builder: (context, value, child) => (value.isAuth)
              ? MainPage(user: value.getUser()!)
              : FutureBuilder(
                  future: value.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      (snapshot.connectionState == ConnectionState.waiting)
                          ? SplashPage()
                          : OnBoardingPage(),
                ),
        ),
        routes: {
          RouteName.signIn: (context) => SignInPage(),
          RouteName.signUp: (context) => SignUpPage(),
        },
      ),
    );
  }
}
