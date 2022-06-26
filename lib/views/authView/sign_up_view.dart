
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../utils/colors.dart';
import '../../utils/widgets.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool isVisible = false;
  bool isConfirmPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    final innerSpace = MediaQuery.of(context).size.height * 0.03;
    return Scaffold(
      backgroundColor: splashScreenTextColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: innerSpace,
                ),

                Column(
                  children: [
                    const CircleAvatar(
                        backgroundColor: primaryColor,
                        radius: 50,
                        child: Center(
                          child: CircleAvatar(
                            backgroundColor: splashScreenTextColor,
                            child: Center(
                                child: Icon(
                              UniconsLine.flower,
                              size: 40,
                              color: primaryColor,
                            )),
                            radius: 48,
                          ),
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Plantery",
                      style: TextStyle(
                          color: primaryColor, fontSize: 25, letterSpacing: 6),
                    ),
                    SizedBox(
                      height: innerSpace,
                    ),
                  ],
                ),
                authTextField(
                  labelText: "enter name",
                ),
                 SizedBox(
                  height: innerSpace,
                ),
                authTextField(
                  prefixIcon: Icons.email,
                  labelText: "enter email",
                ),
                 SizedBox(
                  height: innerSpace,
                ),

                authTextField(
                  prefixIcon: Icons.location_city,
                  labelText: "City",
                ),
                SizedBox(
                  height:innerSpace,
                ),

                authTextField(
                    isVisible: isVisible,
                    labelText: "enter password",
                    obsecureIcon: isVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility,
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    }),
                SizedBox(
                  height: innerSpace,
                ),

                authTextField(
                    isVisible: isConfirmPasswordVisible,
                    labelText: "Confirm password",
                    obsecureIcon: isConfirmPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility,
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    }),
                SizedBox(
                  height: innerSpace,
                ),

                reUsableButton(text: "Sign Up", onPressed: () {}),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "Already have an account? SigIn",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: primaryColor),
                    )),
                // Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
