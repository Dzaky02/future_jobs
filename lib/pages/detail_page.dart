import 'package:flutter/material.dart';
import 'package:future_jobs/providers/job_provider.dart';
import 'package:provider/provider.dart';

import '../extension/extensions.dart';
import '../models/job_model.dart';
import '../shared/theme.dart';

class DetailPage extends StatefulWidget {
  final JobModel job;

  DetailPage(this.job);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  double? _bottom;
  double? _top;
  var _myScrollController = ScrollController();

  late JobProvider _jobProvider;

  List<String> _subTitle = [
    'About the job',
    'Qualifications',
    'Responsibilities'
  ];

  @override
  void initState() {
    super.initState();
    // Scroll Controller Listener
    _myScrollController.addListener(_onScrollOffset);
    _jobProvider = Provider.of<JobProvider>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    if (mounted) {
      if (_jobProvider.findById(widget.job.id).isApplied) {
        _top = context.dh - 95;
        _bottom = 0;
      } else {
        _top = -100;
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _myScrollController.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (this.mounted) {
      super.setState(fn);
    } else {
      fn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: _buildBody(context),
      ),
    );
  }

  Future<void> _toggleApplied() async =>
      await _jobProvider.toggleApplyJob(widget.job.id);

  void _onScrollOffset() {
    if (_myScrollController.offset < 140) {
      setState(() {
        _top = context.dh - 95;
        _bottom = 0;
      });
    } else {
      setState(() {
        _top = 0;
        _bottom = context.dh - 95;
      });
    }
    // print(_myScrollController.offset);
  }

  AnimatedPositioned _buildAppliedMessage(
      BuildContext context, bool isApplied) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      top: isApplied ? _top : -100,
      bottom: isApplied ? _bottom : null,
      child: AnimatedContainer(
        width: context.dw,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.symmetric(
            vertical: context.dp(10), horizontal: context.dp(24)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(_bottom == 0 ? 50 : 0),
            bottom: Radius.circular(_top == 0 ? 50 : 0),
          ),
          color: context.surface,
        ),
        child: Text(
          'You have applied this job and the\nrecruiter will contact you',
          textAlign: TextAlign.center,
          textScaleFactor: context.ts,
          style: context.text.bodyText2?.copyWith(color: context.onSurface),
        ),
      ),
    );
  }

  Widget _header() => Column(
        children: [
          Image.network(widget.job.companyLogo, width: context.dp(60)),
          SizedBox(height: context.dp(16)),
          Text(widget.job.name, style: context.text.headline6),
          Text('${widget.job.companyName} • ${widget.job.location}',
              style: context.text.bodyText2?.copyWith(height: 1.8)),
        ],
      );

  Widget detailItem(String text) => Container(
      margin: EdgeInsets.only(top: context.dp(12)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.adjust, color: context.primaryColor, size: context.dp(12)),
        SizedBox(width: context.dp(8)),
        Expanded(
          child: Text(text,
              textScaleFactor: context.ts,
              style: context.text.caption?.copyWith(height: 1.5)),
        )
      ]));

  Widget _sectionTemplate(String subTitle, List data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.h(30)),
          Text(subTitle,
              textScaleFactor: context.ts, style: context.text.subtitle2),
          Column(children: data.map((item) => detailItem(item)).toList()),
        ],
      );

  Widget _applyButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _toggleApplied,
        child: Text('Apply for Job'),
      ),
    );
  }

  Widget _cancelButton() {
    return Center(
      child: TextButton(
        onPressed: _toggleApplied,
        style: context.elevatedButton.style?.copyWith(
          backgroundColor: MaterialStateProperty.all(context.errorColor),
          foregroundColor: MaterialStateProperty.all(context.onError),
        ),
        child: Text('Cancel Apply'),
      ),
    );
  }

  Widget _messageButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: TextButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 500),
            content: Text('Message Recruiter Clicked'),
            backgroundColor: context.primaryColor,
          ),
        ),
        child: Text('Message Recruiter'),
      ),
    );
  }

  Stack _buildBody(BuildContext context) {
    return Stack(
      children: [
        ListView(
          controller: _myScrollController,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: context.dp(defaultMargin),
            vertical: context.dp(35),
          ),
          children: [
            _header(),
            _sectionTemplate(_subTitle[0], widget.job.about),
            _sectionTemplate(_subTitle[1], widget.job.qualifications),
            _sectionTemplate(_subTitle[2], widget.job.responsibilities),
            SizedBox(height: context.dp(50)),
            Consumer<JobProvider>(
                builder: (context, value, child) =>
                    value.findById(widget.job.id).isApplied
                        ? _cancelButton()
                        : _applyButton()),
            _messageButton(),
          ],
        ),
        Consumer<JobProvider>(
            builder: (context, value, child) => _buildAppliedMessage(
                context, value.findById(widget.job.id).isApplied)),
      ],
    );
  }
}
