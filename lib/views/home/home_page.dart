import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:plantory/views/community/community_page.dart';
import '../../../data/plant.dart';
import '../../../utils/colors.dart';
import '../../data/person.dart';
import '../calendar/calendar_page.dart';
import '../notification/notification.dart';

class HomePage extends StatefulWidget{

  HomePage({Key? key, required this.person, required this.plantsInfo}) : super(key: key);

  final Person person;
  final List<Map> plantsInfo;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePage();
  }

}

class _HomePage extends State<HomePage> with TickerProviderStateMixin{

  PlantNotification plantNotification = PlantNotification();

  final PageController pageController = PageController(initialPage: 0,viewportFraction: 0.85);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();

  late AnimationController _controller;

  static const List<IconData> floatingIcons = [ Icons.calendar_month_outlined, Icons.comment ];

  bool isPlantEditable = false;
  bool isInfoEditable = false;
  bool isNewPlant = false;
  bool isCustomType = false;
  bool isSubmitting = false;

  int pageIndex = 0;

  bool isOpen = false;

  int? id;

  final TextEditingController newNameController = TextEditingController();
  final TextEditingController newTypeController = TextEditingController();
  final TextEditingController newDateController = TextEditingController();

  final TextEditingController newWateringStartDateController = TextEditingController();
  final TextEditingController newWateringCycleController = TextEditingController();

  Uint8List? newImage;

  Map newCycles = {
      Cycles.type.name : "물",
      Cycles.cycle.name : 14,
      Cycles.startDate.name : DateFormat('yyyy-MM-dd').format(DateTime.now()),
      Cycles.initDate.name : DateFormat('yyyy-MM-dd').format(DateTime.now()),
    };

