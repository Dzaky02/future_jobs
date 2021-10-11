import 'package:flutter/material.dart';
import 'package:future_jobs/pages/category_page.dart';
import 'package:shimmer/shimmer.dart';

import '../extension/extensions.dart';
import '../models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;

  CategoryCard(this.category);

  onTapFade(BuildContext context) => Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            reverseTransitionDuration: Duration(seconds: 1),
            pageBuilder: (context, animation, secondaryAnimation) {
              final curvedAnimation = CurvedAnimation(
                  parent: animation, curve: Curves.easeInOutCubic);

              return FadeTransition(
                opacity: curvedAnimation,
                child: CategoryPage(category),
              );
            }),
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapFade(context),
      child: Container(
        width: context.dp(133),
        height: context.dp(180),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Hero(
              tag: category.id.categoryImg,
              transitionOnUserGestures: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  category.imageUrl,
                  fit: BoxFit.cover,
                  width: context.dp(133),
                  height: context.dp(180),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                          width: context.dp(133),
                          height: context.dp(180),
                          color: Colors.grey.shade300),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: context.dp(133),
                    height: context.dp(180),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.primaryColor,
                    ),
                    child: Image.asset('assets/logo.png',
                        width: context.dp(90), fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(context.dp(14)),
                child: Hero(
                  tag: category.id.categoryTitle,
                  transitionOnUserGestures: true,
                  child: Text(
                    category.name,
                    maxLines: 2,
                    softWrap: true,
                    textScaleFactor: context.ts,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodyText1
                        ?.copyWith(color: context.onPrimary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
