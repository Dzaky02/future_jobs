import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../extension/screen_utils_extension.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../shared/sharedpref_keys.dart';
import '../shared/theme.dart';
import '../size_config.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var _isInit = true;

  // Shared Preference
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Providers
  late AuthProvider authProvider;
  late UserProvider userProvider;

  // Controller
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _nameController = TextEditingController(text: '');
  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');
  TextEditingController _goalController = TextEditingController(text: '');

  // Field
  String? _nameField;
  String? _emailField;
  String? _passwordField;
  String? _goalField;

  // Focus Node
  late FocusNode _nameFN;
  late FocusNode _emailFN;
  late FocusNode _passwordFN;
  late FocusNode _goalFN;

  // Form validation status
  bool _isNameValid = true;
  bool _isEmailValid = false;
  bool _isPasswordValid = true;
  bool _isGoalValid = true;
  bool _showPassword = false;

  // Upload loading
  bool _isLoading = false;

  Future<void> _setLoginState(UserModel user) async {
    final SharedPreferences prefs = await _prefs;
    // final bool isLogin = (prefs.getBool(SharedPrefConfig.IS_LOGIN) ?? false);
    prefs.setString(SharedPrefConfig.USERNAME, user.name).then(
      (bool success) {
        prefs.setBool(SharedPrefConfig.IS_LOGIN, true).then(
          (bool success) {
            setState(() => _isLoading = false);
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
            return true;
          },
        );
      },
    );
  }

  @override
  void initState() {
    _nameFN = FocusNode();
    _emailFN = FocusNode();
    _passwordFN = FocusNode();
    _goalFN = FocusNode();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      authProvider = Provider.of<AuthProvider>(context);
      userProvider = Provider.of<UserProvider>(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameFN.dispose();
    _emailFN.dispose();
    _passwordFN.dispose();
    _goalFN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    Widget header() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign Up',
            textScaleFactor: context.ts,
            style: context.text.subtitle1?.copyWith(color: context.onSecondary),
          ),
          Text(
            'Begin New Journey',
            textScaleFactor: context.ts,
            style: context.text.headline5,
          ),
          SizedBox(height: context.h(30)),
        ],
      );
    }

    Widget inputImage() {
      return Center(
        child: Container(
          width: context.dp(110),
          height: context.dp(110),
          padding: EdgeInsets.all(SizeConfig.scaleWidth(8)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: context.primaryVariant),
          ),
          child: Image.asset('assets/image_profile.png'),
        ),
      );
    }

    Widget inputName() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.h(30)),
          Text(
            'Full Name',
            style: context.text.subtitle1?.copyWith(color: context.onSecondary),
          ),
          SizedBox(height: context.dp(8)),
          TextFormField(
            focusNode: _nameFN,
            controller: _nameController,
            cursorColor:
                _isNameValid ? context.primaryColor : context.errorColor,
            maxLines: 1,
            textInputAction: TextInputAction.next,
            style: context.text.subtitle1?.copyWith(
                color:
                    _isNameValid ? context.primaryColor : context.errorColor),
            onChanged: (value) => (!_isNameValid)
                ? setState(() => _isNameValid = value.length > 3)
                : null,
            validator: (value) =>
                (value != null && value.length > 6) ? null : '',
          ),
        ],
      );
    }

    Widget inputEmail() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.dp(16)),
          Text(
            'Email Address',
            style: context.text.subtitle1?.copyWith(color: context.onSecondary),
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(8),
          ),
          TextFormField(
            controller: _emailController,
            cursorColor:
                _isEmailValid ? context.primaryColor : context.errorColor,
            onChanged: (value) => setState(() =>
                _isEmailValid = EmailValidator.validate(_emailController.text)),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: kInputDecorTheme(context, _isEmailValid),
            style: context.text.subtitle1?.copyWith(
                color:
                    _isEmailValid ? context.primaryColor : context.errorColor),
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
            style: context.text.subtitle1?.copyWith(color: context.onSecondary),
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(8),
          ),
          TextFormField(
            controller: _passwordController,
            cursorColor:
                _isPasswordValid ? context.primaryColor : context.errorColor,
            obscureText: !_showPassword,
            onChanged: (value) {
              setState(() {});
            },
            textInputAction: TextInputAction.next,
            decoration: kInputDecorTheme(
              context,
              _isPasswordValid,
              IconButton(
                onPressed: () => setState(() => _showPassword = !_showPassword),
                icon: Icon(Icons.remove_red_eye, color: context.onSurface),
              ),
            ),
            style: context.text.subtitle1?.copyWith(
                color: _isPasswordValid
                    ? context.primaryColor
                    : context.errorColor),
          ),
        ],
      );
    }

    Widget inputGoal() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.scaleHeight(20),
          ),
          Text(
            'Your Goal',
            style: context.text.subtitle1?.copyWith(color: context.onSecondary),
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(8),
          ),
          TextFormField(
            cursorColor:
                _isGoalValid ? context.primaryColor : context.errorColor,
            controller: _goalController,
            onChanged: (value) {
              setState(() {});
            },
            onFieldSubmitted: (_) => submitSignUp,
            textInputAction: TextInputAction.done,
            style: context.text.subtitle1?.copyWith(
                color: _isPasswordValid
                    ? context.primaryColor
                    : context.errorColor),
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(40),
          ),
        ],
      );
    }

    Widget signUpButton() {
      return Container(
        width: double.infinity,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ElevatedButton(
                onPressed: submitSignUp,
                style: primaryElevatedStyle(),
                child: Text(
                  'Sign Up',
                  style: whiteTextStyle.copyWith(
                    fontSize: SizeConfig.scaleText(14),
                    fontWeight: medium,
                  ),
                ),
              ),
      );
    }

    Widget signInButton() {
      return Container(
        child: Center(
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/sign-in');
            },
            child: Text(
              'Back to Sign In',
              style: greyTextStyle.copyWith(
                fontSize: SizeConfig.scaleText(14),
                fontWeight: light,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.scaleHeight(30),
              horizontal: SizeConfig.scaleWidth(defaultMargin),
            ),
            children: [
              header(),
              inputImage(),
              inputName(),
              inputEmail(),
              inputPassword(),
              inputGoal(),
              signUpButton(),
              signInButton(),
            ],
          ),
        ),
      ),
    );
  }

  void submitSignUp() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      if (_nameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _goalController.text.isEmpty) {
        if (_nameController.text.isEmpty) {
          _isNameValid = false;
          _nameFN.requestFocus();
        } else if (_emailController.text.isEmpty) {
          _isEmailValid = false;
          _emailFN.requestFocus();
        } else if (_passwordController.text.isEmpty) {
          _isPasswordValid = false;
          _passwordFN.requestFocus();
        } else if (_goalController.text.isEmpty) {
          _isGoalValid = false;
          _goalFN.requestFocus();
        }
        showError('Please fill out all field');
      } else if (!_isEmailValid) {
        _emailFN.requestFocus();
        showError('Email format is not valid');
      } else if (_passwordController.text.length < 6) {
        _isPasswordValid = false;
        _passwordFN.requestFocus();
        showError('Password required a min. of 6 characters');
      }
      return;
    }
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    UserModel? user = await authProvider.register(
      _emailField!,
      _passwordField!,
      _nameField!,
      _goalField!,
    );

    if (user == null) {
      setState(() => _isLoading = false);
      showError('Oops! seem\'s you already sign-up before');
    } else {
      userProvider.user = user;
      _setLoginState(user);
    }
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
}
