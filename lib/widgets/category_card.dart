import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_jobs/models/category_model.dart';
import 'package:future_jobs/pages/category_page.dart';
import 'package:future_jobs/size_config.dart';

import '../theme.dart';

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
        width: SizeConfig.scaleWidth(150),
        height: SizeConfig.scaleHeight(200),
        margin: EdgeInsets.only(
          right: SizeConfig.scaleWidth(16),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            SizeConfig.scaleWidth(16),
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                SizeConfig.scaleWidth(16),
              ),
              child: Image.network(
                category.imageUrl,
                fit: BoxFit.cover,
                width: SizeConfig.scaleWidth(150),
                height: SizeConfig.scaleHeight(200),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                      child: Padding(
                    padding: EdgeInsets.all(
                      SizeConfig.scaleWidth(16),
                    ),
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  ));
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(
                  SizeConfig.scaleWidth(16),
                ),
                child: Text(
                  category.name,
                  style: whiteTextStyle.copyWith(
                    fontSize: SizeConfig.scaleText(18),
                    fontWeight: medium,
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
