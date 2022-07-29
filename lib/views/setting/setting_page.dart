import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SettingPage();
  }
}

class _SettingPage extends State<SettingPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEF1F1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Color(0xffEEF1F1),
        title: const Text(
          "Settings",
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
                            Divider(thickness: 1,),
                            ListTile(
                              title: Text("Accounts"),
                              leading: Icon(Icons.person),
                              trailing: Icon(Icons.arrow_forward_ios_rounded),
                            ),
                            Divider(thickness: 1,),
                            ListTile(
                              title: Text("Notifications"),
                              leading: Icon(Icons.notifications_none_outlined),
                              trailing: Icon(Icons.arrow_forward_ios_rounded),
                            ),
                            Divider(thickness: 1,),
                            ListTile(
                              title: Text("Help and Suppport"),
                              leading: Icon(Icons.support_agent_outlined),
                              trailing: Icon(Icons.arrow_forward_ios_rounded),
                            ),
                            Divider(thickness: 1,),

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

}
