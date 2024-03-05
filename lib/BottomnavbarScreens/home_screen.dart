import 'dart:async';

import 'package:attendence/Model/Models.dart';
import 'package:attendence/FirebaseFiles/firebasehelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{

  User? currentuser = FirebaseAuth.instance.currentUser;

  String checkIn = "---/---";
  String checkOut = "---/---";

  String Name = "";

  @override
  void initState() {
    super.initState();
    getRecords();
    getname();
  }

  ///////////////// get Name method ////////////////
  getname()async{
    DocumentSnapshot snap3 = await FirebaseFirestore.instance
        .collection("EMPLOYEE")
        .doc(currentuser!.uid)
        .get();
    setState(() {
      Name = snap3['fullname'];
    });
  }
  ///////////////// get Name method ////////////////

  ///////////////// get user data method ////////////////
  getRecords()async{

    try{
      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("EMPLOYEE")
          .doc(currentuser!.uid).collection("RECORDS")
          .doc(DateFormat('dd-MM-yyyy').format(DateTime.now()))
          .get();

      setState(() {
        checkIn = snap2['Check IN'];
        checkOut =snap2['Check OUT'];
      });

    } catch(e){
      setState(() {
        checkIn =  "---/---";
        checkOut =  "---/---";
      });
    }

  }
  ///////////////// get user data method ////////////////

  //////////////// get location method //////////////////
  String city = "";
  String locality = "";
  String street = "";

  getcurrentlocation() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied ||
        locationPermission == LocationPermission.deniedForever) {
      print("Location denied");
      LocationPermission ask = await Geolocator.requestPermission();
    } else {
      try {
        Position currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        double latitude = currentPosition.latitude;
        double longitude = currentPosition.longitude;

        List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
        Placemark place = placemarks[0];
        setState(() {
          street = place.street!;
          locality = place.subLocality!;
          city = place.locality!;
        });
        String address =
            '$street, $locality, $city';

        FocusManager.instance.primaryFocus?.unfocus();
        var whatsappUrl =
            "whatsapp://send?phone=${918178136076}"+
                "&text=${Uri.encodeComponent(address)}";
        print("WhatsApp URL: $whatsappUrl");
        await launch(whatsappUrl);
      } catch (e) {
        print("Error launching WhatsApp: $e");
      }
    }
  }
  //////////////// get location method //////////////////



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text('Welcome !',style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w600,color: Color(0xFFA855EB).withOpacity(0.8)),),
                ),

                Container(
                  child: Text(Name,style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w600,color: Colors.black),),
                ),

                SizedBox(height: 20,),

                Container(
                  child: Text("Today's Status",style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w600,color: Colors.black),),
                ),

                SizedBox(height: 30,),

                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color:Color(0xFFA855EB).withOpacity(0.4),
                          blurRadius: 20,
                          offset: Offset(8, 8)
                      )
                    ]
                  ),
                  child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Check In',style: TextStyle(fontSize: 20,
                              fontWeight: FontWeight.w600,color: Colors.grey.withOpacity(0.8)),),

                             Text(checkIn,style: TextStyle(fontSize: 20,
                                 fontWeight: FontWeight.w600,color: Colors.black),),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Check Out',style: TextStyle(fontSize: 20,
                                fontWeight: FontWeight.w600,color: Colors.grey.withOpacity(0.8)),),
                            Text(checkOut,style: TextStyle(fontSize: 20,
                                fontWeight: FontWeight.w600,color: Colors.black),)
                          ],
                        )
                      ],
                    ),
                  ),


                SizedBox(height: 30,),

                Container(
                  child: Text(DateTime.now().day.toString()+DateFormat(' MMMM yyyy').format(DateTime.now())
                    ,style: TextStyle(fontSize: 23,
                      fontWeight: FontWeight.w600,color: Colors.black),),
                ),

                StreamBuilder(
                  stream: Stream.periodic(Duration(seconds: 1)),
                  builder : (context,snapshot) {
                    return Container(
                      child: Text(
                        DateFormat('hh:mm:ss a').format(DateTime.now()),
                        style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.w600, color: Colors.grey
                                .withOpacity(0.8)),),
                    );
                  }
                ),

                SizedBox(height: 30,),

                checkOut == "---/---" ?
                Container(
                  margin: EdgeInsets.only(left: 20,right: 20),
                  child: Builder(builder: (context){
                    final GlobalKey<SlideActionState> key = GlobalKey();
                    return SlideAction(
                      outerColor: Colors.white,
                      innerColor:Color(0xFFA855EB),
                      key: key,
                      onSubmit: ()async{

                        getcurrentlocation();

                        DocumentSnapshot snap2 = await FirebaseFirestore.instance
                            .collection("EMPLOYEE")
                            .doc(currentuser!.uid).collection("RECORDS")
                            .doc(DateFormat('dd-MM-yyyy').format(DateTime.now()))
                            .get();

                        try{
                          String checkIn = snap2['Check IN'];
                          setState(() {
                            checkOut = DateFormat('hh:mm\na').format(DateTime.now());
                          });
                          await FirebaseFirestore.instance
                              .collection("EMPLOYEE")
                              .doc(currentuser!.uid).collection("RECORDS")
                              .doc(DateFormat('dd-MM-yyyy').format(DateTime.now()))
                              .update({
                                'DATE' : Timestamp.now(),
                                'Check IN' : checkIn,
                                'Check OUT' : DateFormat('hh:mm\na').format(DateTime.now())
                              });
                        } catch(e){
                          setState(() {
                            checkIn = DateFormat('hh:mm\na').format(DateTime.now());
                          });

                          await FirebaseFirestore.instance
                              .collection("EMPLOYEE")
                              .doc(currentuser!.uid).collection("RECORDS")
                              .doc(DateFormat('dd-MM-yyyy').format(DateTime.now())).set(
                              {
                                'DATE' : Timestamp.now(),
                                'Check IN' : DateFormat('hh:mm\na').format(DateTime.now()),
                                'Check OUT' : "---/---"
                              });
                        }
                        key.currentState?.reset();
                       },

                      child:
                      Text(checkIn == "---/---" ? "Slide to Check In" : "Slide to Check Out",style:
                      TextStyle(fontSize: 20,color: Colors.black.withOpacity(0.8),fontWeight: FontWeight.w600),),
                    );
                  }),
                ) :
                Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: Text('you have completed this day !',style: TextStyle(fontSize: 25,
                      fontWeight: FontWeight.w600,color: Color(0xFFA855EB).withOpacity(0.4))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
