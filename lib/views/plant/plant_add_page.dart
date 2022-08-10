import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantory/views/notification/notification.dart';
import 'package:unicons/unicons.dart';
import '../../../data/plant.dart';
import '../../../utils/colors.dart';
import '../../controller/bottom_nav_controller.dart';
import '../../data/person.dart';
import '../home/home_page.dart';
import 'input_field.dart';
import 'package:intl/intl.dart';


class PlantAddPage extends StatefulWidget{

  const PlantAddPage({Key? key, required this.person}) : super(key: key);

  final Person person;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PlantAddPage();
  }

}

class _PlantAddPage extends State<PlantAddPage>{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final List<Map> cycles = [
    {
      Cycles.id.name : 0,
      Cycles.type.name : "물",
      Cycles.cycle.name : 14,
      Cycles.startDate.name : DateFormat('yyyy-MM-dd').format(DateTime.now()),
      Cycles.initDate.name : DateFormat('yyyy-MM-dd').format(DateTime.now()),
    },
    {
      Cycles.id.name : 1,
      Cycles.type.name : "분갈이",
      Cycles.cycle.name : 60,
      Cycles.startDate.name : DateFormat('yyyy-MM-dd').format(DateTime.now()),
      Cycles.initDate.name : DateFormat('yyyy-MM-dd').format(DateTime.now()),
    },
  ];

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final TextEditingController wateringStartDateController = TextEditingController();
  final TextEditingController wateringCycleController = TextEditingController();

  final TextEditingController repottingStartDateController = TextEditingController();
  final TextEditingController repottingCycleController = TextEditingController();

  var image;