  @override
  void initState() {

    Future.delayed(const Duration(milliseconds: 500)).then((value) => FlutterNativeSplash.remove());

    newDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    newWateringStartDateController.text = newCycles[Cycles.startDate.name];
    newWateringCycleController.text = newCycles[Cycles.cycle.name].toString();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(widget.person.plants!.isEmpty){
      isNewPlant = true;
    }

    id = generateID(widget.person.plants!);

    return Scaffold(
      backgroundColor: Color(0xffEEF1F1),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          PageView.builder(
              physics: isPlantEditable ? NeverScrollableScrollPhysics() : null,
              itemCount: widget.person.plants!.length +1,
              pageSnapping: true,
              controller: pageController,
              onPageChanged: (index){

                pageIndex = index;
                  if(!isNewPlant && index > widget.person.plants!.indexOf(widget.person.plants!.last)){
                    setState(() {
                      isNewPlant = true;
                    });
                  }else if(isNewPlant){
                    setState(() {
                      isNewPlant = false;
                      FocusScope.of(context).unfocus();
                    });
                  }
              },
              itemBuilder: (context, index) {

                final TextEditingController nameController = TextEditingController();
                final TextEditingController typeController = TextEditingController();
                final TextEditingController dateController = TextEditingController();

                final TextEditingController wateringStartDateController = TextEditingController();
                final TextEditingController wateringCycleController = TextEditingController();

                final TextEditingController flowerLanguageController = TextEditingController();
                final TextEditingController temperatureController = TextEditingController();
                final TextEditingController humidityController = TextEditingController();
                final TextEditingController sunlightController = TextEditingController();
                final TextEditingController wateringController = TextEditingController();
                final TextEditingController transplantingController = TextEditingController();

                Uint8List? image;

                String? beforeName;
                String? beforeType;

                if(widget.person.plants!.isNotEmpty && index <= widget.person.plants!.indexOf(widget.person.plants!.last)){

                  beforeName = widget.person.plants![index]!.name!;
                  beforeType = widget.person.plants![index]!.type!;

                  nameController.text = widget.person.plants![index]!.name!;
                  typeController.text = widget.person.plants![index]!.type!;
                  dateController.text = widget.person.plants![index]!.date!;

                  wateringStartDateController.text = widget.person.plants![index]!.watering![Cycles.startDate.name];
                  wateringCycleController.text = widget.person.plants![index]!.watering![Cycles.cycle.name].toString();

                  flowerLanguageController.text = widget.person.plants![index]!.info?["flowerLanguage"];
                  temperatureController.text = widget.person.plants![index]!.info?["temperature"];
                  humidityController.text = widget.person.plants![index]!.info?["humidity"];
                  sunlightController.text = widget.person.plants![index]!.info?["sunlight"];
                  wateringController.text = widget.person.plants![index]!.info?["watering"];
                  transplantingController.text = widget.person.plants![index]!.info?["transplanting"];

                }

                return Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08,
                      left: 4,right: 4,bottom: MediaQuery.of(context).size.height * 0.1),
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01,
                            bottom: MediaQuery.of(context).size.height * 0.01,
                            left: 8,
                            right: 8,
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  IntrinsicWidth(
                                      child: widget.person.plants!.isNotEmpty && index <= widget.person.plants!.indexOf(widget.person.plants!.last) ? TextFormField(
                                        autofocus: false,
                                        controller: nameController,
                                        maxLines: 1,
                                        maxLength: 6,
                                        readOnly: !isPlantEditable,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          border: isPlantEditable ? null : InputBorder.none,
                                          counterText: "",
                                          hintStyle: const  TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                          hintText: widget.person.plants![index]!.name!,
                                        ),
                                        onChanged: (value){
                                          if(value != ""){
                                            widget.person.plants![index]!.name = value;
                                          }else{
                                            widget.person.plants![index]!.name = beforeName;
                                          }
                                        },
                                      ) : TextFormField(
                                        autofocus: false,
                                        controller: newNameController,
                                        maxLines: 1,
                                        maxLength: 6,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          counterText: "",
                                          hintStyle: const  TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                          hintText: "이름",
                                        ),
                                      )
                                  ),
                                  Text(" | "),
                                  IntrinsicWidth(
                                      child: widget.person.plants!.isNotEmpty && index <= widget.person.plants!.indexOf(widget.person.plants!.last) ? TextFormField(
                                        autofocus: false,
                                        controller: typeController,
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 14),
                                        maxLength: 25,
                                        readOnly: !isPlantEditable || (isPlantEditable && !isCustomType),
                                        decoration: InputDecoration(
                                            isDense: true,
                                            border: isPlantEditable ? null : InputBorder.none,
                                            counterText: "",
                                            hintText: widget.person.plants![index]!.type!
                                        ),
                                        onChanged: (value){
                                          if(value != ""){
                                            widget.person.plants![index]!.type = value;
                                          }else{
                                            widget.person.plants![index]!.type = beforeType;
                                          }
                                        },
                                        onTap: (){
                                          if((isPlantEditable || isNewPlant) && !isCustomType){
                                            showDialog(context: context, builder: (context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("식물 종류 선택"),
                                                    IconButton(
                                                        onPressed: (){
                                                          Get.back();
                                                        },
                                                        icon: Icon(Icons.close,color: Colors.black54,)
                                                    )
                                                  ],
                                                ),
                                                content: SizedBox(
                                                  height: MediaQuery.of(context).size.height * 0.5,
                                                  width: MediaQuery.of(context).size.width * 0.8,
                                                  child: ListView.builder(
                                                      scrollDirection: Axis.vertical,
                                                      itemCount: widget.plantsInfo.length+1,
                                                      itemBuilder: (BuildContext context, int position) =>
                                                          GestureDetector(
                                                            child: Container(
                                                              color: Colors.white,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Divider(thickness: 1,),
                                                                  SingleChildScrollView(
                                                                    scrollDirection: Axis.horizontal,
                                                                    child: position <= widget.plantsInfo.indexOf(widget.plantsInfo.last) ?
                                                                    Row(
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(4.0),
                                                                            child: Text(widget.plantsInfo[position]["korName"],style: TextStyle(fontSize: 15),),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(4.0),
                                                                            child: Text(widget.plantsInfo[position]["enName"],style: TextStyle(fontSize: 14),),
                                                                          ),
                                                                        ]
                                                                    ) : Padding(
                                                                      padding: const EdgeInsets.all(4.0),
                                                                      child: Text("직접 입력"),
                                                                    ),
                                                                  ),
                                                                  position > widget.plantsInfo.indexOf(widget.plantsInfo.last) ?  Divider(thickness: 1,) : Container()
                                                                ],
                                                              ),
                                                            ),
                                                            onTap: (){

                                                              setState(() {
                                                                if(position > widget.plantsInfo.indexOf(widget.plantsInfo.last)){
                                                                  isCustomType = true;
                                                                }else{
                                                                  widget.person.plants![index]!.type = widget.plantsInfo[position]["enName"];
                                                                }
                                                              });

                                                              Get.back();
                                                            },
                                                          )
                                                  ),
                                                ),
                                              );
                                            });
                                          }
                                        },
                                      ) : TextFormField(
                                        readOnly: !isCustomType,
                                        autofocus: false,
                                        controller: newTypeController,
                                        maxLines: 1,
                                        maxLength: 25,
                                        style: TextStyle(fontSize: 14),
                                        decoration: InputDecoration(
                                          counterText: "",
                                          isDense: true,
                                          hintText: "식물 종류",
                                        ),
                                        onTap: (){
                                          if((isPlantEditable || isNewPlant) && !isCustomType){
                                            showDialog(context: context, builder: (context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("식물 종류 선택"),
                                                    IconButton(
                                                        onPressed: (){
                                                          Get.back();
                                                        },
                                                        icon: Icon(Icons.close,color: Color(0xff404040),)
                                                    )
                                                  ],
                                                ),
                                                content: SizedBox(
                                                  height: MediaQuery.of(context).size.height * 0.5,
                                                  width: MediaQuery.of(context).size.width * 0.8,
                                                  child: ListView.builder(
                                                      scrollDirection: Axis.vertical,
                                                      itemCount: widget.plantsInfo.length+1,
                                                      itemBuilder: (BuildContext context, int position) =>
                                                          GestureDetector(
                                                            child: Container(
                                                              color: Colors.white,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Divider(thickness: 1,),
                                                                  SingleChildScrollView(
                                                                    scrollDirection: Axis.horizontal,
                                                                    child: position <= widget.plantsInfo.indexOf(widget.plantsInfo.last) ?
                                                                    Row(
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(4.0),
                                                                            child: Text(widget.plantsInfo[position]["korName"],style: TextStyle(fontSize: 15),),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(4.0),
                                                                            child: Text(widget.plantsInfo[position]["enName"],style: TextStyle(fontSize: 14),),
                                                                          ),
                                                                        ]
                                                                    ) : Padding(
                                                                      padding: const EdgeInsets.all(4.0),
                                                                      child: Text("직접 입력"),
                                                                    ),
                                                                  ),
                                                                  position > widget.plantsInfo.indexOf(widget.plantsInfo.last) ?  Divider(thickness: 1,) : Container()
                                                                ],
                                                              ),
                                                            ),
                                                            onTap: (){
                                                              setState(() {
                                                                if(position > widget.plantsInfo.indexOf(widget.plantsInfo.last)){
                                                                  isCustomType = true;
                                                                }else{
                                                                  newTypeController.text = widget.plantsInfo[position]["enName"];
                                                                }
                                                              });
                                                              Get.back();
                                                            },
                                                          )
                                                  ),
                                                ),
                                              );
                                            });
                                          }
                                        },
                                      )
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.05,
                                child: widget.person.plants!.isNotEmpty && index <= widget.person.plants!.indexOf(widget.person.plants!.last) ? Row(
                                  children: [
                                    Text("${widget.person.plants![index]!.name!} 친구와 함께한지 ",),
                                    Text("${DateFormat('yyyy-MM-dd')
                                        .parse(DateTime.now().toString()).difference(DateFormat('yyyy-MM-dd')
                                        .parse(widget.person.plants![index]!.date!)).inDays}일이 지났어요!",
                                      style: TextStyle(fontWeight: FontWeight.w500),)
                                  ],
                                ) : Container(),
                              ),
                            ],
                          )
                      ),
                      Expanded(
                        child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: widget.person.plants!.isNotEmpty && index <= widget.person.plants!.indexOf(widget.person.plants!.last) ? Image.asset("assets/images/default_plant6_512.png",
                                    width: MediaQuery.of(context).size.width * 0.4,) : Icon(Icons.add_a_photo_outlined),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.05,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 18,left: 18),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () async{
                                                if(isPlantEditable){
                                                  await showCupertinoModalPopup(
                                                      context: context,
                                                      builder: (BuildContext builder) {
                                                        return Container(
                                                          height: MediaQuery.of(context).copyWith().size.height*0.25,
                                                          color: Colors.white,
                                                          child: CupertinoDatePicker(
                                                            initialDateTime: DateFormat('yyyy-MM-dd').parse(dateController.text), //초기값
                                                            maximumDate: DateTime.now(), //마지막일
                                                            mode: CupertinoDatePickerMode.date,
                                                            onDateTimeChanged: (value) {
                                                              if (DateFormat('yyyy-MM-dd').format(value) != dateController.text) {
                                                                setState(() {
                                                                  dateController.text = DateFormat('yyyy-MM-dd').format(value);
                                                                  widget.person.plants![index]!.date = DateFormat('yyyy-MM-dd').format(value);
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        );
                                                      }
                                                  ).then((value) {
                                                    setState(() {});
                                                  });
                                                }else if(isNewPlant){
                                                  await showCupertinoModalPopup(
                                                      context: context,
                                                      builder: (BuildContext builder) {
                                                        return Container(
                                                          height: MediaQuery.of(context).copyWith().size.height*0.25,
                                                          color: Colors.white,
                                                          child: CupertinoDatePicker(
                                                            initialDateTime:  DateFormat('yyyy-MM-dd').parse(newDateController.text),
                                                            maximumDate: DateTime.now(), //마지막일
                                                            mode: CupertinoDatePickerMode.date,
                                                            onDateTimeChanged: (value) {
                                                              if (DateFormat('yyyy-MM-dd').format(value) != newDateController.text) {
                                                                setState(() {
                                                                  newDateController.text = DateFormat('yyyy-MM-dd').format(value);
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        );
                                                      }
                                                  );
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  isNewPlant ? Text(newDateController.text,
                                                    style: TextStyle(color: Color(0xff404040),fontWeight: FontWeight.bold),)
                                                      : Text(dateController.text != "" ? dateController.text : DateFormat('yyyy-MM-dd').format(DateTime.now()) ,
                                                    style: TextStyle(color: Color(0xff404040),fontWeight: FontWeight.bold),),
                                                  isPlantEditable || isNewPlant ? Padding(
                                                    padding: const EdgeInsets.only(right: 8, left: 8),
                                                    child: Icon(
                                                        Icons.edit_note,
                                                        size: MediaQuery.of(context).size.width * 0.05,
                                                        color: Color(0xff404040)),
                                                  ) : Container(),
                                                ],
                                              ),
                                            ),
                                            !isPlantEditable && !isNewPlant ? PopupMenuButton<String>(
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width * 0.1,
                                                  alignment: Alignment.centerRight,
                                                  child: Icon(
                                                    Icons.more_vert,color: Colors.black54,
                                                  ),
                                                ),
                                                onSelected: (value) async{
                                                  switch (value) {
                                                    case '수정':
                                                      setState((){
                                                        isPlantEditable = true;
                                                      });
                                                      break;
                                                    case '정보':
                                                      await showDialog(context: context, barrierColor: Colors.black54,builder: (context) {
                                                        return StatefulBuilder(
                                                            builder: (context, setState) {
                                                              return AlertDialog(
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(20),
                                                                ),
                                                                contentPadding: EdgeInsets.only(right: 18,left: 18,top: 18),
                                                                title: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    IconButton(
                                                                        onPressed: (){
                                                                          Get.back();
                                                                        },
                                                                        icon: Icon(Icons.arrow_back_ios_rounded,)
                                                                    ),
                                                                    Text("식물 정보"),
                                                                    IconButton(
                                                                        onPressed: () async{
                                                                          if(isInfoEditable){
                                                                            setState((){
                                                                              isInfoEditable = !isInfoEditable;
                                                                            });
                                                                            widget.person.plants![index]!.info!["flowerLanguage"] = flowerLanguageController.text;
                                                                            widget.person.plants![index]!.info!["temperature"] = temperatureController.text;
                                                                            widget.person.plants![index]!.info!["humidity"] = humidityController.text;
                                                                            widget.person.plants![index]!.info!["watering"] = wateringController.text;
                                                                            widget.person.plants![index]!.info!["transplanting"] = transplantingController.text;
                                                                            widget.person.plants![index]!.info!["sunlight"] = sunlightController.text;
                                                                            var usersCollection = firestore.collection('users');
                                                                            await usersCollection.doc(widget.person.uid).update(
                                                                                {
                                                                                  "plants": widget.person.plantsToJson(widget.person.plants!)
                                                                                });
                                                                          }else{
                                                                            setState((){
                                                                              isInfoEditable = !isInfoEditable;
                                                                            });
                                                                          }
                                                                        },
                                                                        icon: isInfoEditable
                                                                            ? Icon(Icons.check)
                                                                            : Icon(Icons.edit_note)
                                                                    )
                                                                  ],
                                                                ),
                                                                content: SizedBox(
                                                                  child: SingleChildScrollView(
                                                                    child: Column(
                                                                      children: [
                                                                        TextField(
                                                                          readOnly: !isInfoEditable,
                                                                          controller: flowerLanguageController,
                                                                          decoration: InputDecoration(
                                                                            labelStyle: TextStyle(height:0.1),
                                                                            labelText: "꽃말",
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height: 10,
                                                                        ),
                                                                        TextField(
                                                                          controller: temperatureController,
                                                                          readOnly: !isInfoEditable,
                                                                          decoration: InputDecoration(
                                                                            labelStyle: const TextStyle(height:0.1),
                                                                            labelText: "온도",
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height: 10,
                                                                        ),
                                                                        TextField(
                                                                          controller: humidityController,
                                                                          readOnly: !isInfoEditable,
                                                                          decoration: InputDecoration(
                                                                            labelStyle: const TextStyle(height:0.1),
                                                                            labelText: "습도",
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height: 10,
                                                                        ),
                                                                        TextField(
                                                                          controller: sunlightController,
                                                                          readOnly: !isInfoEditable,
                                                                          decoration: InputDecoration(
                                                                            labelStyle: const TextStyle(height:0.1),
                                                                            labelText: "햇빛",
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height: 10,
                                                                        ),
                                                                        TextField(
                                                                          controller:  wateringController,
                                                                          readOnly: !isInfoEditable,
                                                                          decoration: InputDecoration(
                                                                            labelStyle: const TextStyle(height:0.1),
                                                                            labelText: "물 주기",
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height: 10,
                                                                        ),
                                                                        TextField(
                                                                          controller: transplantingController,
                                                                          readOnly: !isInfoEditable,
                                                                          decoration: InputDecoration(
                                                                            labelStyle: const TextStyle(height:0.1),
                                                                            labelText: "분갈이 주기",
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height: 30,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                        );
                                                      }).then((value) => setState((){ isInfoEditable = false;}));
                                                      break;
                                                    case '삭제':
                                                      showDialog(barrierColor: Colors.black54, context: context, builder: (context) {
                                                        return CupertinoAlertDialog(
                                                          title: const Text("식물 삭제"),
                                                          content: Padding(
                                                            padding: const EdgeInsets.only(top: 8),
                                                            child: Text("\"${widget.person.plants![index]!.name}\"를 삭제하시겠습니까?"),
                                                          ),
                                                          actions: [
                                                            CupertinoDialogAction(isDefaultAction: false, child: Text("취소"), onPressed: () {
                                                              Navigator.pop(context);
                                                            }),
                                                            CupertinoDialogAction(isDefaultAction: false, child: const Text("확인",style: TextStyle(color: Colors.red),),
                                                                onPressed: () async {

                                                                  plantNotification.cancel(widget.person.plants![index]!.id!);
                                                                  if(widget.person.plants![index]!.image != null){
                                                                    await FirebaseStorage.instance.refFromURL(widget.person.plants![index]!.image!).delete();
                                                                  }
                                                                  if(widget.person.plants![index]!.timelines != null){
                                                                    for(Map i in  widget.person.plants![index]!.timelines!){
                                                                      await FirebaseStorage.instance.refFromURL(i["image"]).delete();
                                                                    }
                                                                  }
                                                                  widget.person.plants!.remove(widget.person.plants![index]!);
                                                                  var usersCollection = firestore.collection('users');
                                                                  await usersCollection.doc(widget.person.uid).update(
                                                                      {
                                                                        "plants": widget.person.plantsToJson(widget.person.plants!)
                                                                      }).then((value) async {
                                                                    setState(() {});
                                                                    pageController.animateToPage(index-1, duration: Duration(milliseconds: 300), curve: Curves.ease);
                                                                    Get.back();
                                                                  });

                                                                }
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                      break;
                                                  }
                                                },
                                                itemBuilder: (context) => [
                                                  PopupMenuItem<String>(
                                                    height: MediaQuery.of(context).size.height * 0.05,
                                                    value: '수정',
                                                    child	: Text('수정'),
                                                  ),
                                                  PopupMenuDivider(),
                                                  PopupMenuItem<String>(
                                                    height: MediaQuery.of(context).size.height * 0.05,
                                                    value: '정보',
                                                    child: Text('정보'),
                                                  ),
                                                  PopupMenuDivider(),
                                                  PopupMenuItem<String>(
                                                    height: MediaQuery.of(context).size.height * 0.05,
                                                    value: '삭제',
                                                    child: Text('삭제'),
                                                  ),
                                                ]
                                            ) : Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 18,left: 18),
                                          child: GestureDetector(
                                              onTap: (){
                                                if(isPlantEditable || isNewPlant){
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
                                                                  if(isPlantEditable){
                                                                    final imageRef = storageRef.child("users/${widget.person.uid}/plants/${widget.person.plants![index]!.id}/image.text");
                                                                    if(image != null){
                                                                      imageRef.putData(image!).whenComplete(() {
                                                                        imageRef.getDownloadURL().then((value) {
                                                                          setState((){
                                                                            widget.person.plants![index]!.image = value;
                                                                          });
                                                                        });
                                                                      });
                                                                    }
                                                                  }else if(isNewPlant){
                                                                    setState((){
                                                                      newImage =  image;
                                                                    });
                                                                  }
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
                                                                  if(isPlantEditable){
                                                                    final imageRef = storageRef.child("users/${widget.person.uid}/plants/${widget.person.plants![index]!.id}/image.text");
                                                                    if(image != null){
                                                                      imageRef.putData(image!).whenComplete(() {
                                                                        imageRef.getDownloadURL().then((value) {
                                                                          setState((){
                                                                            widget.person.plants![index]!.image = value;
                                                                          });
                                                                        });
                                                                      });
                                                                    }
                                                                    setState(() {});
                                                                  }else if(isNewPlant){
                                                                    setState((){
                                                                      newImage =  image;
                                                                    });
                                                                  }
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
                                                }
                                              },
                                              child: widget.person.plants!.isNotEmpty && index <= widget.person.plants!.indexOf(widget.person.plants!.last) && widget.person.plants![index]!.image != null ? ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child:  Image.network(widget.person.plants![index]!.image!, fit: BoxFit.cover,gaplessPlayback: true),
                                              ) : newImage != null ? ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image.memory(newImage!, fit: BoxFit.cover,gaplessPlayback: true,),
                                              ) : Container(
                                                  height: MediaQuery.of(context).size.height,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    border: Border.all(color: Colors.black26),
                                                  )
                                              )
                                          ),
                                        )
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 18, left: 18),
                                      child: Container(
                                        width: double.infinity,
                                        height: MediaQuery.of(context).size.height * 0.08,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft:Radius.circular(10),
                                              bottomRight:Radius.circular(10)
                                          ),
                                        ),
                                        child: widget.person.plants!.isNotEmpty && index <= widget.person.plants!.indexOf(widget.person.plants!.last)
                                            ? wateringCycleTile(widget.person.plants![index]!.id!,widget.person.plants![index]!.watering!,
                                            widget.person.plants![index]!.name!,typeController, wateringStartDateController, wateringCycleController)
                                            : wateringCycleTile(id!,newCycles,nameController.text,newTypeController,
                                            newWateringStartDateController, newWateringCycleController),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                        ),
                      )
                    ],
                  ),
                );
              }),
          isOpen ? GestureDetector(
              onTap: (){
                setState((){isOpen = !isOpen;});
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
              child: Container(color: Colors.black26,)
          ) : Container()
        ],
      ),
      floatingActionButton: isPlantEditable || isNewPlant ? FloatingActionButton.extended(
        backgroundColor: primaryColor,
        label: Text("완료"),
        icon: Icon(Icons.check),
        onPressed: () async{
          if(!isSubmitting){
            isSubmitting = true;

          if(isPlantEditable){

            if(!widget.person.plants![pageIndex]!.type!.replaceAll(" ", "").isAlphabetOnly){
              showCupertinoDialog(context: context, builder: (context) {
                return CupertinoAlertDialog(
                  content: Text("식물 종류는 영문으로만 입력 가능합니다."),
                  actions: [
                    CupertinoDialogAction(isDefaultAction: true, child: Text("확인"), onPressed: () {
                      Navigator.pop(context);
                    })
                  ],
                );
              });
            }else{

              var usersCollection = firestore.collection('users');
              await usersCollection.doc(widget.person.uid).update(
                  {
                    "plants": widget.person.plantsToJson(widget.person.plants!)
                  }).then((value) {
                plantNotification.zonedMidnightSchedule(widget.person.plants![pageIndex]!.id!, "Plantory 알림",
                    "\"${widget.person.plants![pageIndex]!.name}\"에게 물을 줄 시간입니다!", getFastWateringDate(widget.person.plants![pageIndex]!.watering!));
              }).whenComplete(() {
                setState(() {
                  isSubmitting = true;
                  isPlantEditable = false;
                  isCustomType = false;
                });
              });
            }

          }else if(isNewPlant){

              Map? info = {
                'flowerLanguage' : "",
                'temperature' : "",
                'humidity' : "",
                'sunlight' : "",
                'watering' : "",
                'transplanting' : ""
              };

              for(Map i in widget.plantsInfo){
                if(i["enName"] == newTypeController.text){
                  info = i;
                }
              }

              if(newNameController.text == ""){
                showCupertinoDialog(context: context, builder: (context) {
                  return CupertinoAlertDialog(
                    content: Text("식물 이름을 입력해주세요"),
                    actions: [
                      CupertinoDialogAction(isDefaultAction: true, child: Text("확인"), onPressed: () {
                        Navigator.pop(context);
                      })
                    ],
                  );
                });
              }else if(newTypeController.text == ""){
                showCupertinoDialog(context: context, builder: (context) {
                  return CupertinoAlertDialog(
                    content: Text("식물 종류를 입력해주세요"),
                    actions: [
                      CupertinoDialogAction(isDefaultAction: true, child: Text("확인"), onPressed: () {
                        Navigator.pop(context);
                      })
                    ],
                  );
                });
              }else if(!newTypeController.text.replaceAll(" ", "").isAlphabetOnly){
                showCupertinoDialog(context: context, builder: (context) {
                  return CupertinoAlertDialog(
                    content: Text("식물 종류는 영문으로만 입력 가능합니다."),
                    actions: [
                      CupertinoDialogAction(isDefaultAction: true, child: Text("확인"), onPressed: () {
                        Navigator.pop(context);
                      })
                    ],
                  );
                });
              } else{

                final imageRef = storageRef.child("users/${widget.person.uid}/plants/$id/image.text");

                if(newImage != null){
                  await imageRef.putData(newImage!);
                }

                Plant plant = Plant(
                  id: id,
                  name: newNameController.text,
                  type: newTypeController.text,
                  date: newDateController.text,
                  watering: newCycles,
                  image: newImage != null ?  await imageRef.getDownloadURL() : null,
                  info: info,
                  timelines: List.empty(growable: true),
                );

                isNewPlant = false;
                isCustomType = false;

                widget.person.plants!.add(
                    plant
                );

                var usersCollection = firestore.collection('users');
                await usersCollection.doc(widget.person.uid).update(
                    {
                      "plants": widget.person.plantsToJson(widget.person.plants!)
                    }).whenComplete(() => pageController.jumpToPage(pageIndex+1)).then((value) {

                  pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 500), curve: Curves.ease).whenComplete(() {
                    plantNotification.zonedMidnightSchedule(plant.id!, "Plantory 알림",
                        "\"${plant.name}\"에게 물을 줄 시간입니다!", getFastWateringDate(widget.person.plants![pageIndex]!.watering!));
                  });

                  newNameController.text = "";
                  newTypeController.text = "";
                  newDateController.text = "";
                  newImage = null;
                  id = generateID(widget.person.plants!);

                  newDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

                  newCycles = {
                    Cycles.type.name : "물",
                    Cycles.cycle.name : 14,
                    Cycles.startDate.name : DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    Cycles.initDate.name : DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  };

                  newWateringStartDateController.text = newCycles[Cycles.startDate.name];
                  newWateringCycleController.text = newCycles[Cycles.cycle.name].toString();

                }).whenComplete(() {
                  setState(() {
                    isSubmitting = false;
                  });
                });

              }
            }
          }
        },
      ) : Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(floatingIcons.length, (int index) {
          Widget child = Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.1,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _controller,
                curve: Interval(
                    0.0, 1.0 - index / floatingIcons.length / 2.0, curve: Curves.easeOut
                ),
              ),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: primaryColor,
                mini: true,
                child: Icon(floatingIcons[index],),
                onPressed: () {
                  setState((){
                    isOpen = false;
                    _controller.reverse();
                  });
                  switch(index){
                    case 0 :
                      Get.to(() => CalendarPage(person: widget.person),transition: Transition.downToUp);
                      break;
                    case 1 :
                      Get.to(() => CommunityPage(person: widget.person),transition:  Transition.downToUp);
                      break;
                  }
                },
              ),
            ),
          );
          return child;
        }).toList()..add(
          AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return FloatingActionButton.extended(
                backgroundColor: primaryColor,
                label: Text("Menu"),
                icon: Icon(_controller.isDismissed ? Icons.menu : Icons.close),
                heroTag: null,
                onPressed: () {
                  setState(() {
                    isOpen = !isOpen;
                  });
                  if (_controller.isDismissed) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                },
              );
            }
          ),
        ),
      ),
    );
  }

  Widget wateringCycleTile(int id,Map cycles,String plantName,TextEditingController plantTypeController , TextEditingController startDateController, TextEditingController cycleController){

    Map? plantInfo;
    for(Map i in widget.plantsInfo){
      if(i["enName"] == plantTypeController.text){
        plantInfo = i;
      }
    }

    return GestureDetector(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.06,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8,top: 8,bottom: 8),
              child: Icon(Icons.water_drop,color: Color(0xff404040),)
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("물주기",style: TextStyle(color: Colors.black87))
            ),
            (isNewPlant || isPlantEditable) ?  Icon(Icons.edit_note)
                : (DateFormat('yyyy-MM-dd').parse(cycles[Cycles.initDate.name]))
                .isBefore(DateFormat('yyyy-MM-dd').parse(DateTime.now().toString())) &&
                getFastWateringDate(cycles) == cycles[Cycles.cycle.name]
          ? Row(
             children: [
              IconButton(
                onPressed: () async{
                  setState((){
                    cycles[Cycles.initDate.name]
                    = DateFormat('yyyy-MM-dd').format(DateTime.now()
                        .add(Duration(days: int.parse(cycles[Cycles.cycle.name].toString()))));
                  });
                  var usersCollection = firestore.collection('users');
                  await usersCollection.doc(widget.person.uid).update(
                      {
                        "plants": widget.person.plantsToJson(widget.person.plants!)
                      });

                  plantNotification.zonedMidnightSchedule(id, "Plantory 알림",
                      "\"$plantName\"에게 물을 줄 시간입니다!", getFastWateringDate(cycles));

                  }, icon: Icon(Icons.check_circle_outline)),
               Text("< 물을 준 후 클릭")
            ],
          )
                : Padding(padding: const EdgeInsets.all(8.0), child: Text("D${-getFastWateringDate(cycles)}",
              style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xff404040)),),
                )
          ],
        ),
      ),
      onTap: () async{
        if(isPlantEditable || isNewPlant){
          await showDialog(context: context, barrierColor: Colors.black54,builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: EdgeInsets.only(right: 18,left: 18,top: 18),
              title: const Text("주기 설정"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      readOnly: true,
                      controller: startDateController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(height:0.1),
                        labelText: "시작일",
                        hintText:  cycles[Cycles.startDate.name],
                      ),
                      onTap: () async{
                        await showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext builder) {
                              return Container(
                                height: MediaQuery.of(context).copyWith().size.height*0.25,
                                color: Colors.white,
                                child: CupertinoDatePicker(
                                  initialDateTime: DateFormat('yyyy-MM-dd').parse(startDateController.text),
                                  maximumDate: DateTime.now(), //마지막일
                                  mode: CupertinoDatePickerMode.date,
                                  onDateTimeChanged: (value) {
                                    if (DateFormat('yyyy-MM-dd').format(value) != startDateController.text) {
                                      startDateController.text = DateFormat('yyyy-MM-dd').format(value);
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
                      readOnly: true,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(height:0.1),
                        labelText: "주기(일)",
                        hintText: cycles[Cycles.cycle.name].toString(),
                      ),
                      onTap: () async{
                        await showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext builder) {
                          return SizedBox(
                            height: 200,
                            child: Center(
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(initialItem:  int.parse(cycleController.text)-1),
                                backgroundColor: Colors.white,
                                onSelectedItemChanged: (value){
                                  cycleController.text = (value+1).toString();
                                },
                                itemExtent: 32,
                                diameterRatio:1,
                                children: List.generate(100, (index) => Text("${index+1}일 마다")),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                    plantInfo != null ? Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: Text("추천: ${plantInfo["watering"]}",style: TextStyle(fontSize: 14,color: Color(0xff404040)),),
                    ) : Container(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('취소'),
                  onPressed: () {
                      Get.back();
                    },
                ),
                TextButton(
                  child: const Text('확인',style: TextStyle(color: Colors.red)),
                  onPressed: () async{
                    if(cycleController.text == "0"){
                      await showCupertinoDialog(context: context, builder: (context) {
                        return CupertinoAlertDialog(
                          content: Text("0보다 큰 값을 입력해주세요"),
                          actions: [
                            CupertinoDialogAction(isDefaultAction: true, child: Text("확인"), onPressed: () {
                              Navigator.pop(context);
                            })
                          ],
                        );
                      });
                    }else{
                      setState(() {
                        cycles[Cycles.startDate.name] = startDateController.text;
                        cycles[Cycles.initDate.name] = startDateController.text;
                        cycles[Cycles.cycle.name] = int.parse(cycleController.text);
                      });
                      Get.back();
                    }
                  },
                ),
              ],
            );
          });
        }
      },
    );
  }

}

int getFastWateringDate(Map cycles){
  for(int i = 0; DateFormat('yyyy-MM-dd').parse(cycles[Cycles.startDate.name]).add(Duration(days: i))
      .isBefore(DateTime(DateTime.now().year+1).subtract(Duration(days: 1))); i+= int.parse(cycles[Cycles.cycle.name].toString())){

    if(DateFormat('yyyy-MM-dd').parse(DateTime.now().toString()).isBefore( DateFormat('yyyy-MM-dd')
        .parse(cycles[Cycles.startDate.name]).add(Duration(days: i)))){

      return  DateFormat('yyyy-MM-dd').parse(cycles[Cycles.startDate.name]).add(Duration(days: i))
          .difference(DateFormat('yyyy-MM-dd').parse(DateTime.now().toString())).inDays;

    }

  }
  return 0;
}
