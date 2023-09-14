import 'package:btsverse/utils/color.dart';
import 'package:btsverse/widgets/drawer.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
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
                      'Process Of Verification',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Sen', fontSize: 22),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      '''
At BTSVerse, we have established a verification process that serves as a meaningful recognition and reward system for devoted BTS enthusiasts. Our primary objective is to provide a platform where fans can proudly showcase their profound love and commitment to the global sensation that is BTS. In order to ensure that the verification experience remains accessible and inclusive, we have deliberately avoided intricate paperwork and complex procedures.

Our verification process is refreshingly straightforward yet significant. Fans can attain verification status by amassing a minimum of 100 followers. This milestone is a testament to an individual's genuine dedication and active participation within the BTSVerse community. It signifies their strong connection with fellow fans and their continuous efforts to share their passion and enthusiasm.

The verification badge acts as a prestigious symbol, prominently displayed on the user's profile. It not only acknowledges their deep affection for BTS but also recognizes their valuable contributions to the community. Verified members play a pivotal role in cultivating the vibrant and thriving nature of the fandom, enhancing the overall experience for all participants.

BTSVerse verification is both a reward and an opportunity for fans to showcase their unwavering support for BTS to the wider world. We strive to instill a sense of pride and accomplishment among verified members, reinforcing their commitment and fueling their passion. This distinction sets them apart, affirming their status as genuine BTS lovers who have invested their time and energy into supporting the group and embracing their artistic endeavors.

Furthermore, our verification approach prioritizes inclusivity. We firmly believe that being a BTS fan transcends age, gender, and background. Any individual with 100 followers and a genuine affection for BTS can join the ranks of the verified. Our objective is to cultivate a welcoming and diverse community, embracing fans from all walks of life who are united by their shared admiration for BTS's music, performances, and messages.

In essence, the verification process at BTSVerse recognizes and appreciates the unwavering dedication and contributions of BTS fans. By reaching a follower count of 100, individuals not only receive the honor of verification but also gain a platform to proudly display their love for BTS to the world. Through this approach, we promote inclusivity, accessibility, and a sense of belonging within the vibrant BTSVerse community. As we continue to grow, we are dedicated to providing an environment where fans can celebrate their shared passion for BTS, inspiring one another through their mutual adoration for the group's artistry and profound messages.

                    
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
