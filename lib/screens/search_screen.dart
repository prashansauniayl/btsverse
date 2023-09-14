// ignore_for_file: unnecessary_cast
import 'package:btsverse/ad_mob_service.dart';
import 'package:btsverse/screens/profile_screen.dart';
import 'package:btsverse/utils/color.dart';
import 'package:btsverse/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      secondaryColor.withOpacity(0.7),
                      purple.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                child: Row(
                  children: [
                    const Image(
                      image: AssetImage('icons/search.png'),
                      width: 18,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'pal'),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (String value) {
                          setState(() {
                            isShowUsers = true;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: isShowUsers
                  ? FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .where('username',
                              isGreaterThanOrEqualTo: searchController.text)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: purple,
                            ),
                          );
                        }
                        return Theme(
                          data: ThemeData(
                            colorScheme: ColorScheme.fromSwatch()
                                .copyWith(secondary: purple),
                          ),
                          child: ListView.builder(
                            itemCount:
                                (snapshot.data! as QuerySnapshot).docs.length,
                            itemBuilder: (context, index) {
                              var user =
                                  (snapshot.data! as QuerySnapshot).docs[index];
                              bool isVerified =
                                  user['followers']?.length >= 100 &&
                                      user['following']?.length >= 0;
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                          uid: user
                                              .id), // Pass the userId to the ProfileScreen
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: purple,
                                    backgroundImage:
                                        NetworkImage(user['photoUrl']),
                                    radius: 16,
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        user['username'],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Sen'),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      if (isVerified)
                                        const Icon(
                                          Icons.verified,
                                          size: 16,
                                          color: Colors.blue,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    )
                  : const SizedBox(), // Show empty container if not showing users
            ),
          ],
        ),
      ),
    );
  }
}
