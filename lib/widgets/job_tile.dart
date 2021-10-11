import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../extension/extensions.dart';
import '../models/job_model.dart';
import '../pages/detail_page.dart';

class JobTile extends StatelessWidget {
  final JobModel job;

  JobTile(this.job);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0,
      transitionDuration: Duration(seconds: 1),
      openBuilder: (context, action) => DetailPage(job),
      closedShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      closedBuilder: (context, openContainer) => ListTile(
        onTap: openContainer,
        minLeadingWidth: context.dp(45),
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: context.dp(26),
        minVerticalPadding: context.dp(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      shape: BoxShape.circle, color: Colors.grey.shade300)),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            width: context.dp(45),
            height: context.dp(45),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.grey.shade400),
            child: Icon(Icons.image_not_supported, color: context.onSurface),
          ),
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
      ),
    );
  }
}
