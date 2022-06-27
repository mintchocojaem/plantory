// ignore_for_file: prefer_const_constructors

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import '../../utils/colors.dart';
import '../../utils/widgets.dart';


class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: notificationIcon(context: context),
              ),
            ),
            decoration: BoxDecoration(
                //image: DecorationImage(image: AssetImage("images/1.png"))
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height : MediaQuery.of(context).size.height / 3.5,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  //color: Colors.black12
              ),
              child: Center(
                child: ImageSlideshow(
                  width: double.infinity,
                  height: 200,
                  initialPage: 0,
                  indicatorColor: Colors.blue,
                  indicatorBackgroundColor: Colors.grey,
                  onPageChanged: (value) {
                    debugPrint('Page changed: $value');
                  },
                  autoPlayInterval: 5000,
                  isLoop: true,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'images/slide_image1.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'images/slide_image2.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'images/slide_image3.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black12
              ),
              child: Center(child: Text("뭐 넣을지 고민중", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),)),
            ),
          ),
          Divider(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          /*
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child:

              DatePicker(
                DateTime.now(),
                monthTextStyle: TextStyle(),
                initialSelectedDate: DateTime.now(),
              ),
          ),
          */
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('My Plants', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),)
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            // height: 250,
            height: MediaQuery.of(context).size.height * 0.2,
            width: double.infinity,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => plantCard(
                    imgPath: 'images/plant${index+1}.jpeg',
                    context: context,
                    //color: Color(0xff94B49F)
                ),
                separatorBuilder: (context, index) => SizedBox(
                  width: 15,
                ),
                itemCount: 4),
          )
          // Text("hjvsdbvjjsdf"),
        ],
      ),
    );
  }
}
