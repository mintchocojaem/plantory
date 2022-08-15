import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:plantory/data/post.dart';
import '../../data/person.dart';
import '../../utils/colors.dart';

class PostAddPage extends StatefulWidget{

  const PostAddPage({Key? key, required this.person}) : super(key: key);

  final Person person;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PostAddPage();
  }

}

class _PostAddPage extends State<PostAddPage>{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();

  final _formKey = GlobalKey<FormState>();

  final ScrollController controller = ScrollController();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  Uint8List? image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Center(
                          child: image == null ? Container(height: MediaQuery.of(context).size.height * 0.08,) : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              child: Scrollbar(
                                  thickness: 5,
                                  radius: Radius.circular(10),
                                  controller: controller,
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                      controller: controller,
                                      child: Image.memory(image!, fit: BoxFit.cover,)
                                  )
                              )
                          )
                      ),
                      Form(
                        key: _formKey,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: titleController,
                                keyboardType: TextInputType.multiline,
                                maxLength: 50,
                                validator: (value){
                                  if (value.toString().isEmpty) {
                                    return '제목을 입력해주세요';
                                  }
                                },
                                decoration: InputDecoration(
                                  labelStyle: const TextStyle(height:0.1),
                                  labelText: "제목",
                                ),
                              ),
                              TextFormField(
                                controller: contentController,
                                keyboardType: TextInputType.multiline,
                                maxLength: 200,
                                maxLines: 5,
                                validator: (value){
                                  if (value.toString().isEmpty) {
                                    return '내용을 입력해주세요';
                                  }
                                },
                                decoration: InputDecoration(
                                  labelStyle: const TextStyle(height:0.1),
                                  labelText: "내용",
                                  alignLabelWithHint: true
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(height: MediaQuery.of(context).size.height * 0.08,
                color: Colors.white54,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black54,),
                      onPressed: () { Navigator.pop(context); },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: IconButton(
                          onPressed: () async{

                            if(_formKey.currentState!.validate()){
                              var boardCollection = firestore.collection('board');

                              String random = getRandomString(12);

                              var usersCollection = firestore.collection('users');
                              var userData = await usersCollection.doc(widget.person.uid).get().then((value) => value.data()!);

                              final imageRef = storageRef.child("boards/$random/image.text");

                              if((await boardCollection.doc(widget.person.uid).get()).exists){

                                if(image != null){
                                  await imageRef.putData(image!);
                                }

                                await boardCollection.doc(widget.person.uid).update(
                                    {
                                      random : Post(
                                        userPermission: userData["userPermission"],
                                        userName: userData["userName"],
                                        uid: widget.person.uid,
                                        id: random,
                                        image: image != null ? await imageRef.getDownloadURL() : null,
                                        date: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()),
                                        title: titleController.text,
                                        content: contentController.text,
                                        like: List.empty(growable: true),
                                        comments: List.empty(growable: true),
                                        theNumberOfComments: 0,
                                      ).toJson()
                                    }).then((value) => Get.back());
                              }else{
                                await boardCollection.doc(widget.person.uid).set(
                                    {
                                      random : Post(
                                        userPermission: userData["userPermission"],
                                        userName: userData["userName"],
                                        uid: widget.person.uid,
                                        id: random,
                                        image: image != null ? await imageRef.getDownloadURL() : null,
                                        //image: image != null ? base64Encode(image) : null,
                                        date: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()),
                                        title: titleController.text,
                                        content: contentController.text,
                                        like: List.empty(growable: true),
                                        comments: List.empty(growable: true),
                                        theNumberOfComments: 0,
                                      ).toJson()
                                    }).then((value) => Get.back());
                              }
                            }
                          },
                          icon: Icon(Icons.check, color: Colors.black54,)
                      ),
                    )
                  ],
                ),
              ),
            ],
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

}
