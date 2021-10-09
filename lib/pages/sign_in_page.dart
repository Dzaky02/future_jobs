import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../extension/screen_utils_extension.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../shared/shared_value.dart';
import '../shared/sharedpref_keys.dart';
import '../shared/theme.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var _isInit = true;

  // Shared Preference
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Providers
  late AuthProvider authProvider;
  late UserProvider userProvider;

  // Controller
  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');

  // Form validation status
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _showPassword = false;

  // Loading status
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      authProvider = Provider.of<AuthProvider>(context, listen: false);
      userProvider = Provider.of<UserProvider>(context, listen: false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
          Navigator.pushNamedAndRemoveUntil(
              context, RouteName.main, (route) => false);
          return true;
        },
      );
    });
    print(
        'AUTH: prefs store: ${prefs.getString(SharedPrefKey.USER) ?? 'empty'}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(
            vertical: context.h(30),
            horizontal: context.dp(defaultMargin),
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

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: context.errorColor,
        content: Text(
          message,
          style: context.text.subtitle1?.copyWith(color: context.onError),
        ),
      ),
    );
  }

  Future<void> _submitLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      if (_emailController.text.isEmpty) {
        _isEmailValid = false;
      } else if (_passwordController.text.isEmpty) {
        _isPasswordValid = false;
      }
      showError('Please fill out all field');
    } else {
      setState(() => _isLoading = true);

      UserModel? user = await authProvider.login(
          _emailController.text, _passwordController.text);

      if (user == null) {
        setState(() => _isLoading = false);
        showError('email atau password salah');
      } else {
        userProvider.user = user;
        _setLoginState(user);
      }
    }
  }

  Widget header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sign In',
          textScaleFactor: context.ts,
          style: context.text.subtitle1?.copyWith(color: context.onSecondary),
        ),
        Text(
          'Build Your Career',
          textScaleFactor: context.ts,
          style: context.text.headline5,
        ),
        SizedBox(height: context.h(40)),
      ],
    );
  }

  Widget illustration() {
    return Center(
      child: Image.asset('assets/image_sign_in.png', height: context.h(170)),
    );
  }

  Widget inputEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.h(40)),
        Text(
          'Email Address',
          style: context.text.subtitle1?.copyWith(color: context.onSecondary),
        ),
        SizedBox(height: context.h(8)),
        TextFormField(
          maxLines: 1,
          controller: _emailController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          decoration: kInputDecorTheme(context, _isEmailValid),
          cursorColor:
              _isEmailValid ? context.primaryColor : context.errorColor,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          onChanged: (value) => setState(() =>
              _isEmailValid = EmailValidator.validate(_emailController.text)),
          style: context.text.subtitle1?.copyWith(
              color: _isEmailValid ? context.primaryColor : context.errorColor),
        ),
      ],
    );
  }

  Widget inputPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.dp(16)),
        Text(
          'Password',
          style: context.text.subtitle1?.copyWith(color: context.onSecondary),
        ),
        SizedBox(height: context.h(8)),
        TextFormField(
          maxLines: 1,
          obscureText: !_showPassword,
          controller: _passwordController,
          textInputAction: TextInputAction.done,
          cursorColor:
              _isPasswordValid ? context.primaryColor : context.errorColor,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          onChanged: (value) => setState(
              () => _isPasswordValid = _passwordController.text.length > 6),
          decoration: kInputDecorTheme(
            context,
            _isPasswordValid,
            IconButton(
              onPressed: () => setState(() => _showPassword = !_showPassword),
              icon: Icon(Icons.remove_red_eye, color: context.onSurface),
            ),
          ),
          style: context.text.subtitle1?.copyWith(
              color:
                  _isPasswordValid ? context.primaryColor : context.errorColor),
          onFieldSubmitted: (_) => _submitLogin(),
        ),
        SizedBox(height: context.h(40)),
      ],
    );
  }

  Widget signInButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitLogin,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    strokeWidth: 1.5, color: context.onPrimary))
            : Text('Sign In'),
      ),
    );
  }

  Widget signUpButton() {
    return Padding(
      padding: EdgeInsets.only(top: context.h(8)),
      child: Center(
        child: TextButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, RouteName.signUp),
          child: Text('Create New Account'),
        ),
      ),
    );
  }
}
