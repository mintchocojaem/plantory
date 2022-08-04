import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
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

  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  var image;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xffEEF1F1),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffEEF1F1),
        title: const Text(
          "Add Post",
          style: TextStyle(color: primaryColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black54,),
          onPressed: () { Navigator.pop(context); },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: IconButton(
                onPressed: () async{
                  if(_formKey.currentState!.validate()){
                    var usersCollection = firestore.collection('board');
                    String random = getRandomString(12);
                    DocumentSnapshot userData = await usersCollection.doc(widget.person.uid).get();
                    if(userData.exists){
                      await usersCollection.doc(widget.person.uid).update(
                          {
                            random : Post(
                              uid: widget.person.uid,
                              id: random,
                              image: image != null ? base64Encode(image) : null,
                              date: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()),
                              title: titleController.text,
                              content: contentController.text,
                              like: List.empty(growable: true),
                              comments: List.empty(growable: true),
                            ).toJson()
                          }).then((value) => Get.back());
                    }else{
                      await usersCollection.doc(widget.person.uid).set(
                          {
                            random : Post(
                              uid: widget.person.uid,
                              id: random,
                              image: image != null ? base64Encode(image) : null,
                              date: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()),
                              title: titleController.text,
                              content: contentController.text,
                              like: List.empty(growable: true),
                              comments: List.empty(growable: true),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: GestureDetector(
                            child: image == null ? Container() : Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.width * 0.6,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: Image.memory(image, fit: BoxFit.cover,).image,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.1))
                              ),
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
                                  setState(() {});
                                }
                              });
                            },
                          )
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: titleController,
                        keyboardType: TextInputType.multiline,
                        maxLength: 20,
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
              setState(() {});
            }
          });
        },
        heroTag: null,
        child: Icon(Icons.camera_alt_outlined,),backgroundColor: primaryColor,),
    );
  }

}
