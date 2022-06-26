import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../utils/colors.dart';
import '../../utils/widgets.dart';

class MyPlantView extends StatelessWidget {
  const MyPlantView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCF7F4),
      appBar: AppBar(
        leading: const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.arrow_back_ios,
              color: primaryColor,
            )),
        elevation: 0.0,
        backgroundColor: const Color(0xffFCF7F4),
        title: const Text(
          "My Plants",
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: Column(
        children: [
          searcTextField(labelText: "Search", prefixIcon: Icons.search),
          Expanded(
              child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  itemCount: 5,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: MediaQuery.of(context).size.height / 2.8,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      // mainAxisExtent: 100,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) => MyPlantBuilder()))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: Color(0xffC7BAA9),
      child: Icon(UniconsLine.trees,size: 40, color: Color(0xffEAE3DA),),),
    );
  }
}

class MyPlantBuilder extends StatelessWidget {
  const MyPlantBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            radius: 40,
          ),
          Text("Plant Name"),
          plantAgeProperties(age: "7 months old"),
          plantLocationProperties(plantLocation: "Tamale")
        ],
      ),
      decoration: BoxDecoration(
          color: const Color(0xffE5E6E0),
          borderRadius: BorderRadius.circular(15)),
    );
  }
}

ListTile plantAgeProperties({
  String? age,
}) {
  return ListTile(
    minVerticalPadding: 0.1,
    contentPadding: EdgeInsets.zero,
    title: Text("AGE"),
    subtitle: Text(age!),
    leading: const CircleAvatar(
      radius: 20,
      child: Center(
        child: Icon(
          UniconsLine.globe,
          color: Color(0xffEAE3DA),
        ),
      ),
      backgroundColor: Color(0xffFCF7F4),
    ),
  );
}

ListTile plantLocationProperties({
  String? plantLocation,
}) {
  return ListTile(
    minVerticalPadding: 0.1,
    contentPadding: EdgeInsets.zero,
    title: Text("Location"),
    subtitle: Text(plantLocation!),
    leading: const CircleAvatar(
      child: Center(
        child: Icon(
          UniconsLine.location_pin_alt,
          color: Color(0xffEAE3DA),
        ),
      ),
      radius: 20,
      backgroundColor: Color(0xffFCF7F4),
    ),
  );
}
