import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../extension/screen_utils_extension.dart';
import '../providers/auth_provider.dart';
import '../shared/shared_value.dart';
import '../shared/theme.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var _isInit = true;

  // Providers
  late AuthProvider authProvider;

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
      authProvider = Provider.of<AuthProvider>(context, listen: false);
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
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            physics: BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.symmetric(
              vertical: context.dp(30),
              horizontal: context.dp(defaultMargin),
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
      } else if (!_isPasswordValid || _passwordController.text.length < 6) {
        _isPasswordValid = false;
        _passwordFN.requestFocus();
        showError('Password required a min. of 6 characters');
      } else if (!_isGoalValid || _goalController.text.length < 4) {
        _isGoalValid = false;
        _goalFN.requestFocus();
        showError('You can do it better!');
      }
      return;
    }
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    await authProvider.register(
        _emailField!, _passwordField!, _nameField!, _goalField!);

    setState(() => _isLoading = false);
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
        padding: EdgeInsets.all(context.dp(8)),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: context.primaryVariant),
        ),
        child: SvgPicture.asset('assets/svg/male_avatar.svg'),
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
        SizedBox(height: context.h(8)),
        TextFormField(
          maxLines: 1,
          focusNode: _nameFN,
          controller: _nameController,
          textInputAction: TextInputAction.next,
          cursorColor: _isNameValid ? context.primaryColor : context.errorColor,
          inputFormatters: [
            FilteringTextInputFormatter.singleLineFormatter,
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
          ],
          style: context.text.subtitle1?.copyWith(
              color: _isNameValid ? context.primaryColor : context.errorColor),
          onChanged: (value) => (!_isNameValid)
              ? setState(() => _isNameValid = value.length > 3)
              : null,
          onSaved: (newValue) => _nameField = newValue,
          validator: (value) => (value != null && value.length > 6) ? null : '',
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
        SizedBox(height: context.h(8)),
        TextFormField(
          maxLines: 1,
          focusNode: _emailFN,
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
          onSaved: (newValue) => _emailField = newValue,
          validator: (value) =>
              EmailValidator.validate(value ?? '') ? null : '',
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
          focusNode: _passwordFN,
          obscureText: !_showPassword,
          controller: _passwordController,
          textInputAction: TextInputAction.next,
          cursorColor:
              _isPasswordValid ? context.primaryColor : context.errorColor,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          onChanged: (value) => (!_isPasswordValid)
              ? setState(
                  () => _isPasswordValid = _passwordController.text.length > 6)
              : null,
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
          onFieldSubmitted: (_) => _goalFN.requestFocus(),
          onSaved: (newValue) => _passwordField = newValue,
          validator: (value) => (value != null && value.length > 6) ? null : '',
        ),
      ],
    );
  }

  Widget inputGoal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.h(16)),
        Text(
          'Your Goal',
          style: context.text.subtitle1?.copyWith(color: context.onSecondary),
        ),
        SizedBox(height: context.h(8)),
        TextFormField(
          maxLines: 1,
          focusNode: _goalFN,
          controller: _goalController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => submitSignUp(),
          inputFormatters: [
            FilteringTextInputFormatter.singleLineFormatter,
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ,.]')),
          ],
          cursorColor: _isGoalValid ? context.primaryColor : context.errorColor,
          onChanged: (value) => (!_isGoalValid)
              ? setState(() => _isGoalValid = _goalController.text.length > 4)
              : null,
          style: context.text.subtitle1?.copyWith(
              color: _isGoalValid ? context.primaryColor : context.errorColor),
          onSaved: (newValue) => _goalField = newValue,
          validator: (value) => (value != null && value.length > 4) ? null : '',
        ),
        SizedBox(height: context.h(40)),
      ],
    );
  }

  Widget signUpButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: submitSignUp,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    strokeWidth: 1.5, color: context.onPrimary))
            : Text('Sign Up'),
      ),
    );
  }

  Widget signInButton() {
    return Container(
      margin: EdgeInsets.only(top: context.h(8)),
      child: Center(
        child: TextButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, RouteName.signIn),
          child: Text('Already have an account'),
        ),
      ),
    );
  }
}
