import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_cms_demo_app/l10n/app_localizations.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/filter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/product/todays_deal_products.dart';
import 'package:active_ecommerce_cms_demo_app/screens/top_sellers.dart';
import 'package:flutter/material.dart';
import '../custom/feature_categories_widget.dart';
import '../custom/featured_product_horizontal_list_widget.dart';
import '../custom/home_all_products_2.dart';
import '../custom/home_banner_one.dart';
import '../custom/home_carousel_slider.dart';
import '../custom/pirated_widget.dart';
import '../ui_elements/product_card.dart';

class Home extends StatefulWidget {
  final String? title;
  final bool show_back_button;
  final bool go_back;
  final HomePresenter? homePresenter;

  const Home({
    super.key,
    this.title,
    this.show_back_button = false,
    this.go_back = true,
    this.homePresenter,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late HomePresenter homeData;

  @override
  void initState() {
    homeData = widget.homePresenter ?? HomePresenter();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
      precacheImage(const AssetImage("assets/todays_deal.png"), context);
      precacheImage(const AssetImage("assets/brands.png"), context);
      precacheImage(const AssetImage("assets/top_sellers.png"), context);
    });
    homeData.mainScrollListener();
    homeData.initPiratedAnimation(this);
  }

  Future<void> _fetchData() {
    return homeData.onRefresh();
  }

  @override
  void dispose() {
    // homeData.pirated_logo_controller.dispose(); // This might cause issues if shared
    // homeData.mainScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.go_back,
      child: Directionality(
        textDirection:
            app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                RefreshIndicator(
                  color: MyTheme.accent_color,
                  backgroundColor: Colors.white,
                  onRefresh: _fetchData,
                  displacement: 0,
                  child: CustomScrollView(
                    controller: homeData.mainScrollController,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: <Widget>[
                      _buildHeaderSection(context, homeData),
                      ListenableBuilder(
                        listenable: homeData,
                        builder: (context, child) =>
                            _buildFeaturedCategoriesSection(context, homeData),
                      ),
                      ListenableBuilder(
                        listenable: homeData,
                        builder: (context, child) {
                          return _buildRandomProductsSection(context, homeData);
                        },
                      ),
                      const SliverList(
                        delegate:
                            SliverChildListDelegate.fixed([PhotoWidget()]),
                      ),
                      ListenableBuilder(
                        listenable: homeData,
                        builder: (context, child) =>
                            _buildFeaturedProductsSection(context, homeData),
                      ),
                      ListenableBuilder(
                        listenable: homeData,
                        builder: (context, child) =>
                            _buildAllProductsSection(context, homeData),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ListenableBuilder(
                    listenable: homeData,
                    builder: (context, child) =>
                        _buildProductLoadingContainer(context, homeData),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverList _buildHeaderSection(BuildContext context, HomePresenter homeData) {
    return SliverList(
      delegate: SliverChildListDelegate([
        if (AppConfig.purchase_code == "") PiratedWidget(homeData: homeData),
        const SizedBox(height: 2),
        const SizedBox(height: 8),
        ListenableBuilder(
          listenable: homeData,
          builder: (context, child) =>
              HomeCarouselSlider(homeData: homeData, context: context),
        ),
        const SizedBox(height: 16),
        ListenableBuilder(
          listenable: homeData,
          builder: (context, child) => _HomeMenu(homeData: homeData),
        ),
        const SizedBox(height: 16),
        ListenableBuilder(
          listenable: homeData,
          builder: (context, child) =>
              HomeBannerOne(context: context, homeData: homeData),
        ),
      ]),
    );
  }

  SliverToBoxAdapter _buildFeaturedCategoriesSection(
      BuildContext context, HomePresenter homeData) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 18.0, 0.0),
            child: Text(
              AppLocalizations.of(context)!.featured_categories_ucf,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 280,
            child: FeaturedCategoriesWidget(homeData: homeData),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildRandomProductsSection(
      BuildContext context, HomePresenter homeData) {
    if (homeData.isRandomProductInitial && homeData.randomProductList.isEmpty) {
      return SliverToBoxAdapter(
        child: ShimmerHelper().buildProductGridShimmer(),
      );
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 16.0, 0.0, 0.0),
            child: Text(
              AppLocalizations.of(context)!.random_products_ucf,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            itemCount: homeData.randomProductList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.60,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ProductCard(
                id: homeData.randomProductList[index].id,
                slug: homeData.randomProductList[index].slug!,
                image: homeData.randomProductList[index].thumbnail_image,
                name: homeData.randomProductList[index].name,
                main_price: homeData.randomProductList[index].main_price,
                stroked_price: homeData.randomProductList[index].stroked_price,
                has_discount: homeData.randomProductList[index].has_discount!,
                discount: homeData.randomProductList[index].discount,
                is_wholesale: homeData.randomProductList[index].isWholesale,
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  SliverList _buildFeaturedProductsSection(
      BuildContext context, HomePresenter homeData) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          height: 305,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 0, 0),
                child: Text(
                  AppLocalizations.of(context)!.featured_products_ucf,
                  style: const TextStyle(
                    color: Color(0xff000000),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FeaturedProductHorizontalListWidget(homeData: homeData)
            ],
          ),
        ),
      ]),
    );
  }

  SliverList _buildAllProductsSection(
      BuildContext context, HomePresenter homeData) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 16.0, 0.0, 0.0),
          child: Text(
            AppLocalizations.of(context)!.all_products_ucf,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        HomeAllProducts2(homeData: homeData),
        const SizedBox(height: 80),
      ]),
    );
  }

