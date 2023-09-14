// Import necessary packages
import 'dart:async';
import 'package:btsverse/ad_mob_service.dart';
import 'package:btsverse/providers/user_provider.dart';
import 'package:btsverse/utils/color.dart';
import 'package:btsverse/widgets/drawer.dart';
import 'package:btsverse/widgets/post_card.dart';
import 'package:btsverse/widgets/verysmall_button.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import cached_network_image package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  late ConnectivityResult result;
  late StreamSubscription subscription;
  bool isConnected = false;
  BannerAd? _banner;

  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  checkInternet() async {
    result = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = (result != ConnectivityResult.none);
      if (!isConnected) {
        showDialogBox(context);
      }
    });
  }

  showDialogBox(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          'NO INTERNET',
          style: TextStyle(
            color: purple,
            fontFamily: 'Sen',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Please check your internet connection',
          style: TextStyle(
            color: secondaryColor,
            fontFamily: 'Sen',
            fontSize: 14,
          ),
        ),
        actions: [
          VerySmallButton(
              text: 'R E T R Y',
              press: () {
                Navigator.pop(context);
                checkInternet();
              })
        ],
      ),
    );
  }

  startStreaming() {
    subscription = Connectivity().onConnectivityChanged.listen((event) {
      checkInternet();
    });
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
    startStreaming();
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
                        .collection('posts')
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
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (ctx, index) => Container(
                            margin: const EdgeInsets.symmetric(),
                            child: PostCard(
                              snap: snapshot.data!.docs[index].data(),
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text(
                            'No posts found',
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
