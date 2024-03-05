import 'package:attendence/Model/Models.dart';
import 'package:attendence/Authentication/signup.dart';
import 'package:attendence/UiHelper/uihelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../BottomnavbarScreens/bottomnavbars.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  checkvalue(){
    String email = emailcontroller.text.trim();
    String password = passwordcontroller.text.trim();

    if(email.isEmpty || password.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
      Text('Enter Email and Password')));
    }else{
     login(email, password);
    }
  }

  login(String email,String password)async{
    UserCredential? credential;

    try{
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password).then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context)=>Bottomnavbars()));
      });
    } on FirebaseAuthException catch(ex){
      print(ex.code.toString());
    }

    if(credential != null){
      String uid = credential.user!.uid;

      DocumentSnapshot userdata = await FirebaseFirestore.instance
          .collection("EMPLOYEE").doc(uid).get();
      Usermodel usermodel = Usermodel.fromMap(userdata.data()as Map<String , dynamic>);
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
                child: Icon(CupertinoIcons.scribble,size: 250,color: Colors.white,)),

            SizedBox(height: 40,),

                Text('Company Name',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                Text('Welcome Login Here',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
                SizedBox(height: 40,),

                Uihelper().customtextfeild('Enter your Email', emailcontroller, false, Icons.mail),
                Uihelper().customtextfeild('Password', passwordcontroller, true, Icons.password),

                SizedBox(height: 30,),

                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(borderRadius: BorderRadius.zero)
                        )
                    ),
                    onPressed: (){
                      checkvalue();
                    }, child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Login',
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Color(0xFFA855EB)),),
                )),

                SizedBox(height: 30,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("You Don't Have An Account ?",style: TextStyle(color: Colors.white.withOpacity(0.4),fontSize: 17),),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Signup()));
                    }, child: Text('Sign Up',style: TextStyle(fontSize: 20,color: Colors.white),))
                  ],
                ),
          ],
        ),
      ),
    );
  }
}



