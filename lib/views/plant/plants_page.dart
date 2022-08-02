import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:plantory/views/plant/plant_add_page.dart';
import 'package:plantory/views/plant/plant_detail_page.dart';
import 'package:unicons/unicons.dart';
import '../../../utils/colors.dart';
import '../../data/plant.dart';

class PlantsPage extends StatefulWidget {

  const PlantsPage({Key? key,required this.plantList}) : super(key: key);

  final List<Plant> plantList;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PlantsPage();
  }
}

class _PlantsPage extends State<PlantsPage> {

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, position) {
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 2,
              child: Wrap(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                          onTap: () {
                            Get.to(() => PlantDetailPage(plant: widget.plantList[position]))?.then((value) => setState((){}));
                          },
                          child: Center(
                            child: Column(
                              children: [
                                Center(
                                  child: widget.plantList[position].image != null ? ClipOval(
                                        child: Image.memory(base64Decode(widget.plantList[position].image!),
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        height: MediaQuery.of(context).size.width * 0.3,
                                        fit: BoxFit.cover,
                                      )
                                  ) :
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.3,
                                    height: MediaQuery.of(context).size.width * 0.3,
                                    decoration: BoxDecoration(
                                        color: Color(0xff8bbb88),
                                        borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.3))),
                                    child: Icon(UniconsLine.flower,size: MediaQuery.of(context).size.width * 0.15,color: Colors.black54,)
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      widget.plantList[position].name!,
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
          itemCount: widget.plantList.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => PlantAddPage(plantList : widget.plantList,))?.then((value) => setState((){}));
        },
        heroTag: null,
        child: Icon(Icons.add, size: 40,),backgroundColor: primaryColor,),
    );
  }
}