  Widget _buildProductLoadingContainer(
      BuildContext context, HomePresenter homeData) {
    return homeData.showAllLoadingContainer
        ? Container(
            height: 36,
            width: 36,
            color: MyTheme.soft_accent_color,
            child: const CircularProgressIndicator(),
          )
        : Container();
  }
}

class _HomeMenu extends StatelessWidget {
  final HomePresenter homeData;

  const _HomeMenu({required this.homeData});

  @override
  Widget build(BuildContext context) {
    if (!homeData.isFlashDeal && !homeData.isTodayDeal) {
      return SizedBox(
        height: 40,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ShimmerHelper().buildHorizontalGridShimmerWithAxisCount(
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            item_count: 4,
            mainAxisExtent: 40.0,
          ),
        ),
      );
    }

    final List<Map<String, dynamic>> menuItems = _getMenuItems(context);

    return SizedBox(
      height: 40,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        scrollDirection: Axis.horizontal,
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          final Color containerColor = _getContainerColor(index);
          final Color contentColor =
              (containerColor == MyTheme.soft_accent_color)
                  ? MyTheme.dark_font_grey
                  : Colors.white;

          return GestureDetector(
            onTap: item['onTap'],
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              width: 106,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: containerColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    item['image'],
                    color: contentColor,
                    height: 16,
                    width: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: contentColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getContainerColor(int index) {
    if (index == 0 && homeData.isTodayDeal) {
      return MyTheme.mainColor;
    } else if (index == 1 || (index == 0 && !homeData.isTodayDeal)) {
      return MyTheme.secondary_brand_color;
    } else {
      return MyTheme.soft_accent_color;
    }
  }

  List<Map<String, dynamic>> _getMenuItems(BuildContext context) {
    return [
      if (homeData.isTodayDeal)
        {
          "title": AppLocalizations.of(context)!.todays_deal_ucf,
          "image": "assets/todays_deal.png",
          "onTap": () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TodaysDealProducts())),
          "textColor": Colors.white,
        },
      {
        "title": AppLocalizations.of(context)!.brands_ucf,
        "image": "assets/brands.png",
        "onTap": () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Filter(selected_filter: "brands"))),
        "textColor": const Color(0xff263140),
      },
      if (vendor_system.$)
        {
          "title": AppLocalizations.of(context)!.top_sellers_ucf,
          "image": "assets/top_sellers.png",
          "onTap": () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TopSellers())),
          "textColor": const Color(0xff222324),
        },
    ];
  }
}

class PhotoWidget extends StatelessWidget {
  const PhotoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Image.asset("assets/banner2.png"),
    );
  }
}
