import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          SvgPicture.asset(
            imgPath,
            width: context.dp(200),
            fit: BoxFit.fitWidth,
          ),
          SizedBox(height: 14),
          Text('Sorry, $pageName now is under construction.',
              textAlign: TextAlign.center, style: context.text.subtitle1),
        ],
      ),
    );
  }
}
