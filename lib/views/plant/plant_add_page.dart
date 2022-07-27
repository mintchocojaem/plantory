import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unicons/unicons.dart';
import '../../../data/plant.dart';
import '../../../utils/colors.dart';
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
      "id" : 0,
      "type" : "물",
      "cycle" : "14",
      "startDate" : DateFormat('yyyy-MM-dd').format(DateTime.now()),
    },
    {
      "id" : 1,
      "type" : "분갈이",
      "cycle" : "60",
      "startDate" : DateFormat('yyyy-MM-dd').format(DateTime.now()),
    },
  ];

  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final TextEditingController wateringStartDateController = TextEditingController();
  final TextEditingController wateringCycleController = TextEditingController();

  final TextEditingController repottingStartDateController = TextEditingController();
  final TextEditingController repottingCycleController = TextEditingController();


  @override
  initState(){

    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    wateringStartDateController.text = cycles[0]["startDate"];
    wateringCycleController.text = cycles[0]["cycle"];

    repottingStartDateController.text = cycles[1]["startDate"];
    repottingCycleController.text = cycles[1]["cycle"];


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
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: IconButton(
                onPressed: (){

                },
                icon: Icon(Icons.check, color: Colors.black54,)),
          )
        ],
        centerTitle: true,
        backgroundColor: Color(0xffEEF1F1),
        title: const Text(
          "식물 추가",
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          ClipOval(child: Image.asset('images/plant1.jpeg',width: 128,height: 128,)),
                        ],
                      )
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
                    label: '종',
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
                        child: cycleTile(cycles,0,wateringStartDateController,wateringCycleController)
                      ),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: cycleTile(cycles,1,repottingStartDateController,repottingCycleController)
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget cycleTile(List cycles,int index , TextEditingController startDateController, TextEditingController cycleController){

    return ListTile(
      leading: Icon(index == 0 ? Icons.water_drop : UniconsLine.shovel),
      title: Text(cycles[index]["type"]),
      subtitle: Text(cycles[index]["cycle"]+"일"),
      trailing: Text(
          "${(((DateTime.now().difference(DateFormat('yyyy-MM-dd').parse(cycles[index]["startDate"])).inHours) < 0 ? 0 :
          (DateTime.now().difference(DateFormat('yyyy-MM-dd').parse(cycles[index]["startDate"])).inHours)
              / (int.parse(cycles[index]["cycle"])*24)) * 100 %100).round()}%"
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black38, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      onTap: (){

        showCupertinoDialog(context: context, builder: (context) {
          return AlertDialog(
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
                        hintText:  cycles[index]["startDate"],
                      ),
                      onTap: () async{
                        startDateController.text = await showDatePicker(
                            context: context,
                            initialDate: DateFormat('yyyy-MM-dd').parse(cycles[index]["startDate"]), //초기값
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
                        hintText:  cycles[index]["cycle"],
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
                      cycles[index]["startDate"] = startDateController.text;
                      cycles[index]["cycle"] = cycleController.text;
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
                        cycleController.text = cycles[index]["cycle"];
                      });
                    }
                  });
                },
              ),
            ],
          );
        });
      },
      onLongPress: (){

      },
    );
  }

}
