import 'package:flutter/material.dart';
import 'package:future_jobs/models/category_model.dart';
import 'package:future_jobs/models/job_model.dart';
import 'package:future_jobs/providers/category_provider.dart';
import 'package:future_jobs/providers/job_provider.dart';
import 'package:future_jobs/providers/user_provider.dart';
import 'package:future_jobs/size_config.dart';
import 'package:future_jobs/theme.dart';
import 'package:future_jobs/widgets/category_card.dart';
import 'package:future_jobs/widgets/job_tile.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
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
                Text(
                  userProvider.user.name,
                  style: blackTextStyle.copyWith(
                    fontSize: SizeConfig.scaleText(24),
                    fontWeight: semiBold,
                  ),
                ),
              ],
            ),
            Container(
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
                if (snapshot.connectionState == ConnectionState.done) {
                  int index = -1;
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    children: snapshot.data.map((category) {
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
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: snapshot.data.map((job) => JobTile(job)).toList(),
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
      return BottomNavigationBar(
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icon_home.png',
              width: 24,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icon_notification.png',
              width: 24,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icon_love.png',
              width: 24,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icon_user.png',
              width: 24,
            ),
            label: '',
          ),
        ],
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
      bottomNavigationBar: bottomNavBar(),
      body: body(),
    );
  }
}
