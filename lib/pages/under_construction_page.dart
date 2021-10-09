import 'package:flutter/material.dart';

import '../extension/screen_utils_extension.dart';

class UnderConstructionPage extends StatelessWidget {
  final String imgPath;
  final String pageName;

  const UnderConstructionPage(
      {Key? key, required this.imgPath, required this.pageName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.dp(40)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imgPath,
            width: context.dp(200),
            fit: BoxFit.fitWidth,
          ),
          Text('Sorry, $pageName now is under construction.',
              style: context.text.subtitle1),
        ],
      ),
    );
  }
}
