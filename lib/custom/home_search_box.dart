import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_cms_demo_app/l10n/app_localizations.dart';

class HomeSearchBox extends StatelessWidget {
  final BuildContext? context;
  const HomeSearchBox({super.key, this.context});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/search.png',
              height: 18,
              color: Color(0xff7B7980),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                AppConfig.search_bar_text,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xff7B7980),
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
