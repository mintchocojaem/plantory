import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plantory/views/plant/input_field.dart';

import '../../utils/colors.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SettingPage();
  }
}

class _SettingPage extends State<SettingPage>{

  final TextEditingController nameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  initState() {
    nameController.text = "User";
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
                  ClipOval(
                    child: Image.asset(
                      'images/user1.jpeg',
                      fit: BoxFit.fill,
                      width: 128,
                      height: 128,
                    ),
                  ),
                  Stack(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.4,
                            maxWidth: MediaQuery.of(context).size.width * 0.6),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24),
                          child: IntrinsicWidth(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                onFieldSubmitted: (value){
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                  }
                                },
                                validator: (value){
                                  if(value!.isEmpty){
                                    nameController.text = "User";
                                    return null;
                                  }else{
                                    return null;
                                  }
                                },
                                textAlign: TextAlign.center,
                                controller: nameController,
                                decoration: InputDecoration(
                                  hintText: nameController.text,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(top: 10,right:  0, child: Icon(Icons.edit,size: 24,)),
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
