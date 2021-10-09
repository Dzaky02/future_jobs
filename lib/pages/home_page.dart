import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../models/job_model.dart';
import '../providers/auth_provider.dart';
import '../providers/category_provider.dart';
import '../providers/job_provider.dart';
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
  var _isInit = true;

  // Providers
  late AuthProvider _authProvider;
  late CategoryProvider _categoryProvider;
  late JobProvider _jobProvider;

  // Bottom Navigation Bar Value
  int _selectedIndex = 0;
  List<String> icons = [
    'assets/svg/icon_home.svg',
    'assets/svg/icon_notification.svg',
    'assets/svg/icon_love.svg',
    'assets/svg/icon_user.svg',
  ];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _authProvider = Provider.of<AuthProvider>(context, listen: false);
      _categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      _jobProvider = Provider.of<JobProvider>(context, listen: false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

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
                Text(
                  _authProvider.getUser()!.name,
                  style: blackTextStyle.copyWith(
                    fontSize: SizeConfig.scaleText(24),
                    fontWeight: semiBold,
                  ),
                ),
              ],
            ),
            PopupMenuButton<SelectedMenu>(
              onSelected: (value) {
                switch (value) {
                  case SelectedMenu.logout:
                    _authProvider.logout();
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
              future: _categoryProvider.getCategories(),
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
              future: _jobProvider.getJobs(),
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
