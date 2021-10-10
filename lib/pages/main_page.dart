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
    HomePage(),
    UnderConstructionPage(
        imgPath: 'assets/image_sign_in.png', pageName: 'Notification'),
    UnderConstructionPage(
        imgPath: 'assets/image_sign_in.png', pageName: 'Favorite Job\'s'),
    UnderConstructionPage(
        imgPath: 'assets/image_sign_in.png', pageName: 'Profile Page'),
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
    return SafeArea(bottom: false, child: pages[_selectedIndex]);
  }

  Widget _bottomNavBar() {
    return CustomNavBar(
      icons: icons,
      onTap: (value) => setState(() => _selectedIndex = value),
      selectedIndex: _selectedIndex,
    );
  }
}
