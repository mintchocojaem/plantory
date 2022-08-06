import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:line_icons/line_icons.dart';
import 'package:plantory/views/plant/plant_add_page.dart';
import 'package:plantory/views/plant/plant_detail_page.dart';
import 'package:unicons/unicons.dart';
import '../../../utils/colors.dart';
import '../../data/person.dart';
import '../../data/plant.dart';

class PlantsPage extends StatefulWidget {

  const PlantsPage({Key? key, required this.person}) : super(key: key);

  final Person person;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PlantsPage();
  }
}

class _PlantsPage extends State<PlantsPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    widget.person.plants!.sort((a, b) {
      if(b!.pinned!) {
        return 1;
      }
      return -1;
    });

    return Scaffold(
      backgroundColor: Color(0xffEEF1F1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Color(0xffEEF1F1),
        title: const Text(
          "Plants",
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: widget.person.plants!.isNotEmpty ? Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, position) {
            return  Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 2,
              child: Wrap(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                          onTap: () {
                            Get.to(() => PlantDetailPage(plant:widget.person.plants![position]!, person: widget.person,))!.then((value) => setState((){}));
                          },
                          child: Center(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Center(
                                      child: widget.person.plants![position]!.image != null ? ClipOval(
                                            child: Image.memory(base64Decode(widget.person.plants![position]!.image!),
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            height: MediaQuery.of(context).size.width * 0.3,
                                            fit: BoxFit.cover,
                                          )
                                      ) :
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        height: MediaQuery.of(context).size.width * 0.3,
                                        decoration: BoxDecoration(
                                            color: Color(0xffC9D9CF),
                                            borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.3))),
                                        child: Icon(UniconsLine.flower,size: MediaQuery.of(context).size.width * 0.15,color: Colors.black54,)
                                      ),
                                    ),
                                    widget.person.plants![position]!.pinned == true ? Positioned(
                                        top: 0,
                                        right:  MediaQuery.of(context).size.width * 0.08,
                                        child: Container(
                                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                                          decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius: BorderRadius.all(Radius.circular(100)),
                                          ),
                                          child: Icon(LineIcons.byName('crown',), color: Colors.amber),
                                        )
                                    ) : Container(),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      widget.person.plants![position]!.name!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))),
                ],
              ),
            );
          },
          itemCount: widget.person.plants!.length,
        ),
      ) : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(UniconsLine.flower),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Plantory에 처음 오신 것을 환영합니다."),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("이용자님의 첫 식물을 추가해보세요!"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => PlantAddPage(person: widget.person,))!.then((value) => setState((){}));
        },
        heroTag: null,
        child: Icon(Icons.add,),backgroundColor: primaryColor,),
    );
  }
}

