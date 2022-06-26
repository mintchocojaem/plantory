import 'dart:async';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:unicons/unicons.dart';

import '../../utils/colors.dart';
import 'onbording1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {

    Timer(
        const Duration(seconds: 4),
        () => Navigator.pushReplacement(
            context,
            PageTransition(
                child: const OnbordingIntro(),
                type: PageTransitionType.rightToLeft)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
          child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
           const DelayedDisplay(
            // slidingCurve: Curves.,
            slidingBeginOffset: Offset(0.90, 0.0),
            delay: Duration(seconds: 1),
            child: CircleAvatar(
                backgroundColor: splashScreenTextColor,
                radius: 80,
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: primaryColor,
                    child: Center(
                        child: Icon(
                      UniconsLine.flower,
                      size: 55,
                      color: splashScreenTextColor,
                    )),
                    radius: 77,
                  ),
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          const DelayedDisplay(
             slidingBeginOffset: Offset(-0.90, 0.0),
            delay: Duration(seconds: 2),
            child: Text(
              "Plantery",
              style: TextStyle(
                  color: splashScreenTextColor, fontSize: 25, letterSpacing: 6),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
          ),
        ]),
      )),
    );
  }
}
