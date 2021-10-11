import 'package:flutter/material.dart';
import 'package:future_jobs/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';

import '../extension/extensions.dart';
import '../models/category_model.dart';
import '../models/job_model.dart';
import '../providers/job_provider.dart';
import '../shared/theme.dart';
import '../widgets/job_tile.dart';

class CategoryPage extends StatefulWidget {
  final CategoryModel category;

  CategoryPage(this.category);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  var _isInit = true;
  var _isLoadBigCompanies = true;
  var _isLoadStartups = true;
  var _myScrollController = ScrollController();

  // Provider
  late JobProvider _jobProvider;

  // List Data
  List<JobModel> _bigCompanies = [];
  List<JobModel> _startups = [];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      // Scroll Controller Listener
      _myScrollController.addListener(_onRefreshPage);

      // Provider
      _jobProvider = Provider.of<JobProvider>(context);

      _jobProvider.getJobsByCategory(widget.category.name).then((value) {
        _bigCompanies = value;
        setState(() => _isLoadBigCompanies = false);
      });

      _jobProvider.getJobs().then((value) {
        _startups = value;
        setState(() => _isLoadStartups = false);
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _myScrollController.removeListener(_onRefreshPage);
    _myScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _myScrollController,
        physics: (_isLoadBigCompanies || _isLoadStartups)
            ? NeverScrollableScrollPhysics()
            : BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          if (_isLoadBigCompanies || _isLoadStartups)
            ..._generateShimmerSlivers(),
          if (!_isLoadBigCompanies && !_isLoadStartups)
            ..._generateReadySlivers(),
        ],
      ),
    );
  }

  List<Widget> _generateShimmerSlivers() => [
        _buildShimmerSubTitle(context, 214),
        _buildShimmerList(context, 2),
        _buildShimmerSubTitle(context, 230),
        _buildShimmerList(context, 6),
      ];

  List<Widget> _generateReadySlivers() => [
        _buildSubTitle(context, 'Big Companies'),
        _buildSliverList(context, _bigCompanies),
        _buildSubTitle(context, 'New Startups', 12),
        _buildSliverList(context, _startups, 30),
      ];

  Future<void> _onRefreshPage() async {
    if (_myScrollController.offset < -110) {
      print('ON REFRESH TRIGGERED');
      setState(() {
        _isLoadBigCompanies = true;
        _isLoadStartups = true;
      });
      await _jobProvider.refreshByCategory(widget.category.name).then((value) {
        _bigCompanies = value;
        setState(() => _isLoadBigCompanies = false);
      });
      await _jobProvider.refresh().then((value) {
        _startups = value;
        setState(() => _isLoadStartups = false);
      });
      print('SUCCESS REFRESH');
    }
  }

  SliverPadding _buildShimmerSubTitle(BuildContext context, double right) {
    return SliverPadding(
      padding: EdgeInsets.only(
        top: context.h(30),
        bottom: context.h(16),
        right: context.dp(right),
        left: context.dp(defaultMargin),
      ),
      sliver: SliverToBoxAdapter(
        child: ShimmerWidget.rectangle(
            width: context.dp(106), height: context.dp(24)),
      ),
    );
  }

  SliverPadding _buildShimmerList(BuildContext context, int itemCount) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: context.dp(defaultMargin)),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index.isOdd) {
            return Divider(
              thickness: 2,
              height: context.h(18),
              color: context.surface,
              indent: context.dp(70),
            );
          }

          return ListTile(
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
          );
        }, childCount: itemCount),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      elevation: 4,
      pinned: true,
      stretch: true,
      centerTitle: true,
      backgroundColor: primaryColor,
      collapsedHeight: context.h(77),
      expandedHeight: context.h(270),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        collapseMode: CollapseMode.parallax,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Hero(
              tag: widget.category.id.categoryTitle,
              transitionOnUserGestures: true,
              child: Text(widget.category.name,
                  textScaleFactor: context.ts,
                  style: context.text.headline6
                      ?.copyWith(fontSize: 16, color: context.onPrimary)),
            ),
            Text('12,309 available',
                textScaleFactor: context.ts,
                style: context.text.subtitle1
                    ?.copyWith(fontSize: 12, color: context.onPrimary)),
          ],
        ),
        background: Hero(
          tag: widget.category.id.categoryImg,
          transitionOnUserGestures: true,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            child: Image.network(
              widget.category.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        stretchModes: const <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
        ],
      ),
    );
  }

  SliverPadding _buildSubTitle(BuildContext context, String subTitle,
      [double paddingTop = 30]) {
    return SliverPadding(
      padding: EdgeInsets.only(
        top: context.h(paddingTop),
        bottom: context.h(16),
        left: context.dp(defaultMargin),
      ),
      sliver: SliverToBoxAdapter(
        child: Text(subTitle, style: context.text.subtitle1),
      ),
    );
  }

  SliverPadding _buildSliverList(BuildContext context, List<JobModel> items,
      [double paddingBottom = 0]) {
    return SliverPadding(
      padding: EdgeInsets.only(
        bottom: paddingBottom,
        left: context.dp(defaultMargin),
        right: context.dp(defaultMargin),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index.isOdd) {
            return Divider(
              thickness: 2,
              height: context.h(18),
              color: context.surface,
              indent: context.dp(70),
            );
          }
          return JobTile(items[index ~/ 2]);
        }, childCount: (items.length * 2)),
      ),
    );
  }
}
