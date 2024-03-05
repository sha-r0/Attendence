import 'package:attendence/BottomnavbarScreens/employeeattendhistory.dart';
import 'package:attendence/FirebaseFiles/firebase_options.dart';
import 'package:attendence/BottomnavbarScreens/home_screen.dart';
import 'package:attendence/Authentication/login.dart';
import 'package:attendence/BottomnavbarScreens/profile.dart';
import 'package:attendence/BottomnavbarScreens/salarycount.dart';
import 'package:attendence/Authentication/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'Model/Models.dart';
import 'BottomnavbarScreens/bottomnavbars.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  User? currentuser = FirebaseAuth.instance.currentUser;
  if(currentuser != null){
    runApp(MyAppLoggedin());
  }else{
    runApp(const MyApp());
  }

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
      ],
      home: Login(),
    );
  }
}



class MyAppLoggedin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
      ],
      home: Bottomnavbars(
      ),

    );
  }
}


