import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantory/views/notification/notification.dart';
import 'package:unicons/unicons.dart';
import '../../../data/plant.dart';
import '../../../utils/colors.dart';
import '../../controller/bottom_nav_controller.dart';
import '../home/home_page.dart';
import 'input_field.dart';
import 'package:intl/intl.dart';


class PlantAddPage extends StatefulWidget{

  const PlantAddPage({Key? key, required this.plantList}) : super(key: key);

  final List<Plant> plantList;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PlantAddPage();
  }

}

class _PlantAddPage extends State<PlantAddPage>{

  final List<Map> cycles = [
    {
      Cycles.id.name : 0,
      Cycles.type.name : "물",
      Cycles.cycle.name : "14",
      Cycles.startDate.name : DateFormat('yyyy-MM-dd').format(DateTime.now()),
      Cycles.init.name : true
    },
    {
      Cycles.id.name : 1,
      Cycles.type.name : "분갈이",
      Cycles.cycle.name : "60",
      Cycles.startDate.name : DateFormat('yyyy-MM-dd').format(DateTime.now()),
      Cycles.init.name : true
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

    wateringStartDateController.text = cycles[0][Cycles.startDate.name];
    wateringCycleController.text = cycles[0][Cycles.cycle.name];

    repottingStartDateController.text = cycles[1][Cycles.startDate.name];
    repottingCycleController.text = cycles[1][Cycles.cycle.name];

    cycles[0][Cycles.id.name] = generateCycleID(widget.plantList);
    cycles[1][Cycles.id.name] = generateCycleID(widget.plantList)+1;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //print(DateFormat('yyyy-MM-dd').parse(DateTime.now().toString()).add(Duration(days: getFastWateringDate(cycles))));
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xffEEF1F1),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black54,),
          onPressed: () { Navigator.pop(context); },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: IconButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.plantList.add(
                        Plant(
                          id: generatePlantID(widget.plantList),
                          pinned: false,
                          name: nameController.text,
                          type: typeController.text,
                          date: dateController.text,
                          note: noteController.text,
                          cycles: cycles,
                          image: image != null ? base64Encode(image) : null,
                        )
                    );
                    /*final plantNotification = PlantNotification();
                    plantNotification.zonedMidnightSchedule(
                        cycles[0][Cycles.id.name],
                        "물주기 알림",
                        "오늘은 \"${nameController.text}\"에게 물을 주는 날입니다!",
                        int.parse(cycles[0][Cycles.cycle.name])
                    );
                    plantNotification.zonedMidnightSchedule(
                        cycles[1][Cycles.id.name],
                        "분갈이 알림",
                        "오늘은 \"${nameController.text}\"의 분갈이를 하는 날입니다!",
                        int.parse(cycles[1][Cycles.cycle.name])
                    );

                     */

                    Navigator.pop(context);
                  }

                },
                icon: Icon(Icons.check, color: Colors.black54,)),
          )
        ],
        elevation: 0,
        backgroundColor: Color(0xffEEF1F1),
        title: const Text(
          "식물 추가",
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(10),
            child: Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: GestureDetector(
                          child: image == null ? Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black54,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.4))
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
                    InputField(
                      isEditable: true,
                      label: "이름",
                      controller: nameController,
                      emptyText: false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputField(
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
                              data: ThemeData.light(), //다크 테마
                              child: child!,
                            );
                          },
                        ).then((value) => value != null ? DateFormat('yyyy-MM-dd').format(value) : dateController.text );
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
                          child: cycleTile(cycles,CycleType.watering,wateringStartDateController,wateringCycleController)
                        ),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: cycleTile(cycles,CycleType.repotting,repottingStartDateController,repottingCycleController)
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
                        startDateController.text = await showDatePicker(
                            context: context,
                            initialDate: DateFormat('yyyy-MM-dd').parse(cycles[cycleType == CycleType.watering ? 0 : 1][Cycles.startDate.name]), //초기값
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
                        hintText:  cycles[cycleType == CycleType.watering ? 0 : 1][Cycles.cycle.name],
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
                      cycles[cycleType == CycleType.watering ? 0 : 1][Cycles.cycle.name] = cycleController.text;
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
                        cycleController.text = cycles[cycleType == CycleType.watering ? 0 : 1][Cycles.cycle.name];
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
