import 'package:btsverse/ad_mob_service.dart';
import 'package:btsverse/intro_screen/register_screen.dart';
import 'package:btsverse/intro_screen/welcome_screen.dart';
import 'package:btsverse/utils/color.dart';
import 'package:btsverse/widgets/drawer.dart';
import 'package:btsverse/widgets/settings_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  BannerAd? _banner;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            secondaryColor,
            purple,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: _banner == null
            ? Container()
            : Container(
                margin: EdgeInsets.only(bottom: 12),
                height: 52,
                child: AdWidget(ad: _banner!),
              ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        drawer: const DrawerScreen(),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: SafeArea(
            child: Column(
              children: [
                SettingMenu(
                  icon: "icons/profile.png",
                  text: "Edit Account",
                  press: () {
                    Navigator.pushNamed(context, "edit_profile");
                  },
                ),
                SettingMenu(
                  icon: "icons/about.png",
                  text: "About Us",
                  press: () {
                    Navigator.pushNamed(context, "about_page");
                  },
                ),
                SettingMenu(
                  icon: "icons/contact.png",
                  text: "Contact",
                  press: () {
                    Navigator.pushNamed(context, "contact_page");
                  },
                ),
                SettingMenu(
                  icon: "icons/privacy.png",
                  text: "Privacy Policy",
                  press: () {
                    Navigator.pushNamed(context, "privacy_page");
                  },
                ),
                SettingMenu(
                  icon: "icons/verification.png",
                  text: "Verification Process",
                  press: () {
                    Navigator.pushNamed(context, "verification_page");
                  },
                ),
                SettingMenu(
                  icon: "icons/exit.png",
                  text: "Log out",
                  press: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType
                            .fade, // Set the type to PageTransitionType.slideLeft
                        duration: const Duration(
                            milliseconds: 200), // Set the duration of the animation
                        child:
                        const WelcomeScreen(), // Replace HomeScreen with your destination screen
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
