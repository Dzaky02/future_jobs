import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:future_jobs/models/user_model.dart';

import './home_page.dart';
import './under_construction_page.dart';
import '../pages/profile_page.dart';
import '../widgets/custom_navbar.dart';

class MainPage extends StatefulWidget {
  final UserModel user;

  const MainPage({Key? key, required this.user}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Bottom Navigation Bar Value
  int _selectedIndex = 0;
  List<String> icons = [
    'assets/svg/icon_home.svg',
    'assets/svg/icon_notification.svg',
    'assets/svg/icon_love.svg',
    'assets/svg/icon_user.svg',
  ];

  List<Widget> pages = [
    HomePage(key: Key('Main-0')),
    UnderConstructionPage(
        key: Key('Main-1'),
        imgPath: 'assets/svg/notification.svg',
        pageName: 'Notification'),
    UnderConstructionPage(
        key: Key('Main-2'),
        imgPath: 'assets/svg/noted_list.svg',
        pageName: 'Favorite Job\'s'),
  ];

  @override
  void initState() {
    super.initState();
    if (pages.length < 4) {
      pages.add(ProfilePage(key: Key('Main-3'), user: widget.user));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: _bottomNavBar(),
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
      bottom: false,
      child: PageTransitionSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
            FadeThroughTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                child: child),
        child: Scaffold(body: pages[_selectedIndex]),
      ),
    );
  }

  Widget _bottomNavBar() {
    return CustomNavBar(
      icons: icons,
      onTap: (value) => setState(() => _selectedIndex = value),
      selectedIndex: _selectedIndex,
    );
  }
}
