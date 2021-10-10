import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../extension/screen_utils_extension.dart';
import '../models/job_model.dart';

class JobTile extends StatelessWidget {
  final JobModel job;

  JobTile(this.job);

  void _onClickJobTile(JobModel job) {
    // Do something
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _onClickJobTile(job),
      minLeadingWidth: context.dp(45),
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: context.dp(26),
      minVerticalPadding: context.dp(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      leading: Image.network(
        job.companyLogo,
        fit: BoxFit.fitWidth,
        width: context.dp(45),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: context.dp(45),
              height: context.dp(45),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey.shade300),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  color: context.secondaryColor,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            ),
          );
        },
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
