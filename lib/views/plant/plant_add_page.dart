
import 'package:flutter/material.dart';

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

  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController cycleController = TextEditingController();

  @override
  initState(){
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
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
                            data: ThemeData.dark(), //다크 테마
                            child: child!,
                          );
                        },
                      ).then((value) => DateFormat('yyyy-MM-dd').format(value ?? DateFormat().parse(dateController.text)));
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
