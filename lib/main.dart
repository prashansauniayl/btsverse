// ignore_for_file: no_leading_underscores_for_local_identifiers, library_private_types_in_public_api
import 'package:btsverse/group_chat/army_hangout.dart';
import 'package:btsverse/group_chat/buddies.dart';
import 'package:btsverse/group_chat/hallyu.dart';
import 'package:btsverse/group_chat/kpop.dart';
import 'package:btsverse/group_chat/micdrop.dart';
import 'package:btsverse/group_chat/purple.dart';
import 'package:btsverse/intro_screen/register_screen.dart';
import 'package:btsverse/intro_screen/welcome_screen.dart';
import 'package:btsverse/providers/user_provider.dart';
import 'package:btsverse/screens/home_screen.dart';
import 'package:btsverse/screens/imagepost_screen.dart';
import 'package:btsverse/screens/post_screen.dart';
import 'package:btsverse/screens/profile_screen.dart';
import 'package:btsverse/screens/search_screen.dart';
import 'package:btsverse/screens/story_screen.dart';
import 'package:btsverse/screens/storypost_screen.dart';
import 'package:btsverse/screens/users_screen.dart';
import 'package:btsverse/utils/color.dart';
import 'package:btsverse/widgets/about_page.dart';
import 'package:btsverse/widgets/contact_page.dart';
import 'package:btsverse/widgets/edit_profile.dart';
import 'package:btsverse/widgets/privacy_page.dart';
import 'package:btsverse/widgets/verification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'intro_screen/login_screen.dart';
import 'package:btsverse/screens/group_chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:btsverse/screens/settings_screen.dart';

void main() async {
  var devices = ["6C8C90A48F658A8CE4D9825B621B7FDA"];
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp();
  
  RequestConfiguration requestConfiguration = RequestConfiguration(testDeviceIds: devices);
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  // Create an instance of UserProvider
  UserProvider _userProvider = UserProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _userProvider),
      ],
      child: const BTSverse(),
    ),
  );
}

class BTSverse extends StatefulWidget {
  const BTSverse({Key? key}) : super(key: key);

  @override
  _BTSverseState createState() => _BTSverseState();
}


class _BTSverseState extends State<BTSverse> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && snapshot.data != null) {
              return const HomeScreen();
            } else {
              return const WelcomeScreen();
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: purple,
              ),
            );
          }
        },
      ),
      routes: {
        "home_screen": (context) => const HomeScreen(),
        "search_screen": (context) => const SearchScreen(),
        "group_chat_screen": (context) => const GroupChatScreen(),
        "login_screen": (context) => LoginScreen(),
        "register_screen": (context) => const RegisterScreen(),
        "profile_screen": (context) =>
            ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
        "settings_screen": (context) => const SettingsScreen(),
        "post_screen": (context) => const PostScreen(),
        "army_hangout": (context) => const ArmyHangout(),
        "buddies": (context) => const BangtanBuddies(),
        "kpop": (context) => const KpopKrazies(),
        "purple": (context) => const PurpleChat(),
        "micdrop": (context) => const MicDrop(),
        "hallyu": (context) => const Hallyu(),
        "uses_screen": (context) => const UsersScreen(),
        "story_screen": (context) => const StoryScreen(),
        "imagepost_screen": (context) => const ImagePostScreen(),
        "storypost_screen": (context) => const StoryPostScreen(),
        "edit_profile": (context) => const EditAccount(),
        "about_page": (context) => const AboutPage(),
        "contact_page": (context) => const ContactPage(),
        "privacy_page": (context) => const PrivacyPage(),
        "verification_page": (context) => const VerificationPage(),
      },
      initialRoute: "welcome_screen",
    );
  }
}
