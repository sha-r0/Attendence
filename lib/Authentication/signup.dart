import 'package:attendence/Model/Models.dart';
import 'package:attendence/Authentication/login.dart';
import 'package:attendence/UiHelper/uihelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../BottomnavbarScreens/bottomnavbars.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasscontroler =TextEditingController();
  TextEditingController fulnamecontroler =TextEditingController();

  void checkvalues(){
    String email = emailcontroller.text.trim();
    String password = passwordcontroller.text.trim();
    String cnfpassword = confirmpasscontroler.text.trim();
    String fullname = fulnamecontroler.text.trim();

    if(email.isEmpty || password.isEmpty ||cnfpassword.isEmpty|| fullname.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
      Text('Enter Email and Password')));
    }else if(password != cnfpassword){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:  Text("password doesn't match")));
    }else{
      signup(email, password,fullname);
    }
  }

  void signup(String email,String password,String fullname)async{
    UserCredential? crendencial;

    try
    {
      crendencial = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch(ex){
      print(ex.code.toString());
    }

    if(crendencial != null){
      String uid = crendencial.user!.uid;
      Usermodel newuser = Usermodel(
        uid: uid,
        email: email,
        profilepic: "",
        fullname: fullname,
      );
      await FirebaseFirestore.instance.
      collection("EMPLOYEE").doc(uid).set(newuser.toMap()).then((value) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Bottomnavbars()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA855EB),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 50,),
            Align(
                alignment: Alignment.center,
                child: Icon(CupertinoIcons.scribble,size: 150,color: Colors.white,)),

            SizedBox(height: 40,),

                Text('Company Name',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                Text('Welcome Signup Here',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
                SizedBox(height: 40,),

                Uihelper().customtextfeild("Enter your name", fulnamecontroler, false, Icons.person),
                Uihelper().customtextfeild('Enter your Email', emailcontroller, false, Icons.mail),
                Uihelper().customtextfeild('Password', passwordcontroller, true, Icons.password),
                Uihelper().customtextfeild('Confirm Password', confirmpasscontroler, true, Icons.password),

                SizedBox(height: 30,),

                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(borderRadius: BorderRadius.zero)
                        )
                    ),
                    onPressed: (){
                      checkvalues();
                    }, child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('SignUp',
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Color(0xFFA855EB)),),
                )),

                SizedBox(height: 30,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("You Have An Account ?",style: TextStyle(color: Colors.white.withOpacity(0.4),fontSize: 17),),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                    }, child: Text('Log In',style: TextStyle(fontSize: 20,color: Colors.white),))
                  ],
                )
          ],
        ),
      ),
    );
  }
}
