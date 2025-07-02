import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/Components/CostumBottun.dart';
import 'package:untitled/Components/loading.dart';
import 'package:untitled/Getx/Controller.dart';
import 'package:untitled/HomePage/HomePage.dart';
import 'package:untitled/main.dart';
import '../Components/CostumFiledText.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Add_Category extends StatefulWidget {
  @override
  State<Add_Category> createState() {
    return _Add_Notes();
  }
}

class _Add_Notes extends State<Add_Category> {
  late TextEditingController Catargy;
  late HomePageController homePageController;
  CollectionReference Category = FirebaseFirestore.instance.collection(
    'Category',
  );
  bool isLoading = false;

  @override
  void initState() {
    Catargy = TextEditingController();
    homePageController = Get.put(HomePageController());
    super.initState();
  }

  @override
  void dispose() {
    Catargy.dispose();
    homePageController.dispose();
    super.dispose();
  }

  Future<void> addCategory() {
    // Call the user's CollectionReference to add a new user
    return Category.add({
          "name": Catargy.text,
          "id": FirebaseAuth.instance.currentUser!.uid,
        })
        .then((value) {
          isLoading = false;
          setState(() {});
          return Get.offAll(HomePage());
        })
        .catchError((error) => Get.snackbar("Error", "$error"));
  }

  @override
  Widget build(BuildContext context) {
    //shared?.clear();
    print(shared?.getString("language"));
    print(shared?.getBool("Dark"));
    print("object");
    return Scaffold(
      appBar: AppBar(title: Text("addCategory".tr)),
      body:
          isLoading == true
              ? loading()
              : Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Costumfiledtext(
                      Mycontroller: Catargy,
                      hintText: "addCategory".tr,
                      validator: (val) {
                        if(val!.isEmpty)
                        {
                          return "filed is Empty".tr;
                        }
                        return null;
                      },
                    ),
                    CostumBottoun(
                      Title: "Add".tr,
                      onPressed: () {
                        if(!Catargy.text.isEmpty){
                        isLoading = true;

                        homePageController.addCategory(Catargy);
                        }
                       
                      },
                    ),
                  ],
                ),
              ),
    );
  }
}
