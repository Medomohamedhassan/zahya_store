import 'package:active_ecommerce_cms_demo_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/main_helpers.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/category_list_n_product/category_products.dart';
import 'package:flutter/material.dart';
import '../my_theme.dart';

class FeaturedCategoriesWidget extends StatelessWidget {
  final HomePresenter homeData;
  const FeaturedCategoriesWidget({super.key, required this.homeData});

  @override
  Widget build(BuildContext context) {
    if (homeData.isCategoryInitial && homeData.featuredCategoryList.isEmpty) {
      return ShimmerHelper().buildHorizontalGridShimmerWithAxisCount(
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          item_count: 10,
          mainAxisExtent: 170.0,
          controller: homeData.featuredCategoryScrollController);
    } else if (homeData.featuredCategoryList.isNotEmpty) {
      return GridView.builder(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 11, bottom: 24),
        scrollDirection: Axis.horizontal,
        controller: homeData.featuredCategoryScrollController,
        itemCount: homeData.featuredCategoryList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 12,
            mainAxisExtent: 120.0),
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CategoryProducts(
                        slug: homeData.featuredCategoryList[index].slug,
                      );
                    },
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder.png',
                        image: validateImageUrl(
                            homeData.featuredCategoryList[index].coverImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  Flexible(
                    child: Text(
                      homeData.featuredCategoryList[index].name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: MyTheme.dark_font_grey,
                      ),
                    ),
                  ),
                ],
              ));
        },
      );
    } else if (!homeData.isCategoryInitial &&
        homeData.featuredCategoryList.isEmpty) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(
            "No category found",
            style: TextStyle(color: MyTheme.font_grey),
          ),
        ),
      );
    } else {
      return Container(
        height: 100,
      );
    }
  }
}
