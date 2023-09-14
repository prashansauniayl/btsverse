import 'package:btsverse/ad_mob_service.dart';
import 'package:btsverse/providers/user_provider.dart';
import 'package:btsverse/utils/color.dart';
import 'package:btsverse/widgets/drawer.dart';
import 'package:btsverse/widgets/story_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({Key? key}) : super(key: key);

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  bool _isLoading = true;
  BannerAd? _banner;

  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  void initState() {
    super.initState();
    _createBannerAd();
    // Move the setState call to after the async call is complete
    addData().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  Future<void> _handleRefresh() async {
    return await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
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
            child: const Center(
              child: CircularProgressIndicator(
                color: purple,
              ), // Show circular progress indicator while loading
            ),
          )
        : Container(
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
              body: Column(
                children: [
                  Expanded(
                    // Wrap the ListView in an Expanded widget
                    child: LiquidPullToRefresh(
                      onRefresh: _handleRefresh,
                      color: purple,
                      height: 300,
                      backgroundColor: Colors.white,
                      child: Theme(
                        data: ThemeData(
                          colorScheme: ColorScheme.fromSwatch()
                              .copyWith(secondary: purple),
                        ),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('story')
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: purple,
                                ),
                              );
                            } else if (snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty) {
                              // Reverse the order of the snapshot data docs list
                              final reversedDocs =
                                  snapshot.data!.docs.reversed.toList();
                              return ListView.builder(
                                itemCount: reversedDocs.length,
                                itemBuilder: (ctx, index) => Container(
                                  margin: const EdgeInsets.symmetric(),
                                  child: StoryCard(
                                    snap: reversedDocs[index].data(),
                                  ),
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  'No story found',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }
                          },
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
