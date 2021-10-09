import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../extension/screen_utils_extension.dart';
import '../models/category_model.dart';
import '../models/job_model.dart';
import '../providers/auth_provider.dart';
import '../providers/category_provider.dart';
import '../providers/job_provider.dart';
import '../shared/theme.dart';
import '../widgets/category_card.dart';
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

  List<PopupMenuEntry<SelectedMenu>> _popMenuOption = const [
    const PopupMenuItem<SelectedMenu>(
        value: SelectedMenu.setting, child: const Text('Setting')),
    const PopupMenuItem<SelectedMenu>(
        value: SelectedMenu.logout, child: const Text('Log Out')),
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
    Widget hotCategories() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.h(30)),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: context.dp(defaultMargin)),
            child: Text('Hot Categories', style: context.text.subtitle1),
          ),
          SizedBox(height: context.dp(16)),
          Container(
            height: context.dp(180),
            child: FutureBuilder<List<CategoryModel>>(
              future: _categoryProvider.getCategories(),
              builder: (context, snapshot) {
                // If future builder finish the prosess
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                        horizontal: context.dp(defaultMargin)),
                    itemBuilder: (context, index) => Container(
                      width: context.dp(133),
                      height: context.dp(180),
                      margin: EdgeInsets.only(
                        left: index > 0 ? context.dp(14) : 0,
                      ),
                      child: CategoryCard(snapshot.data![index]),
                    ),
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
        padding: EdgeInsets.symmetric(
          horizontal: context.dp(defaultMargin),
          vertical: context.h(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Just Posted', style: context.text.subtitle1),
            SizedBox(height: context.dp(24)),
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

    return body();
  }

  void _onSelectedPopMenu(SelectedMenu value) {
    switch (value) {
      case SelectedMenu.logout:
        _authProvider.logout();
        break;
      default:
        break;
    }
  }

  Widget header() {
    return Padding(
      padding: EdgeInsets.only(
        top: context.h(30),
        left: context.dp(defaultMargin),
        right: context.dp(defaultMargin),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Howdy', style: context.text.subtitle1),
              Text(_authProvider.getUser()!.name,
                  style: context.text.headline6),
            ],
          ),
          PopupMenuButton<SelectedMenu>(
            onSelected: _onSelectedPopMenu,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            offset: Offset(-context.dp(20), context.dp(50)),
            itemBuilder: (context) => _popMenuOption,
            child: Container(
              width: context.dp(58),
              padding: EdgeInsets.all(context.dp(4)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.primaryVariant),
              ),
              child: Image.asset('assets/image_profile.png'),
            ),
          ),
        ],
      ),
    );
  }
}
