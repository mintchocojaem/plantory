import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantory/controller/bottom_nav_controller.dart';

import '../../data/person.dart';
import '../../utils/colors.dart';

class SettingPage extends StatefulWidget {

  SettingPage({Key? key, required this.person}) : super(key: key);

  final Person person;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SettingPage();
  }
}

class _SettingPage extends State<SettingPage>{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  String name = "User";
  bool editName = false;
  var image;
  FocusNode focusNode = FocusNode();

  @override
  initState() {
    nameController.text = widget.person.userName!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xffEEF1F1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Color(0xffEEF1F1),
        title: const Text(
          "Settings",
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: GestureDetector(
                        child:  Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black54,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.3))
                            ),
                            child: Icon(Icons.person_outline_rounded,size: MediaQuery.of(context).size.width * 0.1,)
                        )
                      )
                  ),
                  Stack(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.4,
                            maxWidth: MediaQuery.of(context).size.width * 0.6),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24),
                          child: IntrinsicWidth(
                            child: TextFormField(
                              focusNode: focusNode,
                              readOnly: !editName,
                              textAlign: TextAlign.center,
                              controller: nameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: name,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 0,
                          right:  0,
                          child: IconButton(
                              icon: editName == false ? Icon(Icons.mode_edit_outlined,size: 24,) : Icon(Icons.check_outlined),
                              onPressed: () async{
                                  if(nameController.text.isNotEmpty) {
                                    setState((){
                                      editName = !editName;
                                      name = nameController.text;
                                      if(editName) focusNode.requestFocus();
                                    });
                                    var usersCollection = firestore.collection('users');
                                    await usersCollection.doc(widget.person.uid).update(
                                        {
                                          "userName": nameController.text
                                        }).whenComplete(() {
                                          print("user name Changed");
                                          widget.person.userName = name;
                                    });
                                  }else{
                                    setState(() {
                                      nameController.text = name;
                                      nameController.selection = TextSelection(
                                          extentOffset: nameController.text.length,
                                          baseOffset: nameController.text.length);
                                      if(editName) focusNode.requestFocus();
                                    });
                                  }
                              },
                          )
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 5),
                        child: ListView(
                          children: [
                            Divider(thickness: 1,),
                            ListTile(
                              title: Text("알림"),
                              leading: Icon(Icons.notifications_none_outlined),
                              trailing: Icon(Icons.arrow_forward_ios_rounded),
                            ),
                            Divider(thickness: 1,),
                            ListTile(
                              title: Text("Help and Suppport"),
                              leading: Icon(Icons.support_agent_outlined),
                              trailing: Icon(Icons.arrow_forward_ios_rounded),
                            ),
                            Divider(thickness: 1,),
                            ListTile(
                              title: Text("로그아웃"),
                              leading: Icon(Icons.logout),
                              trailing: Icon(Icons.arrow_forward_ios_rounded),
                              onTap: (){
                                FirebaseAuth.instance.signOut();
                              },
                            ),
                            Divider(thickness: 1,),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
