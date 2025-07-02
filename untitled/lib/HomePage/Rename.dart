// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/Components/CostumBottun.dart';

import 'package:untitled/Components/CostumFiledText.dart';

import '../Getx/Controller.dart' show HomePageController;

class Rename_Category extends StatefulWidget {
  final String Iddoc;
  final OldName;

  const Rename_Category({Key? key, required this.Iddoc, required this.OldName})
    : super(key: key);

  @override
  State<Rename_Category> createState() {
    return _Rename();
  }
}

class _Rename extends State<Rename_Category> {
  late TextEditingController Rename;
  CollectionReference Category = FirebaseFirestore.instance.collection(
    'Category',
  );
  late HomePageController homePageController;

  @override
  void initState() {
    Rename = TextEditingController();
    Rename.text = widget.OldName;
    homePageController = Get.find();
    super.initState();
  }
  @override
  void dispose() {
    Rename.dispose();
    homePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rename Category".tr, style: TextStyle(color: Colors.orange)),
      
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Costumfiledtext(
              Mycontroller: Rename,
              hintText: widget.OldName,
              validator: (val) {
                return null;
              },
            ),
            CostumBottoun(
              Title: "Rename".tr,
              onPressed: () {
                homePageController.updateCategory(widget.Iddoc, Rename);
                Get.snackbar(
                  "Success".tr,
                  "Item Renamed Successfully!".tr,
                  animationDuration: Duration(seconds: 1),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
