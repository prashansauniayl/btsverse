import 'package:btsverse/utils/color.dart';
import 'package:btsverse/widgets/drawer.dart';
import 'package:flutter/material.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        drawer: const DrawerScreen(),
        body: Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(secondary: purple),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  children: const [
                    Text(
                      'PRIVACY POLICY OF BTSverse',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Sen', fontSize: 22),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      '''
We take the privacy of our users very seriously. This Privacy Policy outlines how we collect, use, and share information about our users. By using our app, you agree to the terms of this Privacy Policy.

Information We Collect:
We collect information that you provide to us when you create an account on our app, such as your name, email address, and profile picture. We may also collect information about your usage of the app, including the posts you view and interact with, and your device information.

How We Use Your Information:
We use your information to personalize your experience on our app, to provide you with relevant content, and to improve our services. We may also use your information to contact you regarding updates and promotions.

Sharing Your Information:
We do not share your personal information with third parties, except as required by law or as necessary to provide our services.

User Guidelines:

We want to provide a safe and enjoyable experience for all of our users. To ensure that our app is a positive space, we ask that all users follow these guidelines:

Respect Others: Do not use our app to harass, bully, or intimidate others. Any form of hate speech or discriminatory behavior will not be tolerated.

Appropriate Content: Users may not post or share any inappropriate or explicit content on our app. This includes but is not limited to nudity, graphic violence, or hate speech.

No Spamming: Users may not use our app to send spam or unwanted messages to other users.

Not Interested Option: Users can use the "not interested" option to remove posts or stories that they do not want to see. They can also report any inappropriate content to our team.

Contact Us: If users have any thoughts or feedback about the app, they can contact us through the "contact us" option.

Consequences for Misbehavior: Any user who violates our guidelines may be removed or suspended from the app. If any content receives 10 or more reports, we will take strict action to remove it. Our team will review any reported content to determine if it violates our policies.

We hope that these guidelines will help create a positive and respectful community within our app. Users who violate these guidelines may face consequences, including removal from the app. We reserve the right to update these guidelines as necessary to ensure the safety and enjoyment of our users.

If you have any questions or concerns about our privacy policy or user guidelines, please contact us through the "contact us" option within the app.
                    
                    
                    ''',
                      style: TextStyle(color: Colors.white, fontFamily: 'Sen'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
