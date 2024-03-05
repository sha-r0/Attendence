import 'package:attendence/BottomnavbarScreens/profile.dart';
import 'package:attendence/BottomnavbarScreens/salarycount.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/Models.dart';
import 'employeeattendhistory.dart';
import 'home_screen.dart';

/////////////// bottom nav bar ///////////////////
class Bottomnavbars extends StatefulWidget {
  const Bottomnavbars({super.key});

  @override
  State<Bottomnavbars> createState() => _BottomnavbarsState();
}

class _BottomnavbarsState extends State<Bottomnavbars> {

  int currentindex = 0;
  List screens = [
    new Home(),
    new Employee(),
    new Salary(),
    new Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentindex],
      bottomNavigationBar:
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  offset: Offset(8, 20)
              )
            ]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
              showSelectedLabels: false,
              backgroundColor: Colors.white,
              selectedItemColor: Color(0xFFA855EB),
              unselectedItemColor: Colors.black54,
              onTap: (index){
                setState(() {
                  currentindex = index;
                });
              },
              currentIndex: currentindex ,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.calendar_month),label: 'Calender'),
                BottomNavigationBarItem(icon: Icon(Icons.calculate),label: 'count'),
                BottomNavigationBarItem(icon: Icon(Icons.person),label: 'profile'),

              ]),
        ),
      ),
    );
  }
}
/////////////// bottom nav bar ///////////////////