import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/custom/device_info.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: splashScreen());
  }

  Widget splashScreen() {
    return Container(
      width: DeviceInfo(context).width,
      height: DeviceInfo(context).height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/splash_full.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: InkWell(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 51.0),
                  child: Text(
                    AppConfig.copyright_text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.0,
                      color: Colors.white,
                    ),
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
