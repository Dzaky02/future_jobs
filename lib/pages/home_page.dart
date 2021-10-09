import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/category_model.dart';
import '../models/job_model.dart';
import '../models/user_model.dart';
import '../providers/category_provider.dart';
import '../providers/job_provider.dart';
import '../providers/user_provider.dart';
import '../shared/shared_value.dart';
import '../shared/sharedpref_keys.dart';
import '../shared/theme.dart';
import '../size_config.dart';
import '../widgets/category_card.dart';
import '../widgets/custom_navbar.dart';
import '../widgets/job_tile.dart';

enum SelectedMenu { setting, logout }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Shared Preferences
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<UserModel?> _user;

  // Bottom Navigation Bar Value
  int _selectedIndex = 0;
  List<String> icons = [
    'assets/svg/icon_home.svg',
    'assets/svg/icon_notification.svg',
    'assets/svg/icon_love.svg',
    'assets/svg/icon_user.svg',
  ];

  Future<void> _logout() async {
    final SharedPreferences prefs = await _prefs;

    prefs.setBool(SharedPrefKey.IS_LOGIN, false).then(
      (bool success) {
        prefs.setString(SharedPrefKey.USER, '').then((value) =>
            Navigator.pushNamedAndRemoveUntil(
                context, RouteName.onBoarding, (route) => false));
        return false;
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _user = _prefs.then((SharedPreferences prefs) {
      String userData = prefs.getString(SharedPrefKey.USER) ?? '';
      if (userData.isEmpty)
        return null;
      else
        return UserModel.fromJson(jsonDecode(userData));
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var userProvider = Provider.of<UserProvider>(context);
    var categoryProvider = Provider.of<CategoryProvider>(context);
    var jobProvider = Provider.of<JobProvider>(context);

    Widget header() {
      return Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.scaleHeight(30),
          left: SizeConfig.scaleWidth(defaultMargin),
          right: SizeConfig.scaleWidth(defaultMargin),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Howdy',
                  style: greyTextStyle.copyWith(
                    fontSize: SizeConfig.scaleText(16),
                  ),
                ),
                (userProvider.getUser() != null)
                    ? Text(
                        userProvider.getUser()!.name,
                        style: blackTextStyle.copyWith(
                          fontSize: SizeConfig.scaleText(24),
                          fontWeight: semiBold,
                        ),
                      )
                    : FutureBuilder<UserModel?>(
                        future: _user,
                        builder: (BuildContext context,
                            AsyncSnapshot<UserModel?> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Text(
                                'Getting data...',
                                style: blackTextStyle.copyWith(
                                  fontSize: SizeConfig.scaleText(24),
                                  fontWeight: semiBold,
                                ),
                              );
                            default:
                              if (snapshot.hasError || !snapshot.hasData) {
                                return Text(
                                  'Error: ${snapshot.error}',
                                  style: blackTextStyle.copyWith(
                                    fontSize: SizeConfig.scaleText(24),
                                    fontWeight: semiBold,
                                  ),
                                );
                              } else {
                                userProvider.user = snapshot.data!;
                                return Text(
                                  userProvider.getUser()!.name,
                                  style: blackTextStyle.copyWith(
                                    fontSize: SizeConfig.scaleText(24),
                                    fontWeight: semiBold,
                                  ),
                                );
                              }
                          }
                        },
                      ),
              ],
            ),
            PopupMenuButton<SelectedMenu>(
              onSelected: (value) {
                switch (value) {
                  case SelectedMenu.logout:
                    _logout();
                    break;
                  default:
                    break;
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              offset: Offset(
                -SizeConfig.scaleWidth(20),
                SizeConfig.scaleWidth(50),
              ),
              itemBuilder: (context) => [
                const PopupMenuItem<SelectedMenu>(
                  value: SelectedMenu.setting,
                  child: Text('Setting'),
                ),
                const PopupMenuItem<SelectedMenu>(
                  value: SelectedMenu.logout,
                  child: Text('Log Out'),
                ),
              ],
              child: Container(
                width: SizeConfig.scaleWidth(58),
                padding: EdgeInsets.all(SizeConfig.scaleWidth(4)),
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
            ),
          ],
        ),
      );
    }

    Widget hotCategories() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.scaleHeight(30),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.scaleWidth(defaultMargin),
            ),
            child: Text(
              'Hot Categories',
              style: blackTextStyle.copyWith(
                fontSize: SizeConfig.scaleText(16),
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(16),
          ),
          Container(
            height: SizeConfig.scaleHeight(200),
            child: FutureBuilder<List<CategoryModel>>(
              future: categoryProvider.getCategories(),
              builder: (context, snapshot) {
                // If future builder finish the prosess
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  int index = -1;
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    children: snapshot.data!.map((category) {
                      index++;
                      return Container(
                        width: SizeConfig.scaleWidth(150),
                        height: SizeConfig.scaleHeight(200),
                        margin: EdgeInsets.only(
                          left: index == 0
                              ? SizeConfig.scaleWidth(defaultMargin)
                              : 0,
                        ),
                        child: CategoryCard(category),
                      );
                    }).toList(),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      );
    }

    Widget justPosted() {
      return Container(
        padding: EdgeInsets.only(
          left: SizeConfig.scaleWidth(defaultMargin),
          right: SizeConfig.scaleWidth(defaultMargin),
          top: SizeConfig.scaleHeight(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Just Posted',
              style: blackTextStyle.copyWith(
                fontSize: SizeConfig.scaleText(16),
              ),
            ),
            SizedBox(
              height: SizeConfig.scaleHeight(24),
            ),
            FutureBuilder<List<JobModel>>(
              future: jobProvider.getJobs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children:
                        snapshot.data!.map((job) => JobTile(job)).toList(),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      );
    }

    Widget bottomNavBar() {
      return CustomNavBar(
        icons: icons,
        onTap: (value) => setState(() => _selectedIndex = value),
        selectedIndex: _selectedIndex,
      );
    }

    Widget body() {
      return ListView(
        physics: BouncingScrollPhysics(),
        children: [
          header(),
          hotCategories(),
          justPosted(),
        ],
      );
    }

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: bottomNavBar(),
      body: body(),
    );
  }
}
