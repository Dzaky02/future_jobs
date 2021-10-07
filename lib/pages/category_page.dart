import 'package:flutter/material.dart';
import 'package:future_jobs/models/category_model.dart';
import 'package:future_jobs/models/job_model.dart';
import 'package:future_jobs/providers/job_provider.dart';
import 'package:future_jobs/size_config.dart';
import 'package:future_jobs/theme.dart';
import 'package:future_jobs/widgets/job_tile.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  // final String name;
  // final String imageUrl;
  final CategoryModel category;

  CategoryPage(this.category);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var jobProvider = Provider.of<JobProvider>(context);

    SliverAppBar header() {
      return SliverAppBar(
        elevation: 4,
        pinned: true,
        stretch: true,
        centerTitle: true,
        backgroundColor: primaryColor,
        collapsedHeight: SizeConfig.scaleHeight(77),
        expandedHeight: SizeConfig.scaleHeight(270),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(
              SizeConfig.scaleWidth(16),
            ),
          ),
        ),
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          collapseMode: CollapseMode.parallax,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.name,
                style: whiteTextStyle.copyWith(
                  fontSize: SizeConfig.scaleText(17),
                  fontWeight: semiBold,
                ),
              ),
              SizedBox(
                height: SizeConfig.scaleHeight(2),
              ),
              Text(
                '12,309 available',
                style: whiteTextStyle.copyWith(
                  fontSize: SizeConfig.scaleText(12),
                ),
              ),
            ],
          ),
          // titlePadding: EdgeInsets.symmetric(
          //   horizontal: SizeConfig.scaleWidth(defaultMargin),
          //   vertical: SizeConfig.scaleHeight(30),
          // ),
          background: ClipRRect(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(
                SizeConfig.scaleWidth(16),
              ),
            ),
            child: Image.network(
              category.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          stretchModes: const <StretchMode>[
            StretchMode.zoomBackground,
            StretchMode.fadeTitle,
          ],
        ),
      );
    }

    Widget companies() {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          top: SizeConfig.scaleHeight(30),
          left: SizeConfig.scaleWidth(defaultMargin),
          right: SizeConfig.scaleWidth(defaultMargin),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Big Companies',
              style: blackTextStyle.copyWith(
                fontSize: SizeConfig.scaleText(16),
              ),
            ),
            SizedBox(
              height: SizeConfig.scaleHeight(24),
            ),
            FutureBuilder<List<JobModel>>(
              future: jobProvider.getJobsByCategory(category.name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Column(
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

    Widget newStartups() {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          top: SizeConfig.scaleHeight(10),
          left: SizeConfig.scaleWidth(defaultMargin),
          right: SizeConfig.scaleWidth(defaultMargin),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Startups',
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
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Column(
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

    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          header(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                companies(),
                newStartups(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
