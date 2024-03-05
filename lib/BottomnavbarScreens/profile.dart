import 'package:attendence/Authentication/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA855EB),
        title: Text('Profile',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body:Center(
        child: Container(
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFA855EB)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(borderRadius: BorderRadius.zero)
                  )
              ),
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
              }, child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Log Out',
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
          )),
        ),
      )

    );

  }
}
