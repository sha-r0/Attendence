import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class Employee extends StatefulWidget {
  const Employee({super.key});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {

  User? currentuser = FirebaseAuth.instance.currentUser;

  String _month= DateFormat('MMMM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA855EB),
        title: Text('History',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              children:[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(_month,style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w600,color: Colors.grey.withOpacity(0.5)),),
                ),
                GestureDetector(
                  onTap: ()async{
                    final months = await showMonthYearPicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2099),
                    );

                    if(months != null){
                      setState(() {
                        _month = DateFormat('MMMM').format(months);
                      });
                    }


                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text("Pick a Month",style: TextStyle(fontSize: 20,
                        fontWeight: FontWeight.w600,color: Colors.grey.withOpacity(0.5)),),
                  ),
                ),
              ]
            ),
            SizedBox(height: 20,),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("EMPLOYEE")
                      .doc(currentuser!.uid)
                      .collection("RECORDS").snapshots(),
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot) {
                    if(snapshot.hasData){
                      final snap = snapshot.data!.docs;
                      return SingleChildScrollView(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snap.length,
                            itemBuilder: (context , index){
                            final Timestamp dateTimestamp = snap[index]['DATE'];
                            final DateTime date = dateTimestamp.toDate();
                            return
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child:
                                DateFormat('MMMM').format(date) == _month ?
                                Container(
                                  padding: EdgeInsets.only(right: 25),
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 20,
                                          offset: Offset(8, 8)
                                      )
                                    ]
                                ),
                                child:  Row(
                                  children: [
                                     Container(
                                          height: 150,
                                          width: 100,
                                          decoration:  BoxDecoration(
                                            color: Color(0xFFA855EB),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                              child: Text(DateFormat('EE\ndd').format(date),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                                              )
                                          ),
                                        )
                                    ,
                                    Expanded(
                                      child:  Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('Check In',style: TextStyle(fontSize: 20,
                                                fontWeight: FontWeight.w600,color: Colors.grey.withOpacity(0.8)),),

                                            Text(snap[index]['Check IN'],style: TextStyle(fontSize: 20,
                                                fontWeight: FontWeight.w600,color: Colors.black),),
                                          ],
                                        ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Check Out',style: TextStyle(fontSize: 20,
                                            fontWeight: FontWeight.w600,color: Colors.grey.withOpacity(0.8)),),
                                        Text(snap[index]['Check OUT'],style: TextStyle(fontSize: 20,
                                            fontWeight: FontWeight.w600,color: Colors.black),)
                                      ],
                                    )
                                  ],
                                ),
                                ): SizedBox()
                              );
                            },
                            ),
                      );

                    }else{
                      return SizedBox();
                    }

                  }

            ),
            )
          ],
        ),
      ),
    );
  }
}
