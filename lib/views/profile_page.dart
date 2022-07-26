import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../utils/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEF1F1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0xffEEF1F1),
        title: const Text(
          "Profile",
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: SafeArea(
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
      elevation: 1,
      child: ListTile(
        onTap: onPress,
        title: Text(title!),
        leading: Icon(icon),
        trailing: Icon(Icons.arrow_forward_ios_rounded),
      ),
    );
  }

}
