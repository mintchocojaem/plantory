import 'package:flutter/material.dart';
import 'package:plantory/views/plant/plant_add_page.dart';
import 'package:plantory/views/plant/plant_detail_page.dart';
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
                            Navigator.of(context).push(MaterialPageRoute(builder: ((context) =>
                                PlantDetailPage(plant: widget.plantList[position]))));
                          },
                          child: Center(
                            child: Column(
                              children: [
                                Center(
                                  child: ClipOval(child: Image.asset('images/plant1.jpeg',width: MediaQuery.of(context).size.width * 0.3
                                    ,height: MediaQuery.of(context).size.width * 0.3,)),
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
          Navigator.of(context).push(MaterialPageRoute(builder: ((context) =>
              PlantAddPage(plantList: widget.plantList))));
        },
        heroTag: null,
        child: Icon(Icons.add, size: 40,),),
    );
  }
}

