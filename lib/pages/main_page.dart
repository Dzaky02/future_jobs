import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import './home_page.dart';
import './under_construction_page.dart';
import '../widgets/custom_navbar.dart';

class MainPage extends StatefulWidget {
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
    UnderConstructionPage(
        key: Key('Main-3'),
        imgPath: 'assets/svg/male_avatar.svg',
        pageName: 'Profile Page'),
  ];

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
        child: pages[_selectedIndex],
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
