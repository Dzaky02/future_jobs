import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:future_jobs/models/user_model.dart';

import '../extension/extensions.dart';

class ProfilePage extends StatelessWidget {
  final UserModel user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Howdy', style: context.text.subtitle1),
          Container(
            width: context.dp(200),
            height: context.dp(200),
            margin:
                EdgeInsets.only(top: context.dp(10), bottom: context.dp(20)),
            padding: EdgeInsets.all(context.dp(12)),
            decoration: _neumorphicBox(BoxShape.circle),
            child: SvgPicture.asset('assets/svg/male_avatar.svg'),
          ),
          Container(
            width: context.dp(300),
            padding: EdgeInsets.all(context.dp(16)),
            decoration: _neumorphicBox(),
            child: Column(
              children: _userDataDisplayText(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _userDataDisplayText(BuildContext context) => [
    Text(
      user.name,
      maxLines: 2,
      softWrap: true,
      textAlign: TextAlign.center,
      textScaleFactor: context.ts,
      overflow: TextOverflow.ellipsis,
      style: context.text.headline6?.copyWith(height: 1.6),
    ),
    Text(
      user.email,
      maxLines: 1,
      softWrap: true,
      textAlign: TextAlign.center,
      textScaleFactor: context.ts,
      overflow: TextOverflow.ellipsis,
      style: context.text.bodyText1?.copyWith(height: 1.6),
    ),
    Text(
      user.goal,
      maxLines: 1,
      softWrap: true,
      textAlign: TextAlign.center,
      textScaleFactor: context.ts,
      overflow: TextOverflow.ellipsis,
      style: context.text.bodyText2?.copyWith(height: 1.6),
    ),
  ];

  BoxDecoration _neumorphicBox([BoxShape shape = BoxShape.rectangle]) {
    return BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius:
          (shape == BoxShape.rectangle) ? BorderRadius.circular(16) : null,
      shape: shape,
      boxShadow: [
        BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 0.0,
            blurRadius: 6,
            offset: Offset(3.0, 3.0)),
        BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 0.0,
            blurRadius: 6 / 2.0,
            offset: Offset(3.0, 3.0)),
        BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 2.0,
            blurRadius: 6,
            offset: Offset(-3.0, -3.0)),
        BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 2.0,
            blurRadius: 6 / 2,
            offset: Offset(-3.0, -3.0)),
      ],
    );
  }
}
