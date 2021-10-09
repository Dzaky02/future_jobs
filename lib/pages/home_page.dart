import 'package:flutter/material.dart';
import 'package:future_jobs/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';

import '../extension/screen_utils_extension.dart';
import '../models/category_model.dart';
import '../models/job_model.dart';
import '../providers/auth_provider.dart';
import '../providers/category_provider.dart';
import '../providers/job_provider.dart';
import '../shared/theme.dart';
import '../widgets/category_card.dart';

enum SelectedMenu { setting, logout }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isInit = true;
  var _isLoadCategory = true;
  var _isLoadJobs = true;

  // Providers
  late AuthProvider _authProvider;
  late CategoryProvider _categoryProvider;
  late JobProvider _jobProvider;

  // List Data
  List<CategoryModel> _categories = [];
  List<JobModel> _jobs = [];

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

      _categoryProvider.getCategories().then((value) {
        _categories = value;
        setState(() => _isLoadCategory = false);
      });

      _jobProvider.getJobs().then((value) {
        _jobs = value;
        setState(() => _isLoadJobs = false);
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Widget body() {
      return CustomScrollView(
        physics: (_isLoadJobs || _isLoadCategory)
            ? NeverScrollableScrollPhysics()
            : BouncingScrollPhysics(),
        slivers: [
          SliverList(delegate: SliverChildListDelegate.fixed([header()])),
          if (_isLoadJobs || _isLoadCategory) _buildShimmerLoading(context),
          if (!_isLoadJobs && !_isLoadCategory)
            SliverList(
                delegate: SliverChildListDelegate.fixed([hotCategories()])),
          if (!_isLoadJobs && !_isLoadCategory) justPosted(),
        ],
      );
    }

    return SafeArea(child: body());
  }

  void _onClickJobTile(JobModel job) {
    // Do something
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
      padding: EdgeInsets.symmetric(
          vertical: context.h(30), horizontal: context.dp(defaultMargin)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Howdy',
                  style: context.text.subtitle1
                      ?.copyWith(color: context.hintColor)),
              SizedBox(
                width: context.dp(250),
                child: Text(
                  _authProvider.getUser()!.name,
                  maxLines: 1,
                  softWrap: true,
                  textScaleFactor: context.ts,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.headline6?.copyWith(height: 1.6),
                ),
              ),
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

  SliverFillRemaining _buildShimmerLoading(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      fillOverscroll: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: context.dp(defaultMargin)),
            child: ShimmerWidget.rectangle(
                width: context.dp(120), height: context.dp(24)),
          ),
          SizedBox(height: context.dp(16)),
          SizedBox(
            height: context.dp(180),
            child: ListView.builder(
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              padding:
                  EdgeInsets.symmetric(horizontal: context.dp(defaultMargin)),
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(left: index > 0 ? context.dp(14) : 0),
                child: ShimmerWidget.rounded(
                  width: context.dp(133),
                  height: context.dp(180),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          SizedBox(height: context.h(14)),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: context.dp(16),
                horizontal: context.dp(defaultMargin)),
            child: ShimmerWidget.rectangle(
                width: context.dp(92), height: context.dp(24)),
          ),
          SizedBox(
            height: context.h(300),
            child: ListView.separated(
              itemCount: 4,
              shrinkWrap: true,
              padding:
                  EdgeInsets.symmetric(horizontal: context.dp(defaultMargin)),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => ListTile(
                minLeadingWidth: context.dp(45),
                contentPadding: EdgeInsets.zero,
                horizontalTitleGap: context.dp(26),
                minVerticalPadding: context.dp(8),
                leading: ShimmerWidget.circle(
                    width: context.dp(45), height: context.dp(45)),
                title: ShimmerWidget.rectangle(
                    width: context.dp(180), height: context.dp(20)),
                subtitle: Padding(
                  padding: EdgeInsets.only(right: context.dp(120)),
                  child: ShimmerWidget.rectangle(
                      width: context.dp(80), height: context.dp(14)),
                ),
              ),
              separatorBuilder: (context, index) => Divider(
                thickness: 2,
                height: context.h(18),
                color: context.surface,
                indent: context.dp(80),
              ),
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.dp(defaultMargin)),
          child: Text('Hot Categories', style: context.text.subtitle1),
        ),
        SizedBox(height: context.dp(16)),
        Container(
          height: context.dp(180),
          child: ListView.builder(
            itemCount: _categories.length,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            padding:
                EdgeInsets.symmetric(horizontal: context.dp(defaultMargin)),
            itemBuilder: (context, index) => Container(
              width: context.dp(133),
              height: context.dp(180),
              margin: EdgeInsets.only(
                left: index > 0 ? context.dp(14) : 0,
              ),
              child: CategoryCard(_categories[index]),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: context.h(30),
            left: context.dp(defaultMargin),
            bottom: context.dp(8),
          ),
          child: Text('Just Posted', style: context.text.subtitle1),
        ),
      ],
    );
  }

  Widget justPosted() {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: context.dp(defaultMargin),
        right: context.dp(defaultMargin),
        bottom: context.dp(6),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index.isOdd) {
              return Divider(
                thickness: 2,
                height: context.h(18),
                color: context.surface,
                indent: context.dp(70),
              );
            }
            return _buildJobTile(context, _jobs[index ~/ 2]);
          },
          childCount: (_jobs.length * 2),
        ),
      ),
    );
  }

  ListTile _buildJobTile(BuildContext context, JobModel job) {
    return ListTile(
      onTap: () => _onClickJobTile(job),
      minLeadingWidth: context.dp(45),
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: context.dp(26),
      minVerticalPadding: context.dp(12),
      leading: Image.network(
        job.companyLogo,
        width: context.dp(45),
      ),
      title: Text(
        job.name,
        maxLines: 1,
        softWrap: true,
        textScaleFactor: context.ts,
        overflow: TextOverflow.ellipsis,
        style: context.text.bodyText1,
      ),
      subtitle: Text(
        job.companyName,
        maxLines: 1,
        softWrap: true,
        textScaleFactor: context.ts,
        overflow: TextOverflow.ellipsis,
        style: context.text.bodyText2,
      ),
    );
  }
}
