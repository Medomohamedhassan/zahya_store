import 'package:active_ecommerce_cms_demo_app/custom/useful_elements.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/category_response.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/category_repository.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/product_repository.dart';
import 'package:active_ecommerce_cms_demo_app/ui_elements/product_card.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:active_ecommerce_cms_demo_app/custom/zahya_app_bar.dart';
import 'package:active_ecommerce_cms_demo_app/l10n/app_localizations.dart';

class CategoryProducts extends StatefulWidget {
  const CategoryProducts({super.key, required this.slug});
  final String slug;

  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _xcrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final HomePresenter homeData = HomePresenter();

  int _page = 1;
  int? _totalData = 0;
  bool _isInitial = true;
  String _searchKey = "";
  Category? categoryInfo;
  bool _showSearchBar = false;
  final List<dynamic> _productList = [];
  bool _showLoadingContainer = false;
  final List<Category> _subCategoryList = [];

  getSubCategory() async {
    var res = await CategoryRepository().getCategories(parent_id: widget.slug);
    if (res.categories != null) {
      _subCategoryList.addAll(res.categories!);
    }
    setState(() {});
  }

  getCategoryInfo() async {
    var res = await CategoryRepository().getCategoryInfo(widget.slug);
    if (res.categories?.isNotEmpty ?? false) {
      categoryInfo = res.categories?.first;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCategoryInfo();
    fetchAllDate();

    _xcrollController.addListener(() {
      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _xcrollController.dispose();
    super.dispose();
  }

  fetchData() async {
    var productResponse = await ProductRepository().getCategoryProducts(
      id: widget.slug,
      page: _page,
      name: _searchKey,
    );
    _productList.addAll(productResponse.products!);
    _isInitial = false;
    _totalData = productResponse.meta!.total;
    _showLoadingContainer = false;
    setState(() {});
  }

  fetchAllDate() {
    fetchData();
    getSubCategory();
  }

  reset() {
    _subCategoryList.clear();
    _productList.clear();
    _isInitial = true;
    _totalData = 0;
    _page = 1;
    _showLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAllDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ZahyaAppBar(homeData: homeData, showBackButton: true),
      body: Stack(
        children: [
          buildProductList(),
          Align(
            alignment: Alignment.bottomCenter,
            child: buildLoadingContainer(),
          ),
        ],
      ),
    );
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(
          _totalData == _productList.length
              ? AppLocalizations.of(context)!.no_more_products_ucf
              : AppLocalizations.of(context)!.loading_more_products_ucf,
        ),
      ),
    );
  }

  ListView buildSubCategory() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        Color containerColor;
        if (index == 0) {
          containerColor = MyTheme.mainColor;
        } else if (index == 1) {
          containerColor = const Color(0xffFF5500);
        } else {
          containerColor = const Color(0xffF2F4F7);
        }

        Color textColor;
        if (index == 0 || index == 1) {
          textColor = Colors.white;
        } else {
          textColor = MyTheme.dark_font_grey;
        }

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return CategoryProducts(slug: _subCategoryList[index].slug!);
                },
              ),
            );
          },
          child: Container(
            height: _subCategoryList.isEmpty ? 0 : 30,
            width: _subCategoryList.isEmpty ? 0 : 99,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              _subCategoryList[index].name!,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(width: 10);
      },
      itemCount: _subCategoryList.length,
    );
  }

  buildProductList() {
    if (_isInitial && _productList.isEmpty) {
      return SingleChildScrollView(
        child: ShimmerHelper().buildProductGridShimmer(
          scontroller: _scrollController,
        ),
      );
    } else if (_productList.isNotEmpty) {
      return RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        displacement: 0,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _xcrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: AnimatedContainer(
                color: Colors.white,
                height: _subCategoryList.isEmpty ? 0 : 50,
                duration: const Duration(milliseconds: 500),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: buildSubCategory(),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(18),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.60,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ProductCard(
                      id: _productList[index].id,
                      slug: _productList[index].slug,
                      image: _productList[index].thumbnail_image,
                      name: _productList[index].name,
                      main_price: _productList[index].main_price,
                      stroked_price: _productList[index].stroked_price,
                      discount: _productList[index].discount,
                      is_wholesale: _productList[index].isWholesale,
                      has_discount: _productList[index].has_discount,
                    );
                  },
                  childCount: _productList.length,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (_totalData == 0) {
      return Center(
        child: Text(AppLocalizations.of(context)!.no_data_is_available),
      );
    } else {
      return Container();
    }
  }
}
