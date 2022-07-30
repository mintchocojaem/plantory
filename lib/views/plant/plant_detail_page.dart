
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:unicons/unicons.dart';
import '../../../data/plant.dart';
import '../../../utils/colors.dart';
import '../home/home_page.dart';
import 'input_field.dart';
import 'package:intl/intl.dart';


class PlantDetailPage extends StatefulWidget{

  const PlantDetailPage({Key? key, required this.plant}) : super(key: key);

  final Plant plant;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PlantDetailPage();
  }

}

class _PlantDetailPage extends State<PlantDetailPage>{

  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final TextEditingController wateringStartDateController = TextEditingController();
  final TextEditingController wateringCycleController = TextEditingController();

  final TextEditingController repottingStartDateController = TextEditingController();
  final TextEditingController repottingCycleController = TextEditingController();

  bool pinned = false;
  var image;

  @override
  initState() {
    nameController.text = widget.plant.name!;
    if(widget.plant.type != null) typeController.text = widget.plant.type!;
    if(widget.plant.note != null) noteController.text = widget.plant.note!;
    dateController.text = widget.plant.date!;

    wateringStartDateController.text = widget.plant.cycles![0][Cycles.startDate.name];
    wateringCycleController.text = widget.plant.cycles![0][Cycles.cycle.name];

    repottingStartDateController.text = widget.plant.cycles![1][Cycles.startDate.name];
    repottingCycleController.text = widget.plant.cycles![1][Cycles.cycle.name];

    pinned = widget.plant.pinned!;

    if(widget.plant.image !=null) image = base64Decode(widget.plant.image!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xffEEF1F1),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black54,),
          onPressed: () { Navigator.pop(context); },
        ),
        elevation: 0,
        title: Text("식물 정보",style: TextStyle(color: primaryColor),),
        backgroundColor: Color(0xffEEF1F1),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: IconButton(
                onPressed: (){

                },
                icon: Icon(Icons.check, color: Colors.black54,)),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
            child: Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.all(Radius.circular(100))
                              ),
                              child: IconButton(
                                icon: Icon(LineIcons.byName('crown',), color: pinned == true ? Colors.amber : Colors.white,),
                                onPressed: (){
                                  setState((){
                                    pinned = !pinned;
                                  });
                                },
                              ),
                            )
                        ),
                        Center(
                            child: GestureDetector(
                              child: image == null ? Container(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  height: MediaQuery.of(context).size.width * 0.4,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black54,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.6))
                                  ),
                                  child: Icon(Icons.add_a_photo_outlined,)
                              ) : ClipOval(
                                  child: Image.memory(image, fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.width * 0.4,)
                              ),
                              onTap: () {
                                var picker = ImagePicker();
                                showDialog(
                                  barrierColor: Colors.black54,
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: Center(child: Text("사진 선택")),
                                    titlePadding: EdgeInsets.all(15),
                                    content: SizedBox(
                                      width: double.infinity,
                                      height: MediaQuery.of(context).size.height * 0.2,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Divider(thickness: 1,color: Colors.black54,),
                                            ListTile(title: Text("카메라"),
                                              leading: Icon(Icons.camera_alt_outlined),
                                              onTap: () async{
                                                await picker.pickImage(source: ImageSource.camera)
                                                    .then((value) =>  Navigator.of(context).pop(value));},

                                            ),
                                            Divider(thickness: 1),
                                            ListTile(title: Text("갤러리"),
                                              leading: Icon(Icons.photo_camera_back),
                                              onTap: () async{
                                                await picker.pickImage(source: ImageSource.gallery)
                                                    .then((value) =>  Navigator.of(context).pop(value));},
                                            ),
                                            Divider(thickness: 1),
                                          ],
                                        ),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(0),
                                    actions: [
                                      TextButton(
                                        child: const Text('취소'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ).then((value) async{
                                  if(value != null){
                                    image = await value.readAsBytes();
                                    setState((){});
                                  }
                                });

                              },
                            )
                        ),
                      ],
                    ),
                    InputField(
                      boldText: true,
                      isEditable: true,
                      label: "이름",
                      controller: nameController,
                      emptyText: false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputField(
                      boldText: true,
                      isEditable: true,
                      label: '종류',
                      controller: typeController,
                      emptyText: false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputField(
                      onTap: () async{
                        dateController.text = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(), //초기값
                          firstDate: DateTime(DateTime.now().year-1), //시작일
                          lastDate: DateTime(DateTime.now().year+1), //마지막일
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.dark(), //다크 테마
                              child: child!,
                            );
                          },
                        ).then((value) => value != null ? DateFormat('yyyy-MM-dd').format(value) : dateController.text);
                      },
                      controller: dateController,
                      isEditable: false,
                      label: '만날 날',
                      emptyText: false,
                      icon: Icon(Icons.calendar_month_outlined),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: noteController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(height:0.1),
                        labelText: "노트",
                        hintText:  "주요 특징, 꽃말 등을 적어보세요!",
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text("주기"),
                    const SizedBox(
                      height: 20,
                    ),
                    ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: //cycleTile(widget.plant.cycles!,0,wateringStartDateController,wateringCycleController)
                          cycleTile(widget.plant, CycleType.watering, wateringStartDateController, wateringCycleController)
                        ),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: //cycleTile(widget.plant.cycles!,1,repottingStartDateController,repottingCycleController)
                            cycleTile(widget.plant, CycleType.repotting, repottingStartDateController, repottingCycleController)
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget cycleTile(Plant plant, CycleType cycleType, TextEditingController startDateController, TextEditingController cycleController){
    return GestureDetector(
      child: Card(
        color: primaryColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Wrap(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10))),
              margin: EdgeInsets.only(left: 10),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: ListTile(
                  leading: cycleType == CycleType.watering ? Icon(Icons.water_drop) : Icon(UniconsLine.shovel),
                  title: Text(cycleType ==  CycleType.watering ? "물" : "분갈이"),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black38, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  trailing: !plant.cycles![cycleType == CycleType.watering ? 0 : 1][Cycles.init.name] &&
                      (cycleType == CycleType.watering ? getFastWateringDate(plant.cycles!)
                          : -getFastRepottingDate(plant.cycles!)) ==
                          int.parse(plant.cycles![cycleType == CycleType.watering ? 0 : 1][Cycles.cycle.name])
                      ? IconButton(
                      onPressed: () {
                        setState((){
                          plant.cycles![cycleType == CycleType.watering ? 0 : 1][Cycles.init.name] = true;
                        });
                      },
                      icon: Icon(Icons.check_circle_outline)
                  )
                      : Text("D ${cycleType == CycleType.watering
                      ? -getFastWateringDate(plant.cycles!) : -getFastRepottingDate(plant.cycles!)}")
              ),
            ),
          ],
        ),
      ),
      onTap: () async{
        showDialog(context: context, barrierColor: Colors.black54,builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("주기 설정"),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      readOnly: true,
                      controller: startDateController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(height:0.1),
                        labelText: "시작일",
                        hintText:  plant.cycles![cycleType == CycleType.watering ? 0 : 1][Cycles.startDate.name],
                      ),
                      onTap: () async{
                        startDateController.text = await showDatePicker(
                            context: context,
                            initialDate: DateFormat('yyyy-MM-dd').parse(plant.cycles![cycleType == CycleType.watering ? 0 : 1][Cycles.startDate.name]), //초기값
                            firstDate: DateTime(DateTime.now().year), //시작일
                            lastDate: DateTime(DateTime.now().year+1).subtract(Duration(days: 1)), //마지막일
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light(),
                                child: child!,
                              );
                            }).then((value) => value != null ? DateFormat('yyyy-MM-dd').format(value)
                            : startDateController.text);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: cycleController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(height:0.1),
                        labelText: "주기(일)",
                        hintText: plant.cycles![cycleType == CycleType.watering ? 0 : 1][Cycles.cycle.name],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('확인',style: TextStyle(color: Colors.red)),
                onPressed: () {
                  setState((){
                    plant.cycles![cycleType == CycleType.watering ? 0 : 1][Cycles.startDate.name] = startDateController.text;
                    plant.cycles![cycleType == CycleType.watering ? 0 : 1][Cycles.cycle.name] = cycleController.text;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
      },
    );
  }

}
