import 'package:flutter/material.dart';
import 'package:future_jobs/models/user_model.dart';
import 'package:future_jobs/providers/auth_provider.dart';
import 'package:future_jobs/providers/user_provider.dart';
import 'package:future_jobs/size_config.dart';
import 'package:future_jobs/theme.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.scaleWidth(11),
              horizontal: SizeConfig.scaleWidth(20),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: inputFieldColor,
            ),
            child: Center(
              child: TextFormField(
                controller: emailController,
                cursorColor: primaryColor,
                style: purpleTextStyle.copyWith(
                  fontSize: SizeConfig.scaleText(16),
                ),
                decoration: InputDecoration.collapsed(
                  hintText: '',
                ),
              ),
            ),
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.scaleWidth(11),
              horizontal: SizeConfig.scaleWidth(20),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: inputFieldColor,
            ),
            child: Center(
              child: TextFormField(
                controller: passwordController,
                cursorColor: primaryColor,
                obscureText: true,
                style: purpleTextStyle.copyWith(
                  fontSize: SizeConfig.scaleText(16),
                ),
                decoration: InputDecoration.collapsed(
                  hintText: '',
                ),
              ),
            ),
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
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ElevatedButton(
                onPressed: () async {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    showError('Semua field harus diisi');
                  } else {
                    setState(() {
                      isLoading = true;
                    });

                    print(
                        emailController.text + '\n' + passwordController.text);

                    UserModel user = await authProvider.login(
                      emailController.text,
                      passwordController.text,
                    );

                    setState(() {
                      isLoading = false;
                    });

                    if (user == null) {
                      showError('email atau password salah');
                    } else {
                      userProvider.user = user;
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(66),
                  ),
                  padding: EdgeInsets.all(SizeConfig.scaleWidth(12)),
                ),
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
          onPressed: () {
            Navigator.pushNamed(context, '/sign-up');
          },
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
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.scaleHeight(30),
            horizontal: SizeConfig.scaleWidth(24),
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
