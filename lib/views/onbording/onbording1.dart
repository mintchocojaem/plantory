import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../utils/colors.dart';
import '../../utils/widgets.dart';
import 'onbording2.dart';

class OnbordingIntro extends StatelessWidget {
  const OnbordingIntro({Key? key}) : super(key: key);

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
                  image: const AssetImage("images/1.png"),
                  width: MediaQuery.of(context).size.width / 1.5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Stay Connected",
                    style: textStyle1!.copyWith(fontSize: 25),
                  ),
                ),
                Text('Nothing can keep you apart from loving',
                    style: textStyle),
                Text(
                  " your plants! Stay connected with your plant",
                  style: textStyle,
                ),
                Text(
                  "  amid your busy life",
                  style: textStyle,
                ),
                const SizedBox(
                  height: 35,
                ),
                reUsableButton(
                  text: "Next",
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: OnbordingSecondIntro(),
                            type: PageTransitionType.rightToLeft)
                            );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
