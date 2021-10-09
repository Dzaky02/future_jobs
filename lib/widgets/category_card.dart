import 'package:flutter/material.dart';

import '../extension/screen_utils_extension.dart';
import '../models/category_model.dart';
import '../pages/category_page.dart';
import '../shared/theme.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;

  CategoryCard(this.category);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPage(category),
          ),
        );
      },
      child: Container(
        width: context.dp(133),
        height: context.dp(180),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                category.imageUrl,
                fit: BoxFit.cover,
                width: context.dp(133),
                height: context.dp(180),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: context.dp(133),
                    height: context.dp(180),
                    color: context.surface,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(context.dp(14)),
                child: Text(category.name, style: context.text.bodyText1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
