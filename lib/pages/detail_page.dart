import 'package:flutter/material.dart';
import 'package:future_jobs/models/job_model.dart';
import 'package:future_jobs/size_config.dart';

import '../theme.dart';

class DetailPage extends StatefulWidget {
  final JobModel job;

  DetailPage(this.job);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isApplied = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    Widget header() {
      return Column(
        children: [
          if (isApplied)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                bottom: SizeConfig.scaleHeight(30),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.scaleWidth(24),
                vertical: SizeConfig.scaleHeight(8),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  SizeConfig.scaleWidth(48),
                ),
                color: Color(0xffECEDF1),
              ),
              child: Text(
                'You have applied this job and the\nrecruiter will contact you',
                textAlign: TextAlign.center,
                style: greyTextStyle.copyWith(
                  fontSize: SizeConfig.scaleText(14),
                ),
              ),
            ),
          Image.network(
            widget.job.companyLogo,
            width: SizeConfig.scaleWidth(60),
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(20),
          ),
          Text(
            widget.job.name,
            style: blackTextStyle.copyWith(
              fontSize: 20,
              fontWeight: semiBold,
            ),
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(2),
          ),
          Text(
            '${widget.job.companyName} • ${widget.job.location}',
            style: greyTextStyle,
          ),
        ],
      );
    }

    Widget detailItem(String text) {
      return Container(
        margin: EdgeInsets.only(
          top: SizeConfig.scaleHeight(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.adjust,
              color: primaryColor,
              size: SizeConfig.scaleWidth(12),
            ),
            SizedBox(
              width: SizeConfig.scaleWidth(8),
            ),
            Expanded(
              child: Text(
                text,
                style: blackTextStyle.copyWith(
                  fontWeight: light,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget aboutJob() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.scaleHeight(30),
          ),
          Text(
            'About the job',
            style: blackTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
          Column(
            children:
                widget.job.about.map((about) => detailItem(about)).toList(),
          ),
        ],
      );
    }

    Widget qualifications() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.scaleHeight(30),
          ),
          Text(
            'Qualifications',
            style: blackTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
          Column(
            children: widget.job.qualifications
                .map((qualification) => detailItem(qualification))
                .toList(),
          ),
        ],
      );
    }

    Widget responsibilities() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.scaleHeight(30),
          ),
          Text(
            'Responsibilities',
            style: blackTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
          Column(
            children: widget.job.responsibilities
                .map((responsibility) => detailItem(responsibility))
                .toList(),
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(50),
          )
        ],
      );
    }

    Widget applyButton() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                isApplied = true;
              });
            },
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  SizeConfig.scaleWidth(66),
                ),
              ),
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.scaleWidth(12),
                horizontal: SizeConfig.scaleWidth(60),
              ),
            ),
            child: Text(
              'Apply for Job',
              style: whiteTextStyle.copyWith(
                fontWeight: medium,
              ),
            ),
          ),
        ],
      );
    }

    Widget cancelButton() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                isApplied = false;
              });
            },
            style: ElevatedButton.styleFrom(
              primary: redColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  SizeConfig.scaleWidth(66),
                ),
              ),
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.scaleWidth(12),
                horizontal: SizeConfig.scaleWidth(60),
              ),
            ),
            child: Text(
              'Cancel Apply',
              style: whiteTextStyle.copyWith(
                fontWeight: medium,
              ),
            ),
          ),
        ],
      );
    }

    Widget messageButton() {
      return Container(
        child: TextButton(
          onPressed: () {},
          child: Text(
            'Message Recruiter',
            style: greyTextStyle.copyWith(
              fontSize: SizeConfig.scaleText(16),
              fontWeight: medium,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.scaleWidth(defaultMargin),
            vertical: SizeConfig.scaleHeight(30),
          ),
          children: [
            header(),
            aboutJob(),
            qualifications(),
            responsibilities(),
            isApplied ? cancelButton() : applyButton(),
            messageButton(),
          ],
        ),
      ),
    );
  }
}
