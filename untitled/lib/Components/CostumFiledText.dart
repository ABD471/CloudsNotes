import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Costumfiledtext extends StatelessWidget {
  
 // final double cursorHeight;
  final String hintText;
  final TextEditingController Mycontroller;
  final String? Function(String?) validator;
  
  const Costumfiledtext({  required this.hintText, required this.Mycontroller,required this.validator,});

  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      validator:validator ,
      controller: Mycontroller,
      decoration: InputDecoration(
        hintText: hintText,
      //  filled: true,
        //fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