  @override
  initState() {

    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    wateringStartDateController.text = cycles[CycleType.watering.index][Cycles.startDate.name];
    wateringCycleController.text = cycles[CycleType.watering.index][Cycles.cycle.name].toString();

    repottingStartDateController.text = cycles[CycleType.repotting.index][Cycles.startDate.name];
    repottingCycleController.text = cycles[CycleType.repotting.index][Cycles.cycle.name].toString();

    cycles[CycleType.watering.index][Cycles.id.name] = generateCycleID(widget.person.plants!);
    cycles[CycleType.repotting.index][Cycles.id.name] = generateCycleID(widget.person.plants!)+1;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xffEEF1F1),
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                        child: image == null ? Container()
                            : Image.memory(image, fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                        )
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.08,
                      color: Colors.black54,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8, left: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: (){
                                  Get.back();
                                  },
                                icon: Icon(Icons.arrow_back_ios_rounded, color: Color(0xffEEF1F1),)
                            ),
                            IconButton(onPressed: () async{
                              var id = generateID(widget.person.plants!);
                              if (_formKey.currentState!.validate()) {

                                widget.person.plants!.add(
                                    Plant(
                                      id: id,
                                      pinned: false,
                                      name: nameController.text,
                                      type: typeController.text,
                                      date: dateController.text,
                                      note: noteController.text,
                                      cycles: cycles,
                                      image: image != null ? base64Encode(image) : null,
                                      timelines: List.empty(growable: true),
                                    )
                                );
                                var usersCollection = firestore.collection('users');
                                await usersCollection.doc(widget.person.uid).update(
                                    {
                                      "plants": widget.person.plantsToJson(widget.person.plants!)
                                    }).then((value) => Get.back());

                                PlantNotification plantNotification = PlantNotification();
                                plantNotification.zonedMidnightSchedule(cycles[CycleType.watering.index][Cycles.id.name], "Plantory 알림",
                                    "\"${nameController.text}\"에게 물을 줄 시간입니다!", getFastWateringDate(cycles));

                                plantNotification.zonedMidnightSchedule(cycles[CycleType.repotting.index][Cycles.id.name], "Plantory 알림",
                                    "\"${nameController.text}\"의 분갈이 시간입니다!", getFastRepottingDate(cycles));

                              }
                            }, icon: Icon(Icons.check_rounded, color: Color(0xffEEF1F1)))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InputField(
                          isEditable: true,
                          label: "이름",
                          controller: nameController,
                          emptyText: false,
                          maxLength: 20,
                          maxLines: 1,
                        ),
                        InputField(
                          isEditable: true,
                          label: '종류',
                          controller: typeController,
                          emptyText: false,
                          maxLength: 20,
                          maxLines: 1,
                        ),
                        InputField(
                          onTap: () async{

                            await showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext builder) {
                                  return Container(
                                    height: MediaQuery.of(context).copyWith().size.height*0.25,
                                    color: Colors.white,
                                    child: CupertinoDatePicker(
                                      initialDateTime: DateTime.now(), //초기값
                                      minimumDate: DateTime(DateTime.now().year-1), //시작일
                                      maximumDate: DateTime(DateTime.now().year+1), //마지막일
                                      mode: CupertinoDatePickerMode.date,
                                      onDateTimeChanged: (value) {
                                        if (DateFormat('yyyy-MM-dd').format(value) != dateController.text) {
                                          setState(() {
                                            dateController.text = DateFormat('yyyy-MM-dd').format(value);
                                          });
                                        }
                                      },
                                    ),
                                  );
                                }
                            );
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
                          maxLength: 200,
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                              initiallyExpanded: true,
                              title: Text("주기"),
                              children: [
                                ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: cycleTile(cycles, CycleType.watering, wateringStartDateController, wateringCycleController)
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: cycleTile(cycles, CycleType.repotting, repottingStartDateController, repottingCycleController)
                                    )
                                  ],
                                ),
                              ]
                          ),
                        ),
                        Divider(thickness: 1,color: Colors.black38,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          var picker = ImagePicker();

          showCupertinoModalPopup(
            barrierColor: Colors.black54,
            context: context,
            builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.only(left: 16,right: 16),
              child: CupertinoActionSheet(
                  actions: <Widget>[
                    CupertinoActionSheetAction(
                      child: const Text('갤러리에서 가져오기'),
                      onPressed: () async{
                        await picker.pickImage(source: ImageSource.gallery,maxWidth: 1024, maxHeight: 1024)
                            .then((value) async{
                          image = await value?.readAsBytes();
                          setState(() {});
                          Get.back();
                        });
                      },
                    ),
                    CupertinoActionSheetAction(
                      child: const Text('사진 찍기'),
                      onPressed: () async{
                        await picker.pickImage(source: ImageSource.camera,maxWidth: 1024, maxHeight: 1024)
                            .then((value) async{
                              image = await value?.readAsBytes();
                              setState(() {});
                              Get.back();
                            });
                      },
                    )
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    child: const Text('Cancel'),
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    },
                  )),
            ),
          );
        },
        heroTag: null,
        child: Icon(Icons.camera_alt_outlined,),backgroundColor: primaryColor,),
    );
  }

  Widget cycleTile(List cycles, CycleType cycleType, TextEditingController startDateController, TextEditingController cycleController){
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
                  trailing:  Text("D ${cycleType == CycleType.watering
                      ? -getFastWateringDate(cycles) : -getFastRepottingDate(cycles)}")
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
                        hintText:  cycles[cycleType == CycleType.watering ? 0 : 1][Cycles.startDate.name],
                      ),
                      onTap: () async{
                        await showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext builder) {
                          return Container(
                            height: MediaQuery.of(context).copyWith().size.height*0.25,
                            color: Colors.white,
                            child: CupertinoDatePicker(
                              initialDateTime: DateFormat('yyyy-MM-dd').parse(cycles[cycleType == CycleType.watering ? 0 : 1][Cycles.startDate.name]),
                              minimumDate: DateTime(DateTime.now().year), //시작일
                              maximumDate: DateTime(DateTime.now().year+1).subtract(Duration(days: 1)), //마지막일
                              mode: CupertinoDatePickerMode.date,
                              onDateTimeChanged: (value) {
                                if (DateFormat('yyyy-MM-dd').format(value) != startDateController.text) {
                                  setState(() {
                                    startDateController.text = DateFormat('yyyy-MM-dd').format(value);
                                  });
                                }
                              },
                            ),
                          );
                        });
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
                        hintText:  cycles[cycleType == CycleType.watering ? 0 : 1][Cycles.cycle.name].toString(),
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
                    if(int.parse(cycleController.text) > 0){
                      cycles[cycleType == CycleType.watering ? 0 : 1][Cycles.startDate.name] = startDateController.text;
                      cycles[cycleType == CycleType.watering ? 0 : 1][Cycles.initDate.name] = startDateController.text;
                      cycles[cycleType == CycleType.watering ? 0 : 1][Cycles.cycle.name] = int.parse(cycleController.text);
                      Navigator.pop(context);
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  '주기 값은 1 이상이어야 합니다.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.red
                                  )
                              )
                          )
                      );
                      setState((){
                        cycleController.text = cycles[cycleType == CycleType.watering ? 0 : 1][Cycles.cycle.name].toString();
                      });
                    }
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
