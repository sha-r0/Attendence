import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Uihelper{
  customtextfeild(String hint,TextEditingController controller,bool obscure,IconData icon){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(width: 2,color: Colors.white),
        ),
        child: Row(
          children: [
            Icon(icon,color: Colors.white,),
            SizedBox(width: 20),
            Expanded(
              child: TextField(
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                controller: controller,
                obscureText: obscure,
                decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}