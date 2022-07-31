import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plantory/views/auth/auth_page.dart';
import '../../utils/colors.dart';
import '../../utils/widgets.dart';

class OnbordingSecondIntro extends StatelessWidget {
  const OnbordingSecondIntro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16);
    final textStyle1 = Theme.of(context).textTheme.bodyText1;

    return Scaffold(
      backgroundColor: splashScreenTextColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage("images/2.png"),
                  width: MediaQuery.of(context).size.width / 1.5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Maintain your plant easily",
                    style: textStyle1!.copyWith(fontSize: 25),
                  ),
                ),
                Text('Away from home? No problem! You can', style: textStyle),
                Text(
                  "check up your plants condition anywhere,",
                  style: textStyle,
                ),
                Text(
                  "anytime",
                  style: textStyle,
                ),
                const SizedBox(
                  height: 35,
                ),
                reUsableButton(
                    text: "Get Started",
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: AuthPage(),
                              type: PageTransitionType.rightToLeft));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
