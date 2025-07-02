import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:untitled/main.dart';

class HomePageController extends GetxController {
  var data = <QueryDocumentSnapshot>[].obs;
  CollectionReference Category = FirebaseFirestore.instance.collection(
    'Category',
  );
  var isLoading = true.obs;
  getData() async {
    isLoading.value = true;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance
            .collection("Category")
            .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();
    data.assignAll(querySnapshot.docs);
    isLoading.value = false;
  }

  DeleteData(String Iddoc) async {
    await FirebaseFirestore.instance.collection("Category").doc(Iddoc).delete();
    data.removeWhere((Element) => Element.id == Iddoc);
    Get.snackbar("Success".tr, "Item Deleted Successfully!".tr);
  }

  Future<void> addCategory(TextEditingController Catargy) {
    // Call the user's CollectionReference to add a new user
    return Category.add({
          "name": Catargy.text,
          "id": FirebaseAuth.instance.currentUser!.uid,
        })
        .then((value) {
          isLoading.value = false;
          data.refresh();
          return Get.offAllNamed("/HomePage");
        })
        .catchError((error) => print("Failed to add user: $error"));
  }

  void updateCategory(String iddoc, TextEditingController Rename) async {
    await Category.doc(iddoc).update({"name": Rename.text});

    data.refresh();
    Get.offAllNamed("/HomePage");
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
class SingUpController extends GetxController {
  var isloading = false.obs;
}

class ViewNotesController extends GetxController {
  var data = <QueryDocumentSnapshot>[].obs;
  var isLoading = false.obs;
  var idDoc = "".obs;

  CollectionReference Category = FirebaseFirestore.instance.collection(
    'Category',
  );
  getData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    print("UID المستخدم: $uid");
    isLoading.value = true;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance
            .collection("Category")
            .doc(idDoc.value)
            .collection("Note")
            .get();

    data.assignAll(querySnapshot.docs);
    print(querySnapshot.docs.length);

    isLoading.value = false;
  }

  DeleteData(String Iddoc, String IdDoc2) async {
    await FirebaseFirestore.instance
        .collection("Category")
        .doc(Iddoc)
        .collection("Note")
        .doc(IdDoc2)
        .delete();
    data.removeWhere((Element) => Element.id == IdDoc2);
    Get.snackbar("Success".tr, "Item Deleted Successfully!".tr);
  }
}

class EditeNotesController extends GetxController {
  var onTap = false.obs;
  // ignore: unused_field
  List<String> _history = [""].obs;
  // ignore: unused_field
  RxInt _historyIndex = 0.obs;
}

class themesContoller extends GetxController {
  final selectedThemes =
      shared?.getBool("Dark") == true
          ? ThemeMode.dark.obs
          : ThemeMode.light.obs;
  RxBool selected = shared?.getBool("Dark") == true ? true.obs : false.obs;

  void changeThemes(ThemeMode themeMode, bool isdark) async {
    selectedThemes.value = themeMode;
    selected.value = isdark;
    await shared?.setBool("Dark", isdark);
  }
}
