import 'package:attendence/Model/Models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Firebasehelper {

 static Future<Usermodel?> getusermodelbyid(String uid)async {
    Usermodel? usermodel;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore
        .instance.collection("EMPLOYEE").doc(uid).get();
    if(usermodel != null){
      usermodel = Usermodel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    }

  return usermodel;
  }

}