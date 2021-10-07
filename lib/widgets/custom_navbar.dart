import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<Widget> items;

  const CustomNavBar({this.selectedIndex = 0, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xffA1A1DE),
            Color(0xffA1A1DE).withOpacity(0),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [_buildItem(context)],
      ),
    );
  }

  Widget _buildItem(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 2),
      height: 40,
      alignment: (selectedIndex == 0) ? Alignment.topCenter : Alignment.center,
      child: SvgPicture.asset(
        'assets/svg/icon_home.svg',
        width: 24,
      ),
    );
  }
}
