import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../../utils/colors.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCF7F4),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios,color:primaryColor ,)),
        elevation: 0.5,
        backgroundColor: const Color(0xffFCF7F4),
        title: const Text(
          "Notification,",
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => const NotificationBuilder(),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: 5,
      ),
    );
  }
}

class NotificationBuilder extends StatelessWidget {
  const NotificationBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 10,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: const CircleAvatar(
        radius: 30,
        child: Icon(UniconsLine.flower),
        backgroundColor: splashScreenTextColor,
      ),
      title: RichText(
          text: const TextSpan(
              text: "It's  ",
              style: TextStyle(color: Colors.black),
              children: [
            TextSpan(
                text: "Brasil ", style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: "Harvest time"),
          ])),
      subtitle: const Text("Today"),
    );
  }
}
