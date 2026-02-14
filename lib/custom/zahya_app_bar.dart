import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/filter.dart';
import 'package:active_ecommerce_cms_demo_app/custom/home_search_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ZahyaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final HomePresenter homeData;
  final bool showBackButton;

  const ZahyaAppBar({
    super.key,
    required this.homeData,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xffB9C348), // First color
      scrolledUnderElevation: 0.0,
      centerTitle: false,
      elevation: 0,
      flexibleSpace: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 5),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 18, 5),
            child: Row(
              children: [
                if (showBackButton)
                  IconButton(
                    icon: const Icon(CupertinoIcons.arrow_left,
                        color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Image.asset(
                    "assets/splash_screen_logo.png",
                    height: 35,
                    color: Colors.white,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Filter()));
                    },
                    child: HomeSearchBox(context: context),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            width: double.infinity,
            color: const Color(0xff7A9A2D), // Second color
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: Colors.white, size: 16),
                const SizedBox(width: 8),
                ListenableBuilder(
                  listenable: homeData,
                  builder: (context, child) {
                    return Text(
                      homeData.currentLocationText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_down,
                    color: Colors.white, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(110);
}
