import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../utils/colors.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: splashScreenTextColor,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'images/user1.jpeg',
                      fit: BoxFit.fill,
                      width: 128,
                      height: 128,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("User"),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xffF8ECE0),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 5),
                        child: ListView(
                          children: [
                            profileSettingsCard(
                                title: "Accounts", icon: Icons.person),
                            profileSettingsCard(
                                title: "Notifications",
                                icon: Icons.notifications_none_outlined),
                            profileSettingsCard(
                                title: "Settings", icon: Icons.settings),
                            profileSettingsCard(
                                title: "Help and Suppport",
                                icon: Icons.support_agent_outlined),
                          ],
                        ),
                        decoration: const BoxDecoration(
                            color: homeBackgroundColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Card profileSettingsCard(
      {String? title, Function()? onPress, IconData? icon}) {
    return Card(
      elevation: 0,
      color: homeBackgroundColor,
      child: ListTile(
        onTap: onPress,
        title: Text(title!),
        leading: Icon(icon),
        trailing: Icon(Icons.arrow_forward_ios_rounded),
      ),
    );
  }
}

userEnagementI({String? title, IconData? icon}) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),

        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: BoxDecoration(
            color: Color(0xffC7BAA9), borderRadius: BorderRadius.circular(15)),
        // height: 60,
        child: Center(
          child: Icon(icon),
        ),
      ),
      Text(title!)
    ],
  );
}
