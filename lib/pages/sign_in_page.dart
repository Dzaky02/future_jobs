import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../shared/sharedpref_keys.dart';
import '../shared/theme.dart';
import '../size_config.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Shared Preference
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Controller
  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');

  bool _isLoading = false;

  Future<void> _setLoginState(UserModel user) async {
    final SharedPreferences prefs = await _prefs;
    // Store auth in shared preferences
    // final bool isLogin = (prefs.getBool(SharedPrefConfig.IS_LOGIN) ?? false);
    print('AUTH: prepared to store auth data...');
    final userData = json.encode(user.toJson());
    prefs.setString(SharedPrefKey.USER, userData).then((value) {
      prefs.setBool(SharedPrefKey.IS_LOGIN, true).then(
        (bool success) {
          setState(() => _isLoading = false);
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          return true;
        },
      );
    });
    print(
        'AUTH: prefs store: ${prefs.getString(SharedPrefKey.USER) ?? 'empty'}');
  }

  @override
  Widget build(BuildContext context) {
    // Size Config
    SizeConfig().init(context);

    // Provider
    var authProvider = Provider.of<AuthProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);

    void showError(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(message),
        ),
      );
    }

    Widget header() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign In',
            style: greyTextStyle.copyWith(
              fontSize: SizeConfig.scaleText(16),
            ),
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(2),
          ),
          Text(
            'Build Your Career',
            style: blackTextStyle.copyWith(
              fontSize: SizeConfig.scaleText(24),
              fontWeight: semiBold,
            ),
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(40),
          ),
        ],
      );
    }

    Widget illustration() {
      return Center(
        child: Image.asset(
          'assets/image_sign_in.png',
          height: SizeConfig.scaleHeight(200),
        ),
      );
    }

    Widget inputEmail() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.scaleHeight(40),
          ),
          Text(
            'Email Address',
            style: greyTextStyle.copyWith(
              fontSize: SizeConfig.scaleText(16),
            ),
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(8),
          ),
          TextFormField(
            controller: _emailController,
            cursorColor: primaryColor,
            style: EmailValidator.validate(_emailController.text)
                ? purpleTextStyle.copyWith(fontSize: SizeConfig.scaleText(16))
                : redTextStyle.copyWith(fontSize: SizeConfig.scaleText(16)),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
        ],
      );
    }

    Widget inputPassword() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.scaleHeight(20),
          ),
          Text(
            'Password',
            style: greyTextStyle.copyWith(
              fontSize: SizeConfig.scaleText(16),
            ),
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(8),
          ),
          TextFormField(
            controller: _passwordController,
            cursorColor: primaryColor,
            obscureText: true,
            style: purpleTextStyle.copyWith(
              fontSize: SizeConfig.scaleText(16),
            ),
            textInputAction: TextInputAction.done,
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(40),
          ),
        ],
      );
    }

    Widget signInButton() {
      return Container(
        width: double.infinity,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ElevatedButton(
                onPressed: () async {
                  if (_emailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    showError('Semua field harus diisi');
                  } else {
                    setState(() {
                      _isLoading = true;
                    });

                    UserModel? user = await authProvider.login(
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (user == null) {
                      setState(() {
                        _isLoading = false;
                      });
                      showError('email atau password salah');
                    } else {
                      userProvider.user = user;
                      _setLoginState(user);
                    }
                  }
                },
                style: primaryElevatedStyle(),
                child: Text(
                  'Sign In',
                  style: whiteTextStyle.copyWith(
                    fontSize: SizeConfig.scaleText(14),
                    fontWeight: medium,
                  ),
                ),
              ),
      );
    }

    Widget signUpButton() {
      return Center(
        child: TextButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/sign-up'),
          child: Text(
            'Create New Account',
            style: greyTextStyle.copyWith(
              fontSize: SizeConfig.scaleText(14),
              fontWeight: light,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.scaleHeight(30),
            horizontal: SizeConfig.scaleWidth(defaultMargin),
          ),
          children: [
            header(),
            illustration(),
            inputEmail(),
            inputPassword(),
            signInButton(),
            signUpButton(),
          ],
        ),
      ),
    );
  }
}
