import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:future_jobs/models/user_model.dart';
import 'package:future_jobs/providers/auth_provider.dart';
import 'package:future_jobs/providers/user_provider.dart';
import 'package:future_jobs/shared/sharedpref_keys.dart';
import 'package:future_jobs/size_config.dart';
import 'package:future_jobs/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Shared Preference
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Controller
  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController goalController = TextEditingController(text: '');

  bool isLoading = false;

  Future<void> _setLoginState(UserModel user) async {
    final SharedPreferences prefs = await _prefs;
    // final bool isLogin = (prefs.getBool(SharedPrefConfig.IS_LOGIN) ?? false);
    prefs.setString(SharedPrefConfig.USERNAME, user.name).then(
      (bool success) {
        prefs.setBool(SharedPrefConfig.IS_LOGIN, true).then(
          (bool success) {
            setState(() {
              isLoading = false;
            });
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
            return true;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var authProvider = Provider.of<AuthProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);

    void showError(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            message,
            style: whiteTextStyle.copyWith(
              fontSize: SizeConfig.scaleText(16),
            ),
          ),
        ),
      );
    }

    void submitSignUp() async {
      if (nameController.text.isEmpty ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          goalController.text.isEmpty) {
        showError('Semua field harus diisi');
      } else {
        setState(() {
          isLoading = true;
        });

        UserModel user = await authProvider.register(
          emailController.text,
          passwordController.text,
          nameController.text,
          goalController.text,
        );

        if (user == null) {
          setState(() {
            isLoading = false;
          });
          showError('email sudah terdaftar');
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
            'Sign Up',
            style: greyTextStyle.copyWith(
              fontSize: SizeConfig.scaleText(16),
            ),
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(2),
          ),
          Text(
            'Begin New Journey',
            style: blackTextStyle.copyWith(
              fontSize: SizeConfig.scaleText(24),
              fontWeight: semiBold,
            ),
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(30),
          ),
        ],
      );
    }

    Widget inputImage() {
      return Center(
        child: Container(
          width: SizeConfig.scaleText(120),
          height: SizeConfig.scaleText(120),
          padding: EdgeInsets.all(SizeConfig.scaleWidth(8)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: primaryColor,
            ),
          ),
          child: Image.asset(
            'assets/image_profile.png',
          ),
        ),
      );
    }

    Widget inputName() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.scaleHeight(20),
          ),
          Text(
            'Full Name',
            style: greyTextStyle.copyWith(
              fontSize: SizeConfig.scaleText(16),
            ),
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(8),
          ),
          TextFormField(
            controller: nameController,
            cursorColor: primaryColor,
            onChanged: (value) {
              setState(() {});
            },
            style: purpleTextStyle.copyWith(
              fontSize: SizeConfig.scaleText(16),
            ),
            textInputAction: TextInputAction.next,
            decoration: kInputDecorTheme(),
          ),
        ],
      );
    }

    Widget inputEmail() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.scaleHeight(20),
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
            controller: emailController,
            cursorColor: primaryColor,
            onChanged: (value) {
              setState(() {});
            },
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: kInputDecorTheme(),
            style: EmailValidator.validate(emailController.text)
                ? purpleTextStyle.copyWith(fontSize: SizeConfig.scaleText(16))
                : redTextStyle.copyWith(fontSize: SizeConfig.scaleText(16)),
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
            controller: passwordController,
            cursorColor: primaryColor,
            obscureText: true,
            onChanged: (value) {
              setState(() {});
            },
            textInputAction: TextInputAction.next,
            decoration: kInputDecorTheme(),
            style: purpleTextStyle.copyWith(
              fontSize: SizeConfig.scaleText(16),
            ),
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
            style: greyTextStyle.copyWith(
              fontSize: SizeConfig.scaleText(16),
            ),
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(8),
          ),
          TextFormField(
            controller: goalController,
            cursorColor: primaryColor,
            onChanged: (value) {
              setState(() {});
            },
            onFieldSubmitted: (_) => submitSignUp,
            textInputAction: TextInputAction.done,
            decoration: kInputDecorTheme(),
            style: purpleTextStyle.copyWith(
              fontSize: SizeConfig.scaleText(16),
            ),
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
        child: isLoading
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
    );
  }
}
