import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import 'my_plant_view.dart';

class PlantDetailPage extends StatelessWidget {
  const PlantDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCF7F4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffFCF7F4),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black45,
            )),
        title: const Text(
          "Plants name",
          style: TextStyle(color: Colors.black45),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 10,
                bottom: MediaQuery.of(context).size.height / 15,
              ),
              child: CircleAvatar(
                child: const Icon(UniconsLine.flower),
                backgroundColor: const Color(0xffF8ECE0),
                radius: MediaQuery.of(context).size.height / 7,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
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
                        // height: 100,
                        child: Row(
                          children: [
                            Expanded(
                                child: plantAgeProperties(age: "2 months")),
                            const VerticalDivider(
                              // width: 10,
                              thickness: 1,
                              color: Color(0xffFCF7F4),
                            ),
                            Expanded(
                                child: plantLocationProperties(
                                    plantLocation: "Accra"))
                          ],
                        ),
                      ),
                    ),
                    divider(),
                    detailCard(
                        title: "Plant Condition",
                        icon: EvaIcons.clockOutline,
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => PlantConditionDetails());
                        }),
                    divider(),
                    detailCard(title: "Analysis", icon: UniconsLine.analysis),
                    divider(),
                    detailCard(
                        title: "Know Your Plant", icon: UniconsLine.trees),
                    Container(height: 5)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Divider divider() {
    return const Divider(
      thickness: 1,
      color: Color(0xffFCF7F4),
    );
  }
}

ListTile detailCard({String? title, IconData? icon, Function()? onTap}) {
  return ListTile(
    onTap: onTap,
    minVerticalPadding: 0.1,
    contentPadding: EdgeInsets.zero,
    title: Text(title!),
    leading: CircleAvatar(
      child: Center(
        child: Icon(
          icon,
          color: Color(0xffEAE3DA),
        ),
      ),
      radius: 20,
      backgroundColor: Color(0xffFCF7F4),
    ),
  );
}

class PlantConditionDetails extends StatelessWidget {
  const PlantConditionDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              plantCondtionCard(
                  label: "Water",
                  labelLevel: "7.7cm",
                  icon: EvaIcons.droplet),
              plantCondtionCard(
                  label: "Nutrients",
                  labelLevel: "2.2%",
                  icon: EvaIcons.briefcase),
            ],
          ),
          Row(
            children: [
              plantCondtionCard(
                  label: "Lighting",
                  labelLevel: "7.7cm",
                  icon: EvaIcons.droplet),
              plantCondtionCard(
                  label: "ph", labelLevel: "2.2%", icon: EvaIcons.droplet),
            ],
          ),
          Row(
            children: [
              plantCondtionCard(
                  label: "Water",
                  labelLevel: "7.7cm",
                  icon: EvaIcons.droplet),
              plantCondtionCard(
                  label: "Nutrients",
                  labelLevel: "2.2%",
                  icon: EvaIcons.droplet),
            ],
          ),
          Row(
            children: [
              plantCondtionCard(
                  label: "Oxygen",
                  labelLevel: "7.7cm",
                  icon: EvaIcons.droplet),
              plantCondtionCard(
                  label: "Temperature",
                  labelLevel: "2.2%",
                  icon: EvaIcons.droplet),
            ],
          ),
        ],
      ),
    ));
  }
}

plantCondtionCard({String? label, String? labelLevel, IconData? icon}) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xffC7BAA9),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 30,
            child: Icon(icon),
            backgroundColor: const Color(0xffFCF7F4),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(label!),
          ),
          Text(labelLevel!),
        ],
      ),
    ),
  );
}
