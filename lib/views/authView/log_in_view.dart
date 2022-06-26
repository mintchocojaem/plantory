import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plantory/views/authView/sign_up_view.dart';
import 'package:unicons/unicons.dart';

import '../../utils/colors.dart';
import '../../utils/widgets.dart';
import '../home/home.dart';

class LogInView extends StatefulWidget {
  const LogInView({Key? key}) : super(key: key);

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    final spaceHeight = MediaQuery.of(context).size.height * 0.1;
    return Scaffold(
      backgroundColor: splashScreenTextColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ListView(
              children: [
                Column(
                  children: const [
                    CircleAvatar(
                        backgroundColor: primaryColor,
                        radius: 60,
                        child: Center(
                          child: CircleAvatar(
                            backgroundColor: splashScreenTextColor,
                            child: Center(
                                child: Icon(
                              UniconsLine.flower,
                              size: 55,
                              color: primaryColor,
                            )),
                            radius: 58,
                          ),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Plantory",
                      style: TextStyle(
                          color: primaryColor, fontSize: 25, letterSpacing: 6),
                    ),
                  ],
                ),
                SizedBox(
                  height: spaceHeight,
                ),
                authTextField(
                  prefixIcon: Icons.email,
                  labelText: "enter email",
                ),
                SizedBox(
                  height: spaceHeight,
                ),
                authTextField(
                    isVisible: isVisible,
                    labelText: "enter password",
                    obsecureIcon: isVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility,
                    onPressed: () {
                      setState(() {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      });
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "Forgot password",
                          style: TextStyle(color: primaryColor),
                        )),
                  ],
                ),
                SizedBox(
                  height: spaceHeight,
                ),
                reUsableButton(
                    text: "Sign In",
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const Home(),
                              type: PageTransitionType.rightToLeft));
                    }),
                SizedBox(
                  height: spaceHeight,
                ),
                Align(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: const SignUpView(),
                                type: PageTransitionType.rightToLeft));
                      },
                      child: const Text(
                        "Create accounts",
                        style: TextStyle(color: primaryColor),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
