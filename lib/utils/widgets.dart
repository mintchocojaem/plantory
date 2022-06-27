import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import '../views/home/Notifications/notification.dart';
import 'colors.dart';

//this is a reusable common button function in all screens.
MaterialButton reUsableButton(
    {required String text,
    // required  onpress
    required void Function()? onPressed}) {
  return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      color: primaryColor,
      onPressed: onPressed,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ));
}

///Resuable textfields

TextField authTextField(
    {String? labelText,
    bool isVisible = false,
    IconData? prefixIcon,
    Function()? onPressed,
    IconData? obsecureIcon}) {
  return TextField(
    textAlign: TextAlign.center,
    obscureText: isVisible,
    decoration: InputDecoration(
        hintText: labelText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon:
            GestureDetector(onTap: onPressed, child: Icon(obsecureIcon)),
        contentPadding: const EdgeInsets.all(10),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15))),
  );
}

////////HomeView flower card function builder

plantCard({String? name, String? imgPath,Color? color, required BuildContext context}) {
  return SizedBox(
    // height: MediaQuery.of(context!).size.height * 0.020,
    width: 150,
    child: Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.23,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.height * 0.08,
                  backgroundColor: navBarColor,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Center(
                      child: imgPath == null ? const Icon(
                        UniconsLine.flower,
                        size: 40,
                        color: primaryColor,
                      ) : Image.asset(
                          imgPath,
                          fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Text(name ?? "Plant Name", style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        )
      ],
    ),
  );
}

///Notification Icon
Stack notificationIcon({BuildContext? context}) {
  return Stack(
    children: [
      Container(
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: IconButton(
            onPressed: () {
              Navigator.push(context!,
                  MaterialPageRoute(builder: (context) => Notifications()));
            },
            icon: const Icon(Icons.notifications_none)),
      ),
      const Positioned(
        left: 30,
        top: 30,
        child: CircleAvatar(
          radius: 5,
          backgroundColor: Colors.red,
        ),
      )
    ],
  );
}

TextField searcTextField({
  String? labelText,
  IconData? prefixIcon,
}) {
  return TextField(
    decoration: InputDecoration(
        hintText: labelText,
        prefixIcon: Icon(prefixIcon),
        contentPadding: const EdgeInsets.all(10),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20))),
  );
}
