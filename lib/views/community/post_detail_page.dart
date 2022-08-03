import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:unicons/unicons.dart';
import '../../../data/plant.dart';
import '../../../utils/colors.dart';

class PostDetailPage extends StatefulWidget{

  const PostDetailPage({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PostDetailPage();
  }

}

class _PostDetailPage extends State<PostDetailPage>{

  //FirebaseFirestore firestore = FirebaseFirestore.instance;

  //late DocumentSnapshot<Map<String,dynamic>> boardData;
  var boardData;

  @override
  Widget build(BuildContext context) {

    return Builder(
      builder: (context) {
        return Scaffold(
          backgroundColor: Color(0xffEEF1F1),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black54,),
              onPressed: () { Navigator.pop(context); },
            ),
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xffEEF1F1),
            title: const Text(
              "Post",
              style: TextStyle(color: primaryColor),
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                      child: Center(
                        child: FutureBuilder(
                            future: getBoardData(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if(snapshot.hasData == false){
                                return CircularProgressIndicator();
                              }else if(snapshot.hasError){
                                return Container();
                              }else{
                                return Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 12,left: 12,bottom: 12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                                            title: Text("User",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04)),
                                            subtitle: Text("2022/08/03",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035),),
                                            leading: Container(
                                                width: MediaQuery.of(context).size.width * 0.1,
                                                height: MediaQuery.of(context).size.width * 0.1,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.black54,
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.1))
                                                ),
                                                child: Icon(Icons.person,size: MediaQuery.of(context).size.width * 0.06,)
                                            ),
                                          ),
                                          Text("이파리가 시들시들해요 어떻게 하죠?",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035)),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: 1,
                                      itemBuilder: (context, index){
                                        return Container(
                                          margin: EdgeInsets.only(right: 12,left: 12,bottom: 12),
                                          child: Column(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      ListTile(
                                                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                                        dense: true,
                                                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                                        title: Text("User",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035)),
                                                        leading: Container(
                                                            width: MediaQuery.of(context).size.width * 0.08,
                                                            height: MediaQuery.of(context).size.width * 0.08,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  color: Colors.black54,
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.08))
                                                            ),
                                                            child: Icon(Icons.person,size: MediaQuery.of(context).size.width * 0.05,)
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: Container(
                                                            width: MediaQuery.of(context).size.width * 0.25,
                                                            height: MediaQuery.of(context).size.height * 0.04,
                                                            decoration: new BoxDecoration(
                                                                borderRadius: BorderRadius.all(Radius.circular(100))
                                                            ),
                                                            padding: EdgeInsets.all(8),
                                                            child: IntrinsicHeight(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Icon(Icons.thumb_up,size: MediaQuery.of(context).size.width * 0.04,),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 8, left: 8),
                                                                    child: VerticalDivider(
                                                                      color: Colors.black45,
                                                                      thickness: 1,
                                                                    ),
                                                                  ),
                                                                  Icon(Icons.comment_rounded,size: MediaQuery.of(context).size.width * 0.04,),
                                                                ],
                                                              ),
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4,bottom: 4),
                                                    child: Text("영양제는 주셨나요?",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035)),
                                                  ),
                                                  Text("2022/08/03",style: TextStyle(color: Colors.black54, fontSize: MediaQuery.of(context).size.width * 0.035),)
                                                ],
                                              ),
                                              ListView.builder(
                                                physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: 1,
                                                itemBuilder: (context, index) {
                                                  return Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          margin: EdgeInsets.only(top: 24),
                                                          child: Icon(Icons.subdirectory_arrow_right_outlined,color: Colors.black45,)
                                                      ),
                                                      Flexible(
                                                        child: Container(
                                                          decoration: new BoxDecoration(
                                                              color: Color(0xffC9D9CF),
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),),
                                                          padding: EdgeInsets.only(right: 16,left: 16,top: 8,bottom: 8),
                                                          margin: EdgeInsets.only(left: 12, top: 12),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Stack(
                                                                children: [
                                                                  ListTile(
                                                                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                                                    dense: true,
                                                                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                                                    title: Text("User",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035)),
                                                                    leading: Container(
                                                                        width: MediaQuery.of(context).size.width * 0.08,
                                                                        height: MediaQuery.of(context).size.width * 0.08,
                                                                        decoration: BoxDecoration(
                                                                            border: Border.all(
                                                                              color: Colors.black54,
                                                                            ),
                                                                            borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.08))
                                                                        ),
                                                                        child: Icon(Icons.person,size: MediaQuery.of(context).size.width * 0.05,)
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    top: 0,
                                                                    right: 0,
                                                                    child: Container(
                                                                        width: MediaQuery.of(context).size.width * 0.1,
                                                                        height: MediaQuery.of(context).size.height * 0.04,
                                                                        decoration: new BoxDecoration(
                                                                            borderRadius: BorderRadius.all(Radius.circular(100)),
                                                                            color: Colors.white54
                                                                        ),
                                                                        padding: EdgeInsets.all(8),
                                                                        child: IntrinsicHeight(
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(Icons.thumb_up,size: MediaQuery.of(context).size.width * 0.04,),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                  )
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 4,bottom: 4),
                                                                child: Text("오늘 줬어요 ㅠㅠ",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035)),
                                                              ),
                                                              Text("2022/08/03",style: TextStyle(color: Colors.black54, fontSize: MediaQuery.of(context).size.width * 0.035),)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              ),
                                              Divider(),
                                            ],
                                          ),
                                        );
                                    })
                                  ],
                                );
                              }
                            }
                        ),
                      ),
                    )
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Color(0xffC9D9CF),
                          padding:  EdgeInsets.all(16),
                          child: TextFormField(
                            autocorrect: false,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xffEEF1F1),
                              contentPadding: EdgeInsets.symmetric(vertical: -4.0,horizontal: 16),
                              hintText: "댓글을 입력하세요.",
                              suffixIcon: IconButton(
                                icon: Icon(Icons.send_rounded),
                                color: primaryColor,
                                iconSize: 20.0,
                                onPressed: (){},
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffEEF1F1), width: 1.0),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              focusedBorder:OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffEEF1F1), width: 1.0),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        )
                    )
                ),
              ],
            ),
          ),

        );
      }
    );
  }

  getBoardData() async{
    //return boardData = await firestore.collection('board').doc("first").get();
    return true;
  }




}
