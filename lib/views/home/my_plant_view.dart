import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../utils/colors.dart';
import '../../utils/widgets.dart';

class MyPlantView extends StatelessWidget {
  const MyPlantView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homeBackgroundColor,
      appBar: AppBar(
        leading: const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.arrow_back_ios,
              color: primaryColor,
            )),
        elevation: 0.0,
        backgroundColor: homeBackgroundColor,
        title: const Text(
          "Plants",
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: Column(
        children: [
          searcTextField(labelText: "Search", prefixIcon: Icons.search),
          Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  itemCount: 4,
                  itemBuilder: (context, index) => MyPlantBuilder(imgPath: 'images/plant${index+1}.jpeg',)))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add,size: 40,),),
    );
  }
}

class MyPlantBuilder extends StatelessWidget {
  MyPlantBuilder({Key? key, this.imgPath}) : super(key: key);
  String? imgPath;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
            color: const Color(0xffE5E6E0),
            borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          leading:  CircleAvatar(
            radius: MediaQuery.of(context).size.height * 0.03,
            backgroundColor: navBarColor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Center(
                child: imgPath == null ? const Icon(
                  UniconsLine.flower,
                  size: 32,
                  color: primaryColor,
                ) : Image.asset(
                  imgPath!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          title : Text("Plant Name"),
          trailing : Icon(Icons.delete_outline)
        ),
      ),
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
