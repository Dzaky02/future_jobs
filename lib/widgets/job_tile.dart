import 'package:flutter/material.dart';
import 'package:future_jobs/models/job_model.dart';
import 'package:future_jobs/pages/detail_page.dart';
import 'package:future_jobs/size_config.dart';

import '../theme.dart';

class JobTile extends StatelessWidget {
  final JobModel job;

  JobTile(this.job);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(job),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            job.companyLogo,
            width: SizeConfig.scaleWidth(44),
          ),
          SizedBox(
            width: SizeConfig.scaleWidth(24),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.name,
                  style: blackTextStyle.copyWith(
                    fontSize: SizeConfig.scaleText(16),
                    fontWeight: medium,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.scaleHeight(2),
                ),
                Text(
                  job.companyName,
                  style: greyTextStyle,
                ),
                SizedBox(
                  height: SizeConfig.scaleHeight(14),
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: SizeConfig.scaleHeight(12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
