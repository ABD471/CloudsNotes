import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled/Components/loading.dart';
import 'package:untitled/Notes/ViewNotes.dart';
import 'package:untitled/HomePage/Rename.dart';
import 'package:untitled/Settings.dart';
import 'package:untitled/locale/Locale_controller.dart';
import 'Add_Category.dart';
import '../Getx/Controller.dart';
import '../Authentication/Login in.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  LocaleController controller = Get.put(LocaleController());
  final HomePageController homePageController = Get.find<HomePageController>();
  @override
  Widget build(BuildContext context) {
    String? name = FirebaseAuth.instance.currentUser?.email;
    String? email = FirebaseAuth.instance.currentUser?.displayName;
    return Scaffold(
      drawer: Drawer(
     
        child: Column(
          children: [
            Center(
              heightFactor: 1.5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  color: Colors.amber,
                ),
                padding: EdgeInsets.all(30),
                child: Icon(Icons.person_rounded, size: 90),
              ),
            ),
            Text("$email"),
            Text("$name"),
           
            InkWell(
              onTap: () {
                Get.to(Settings());
              },
              child: Container(
                padding: EdgeInsets.only(top: 30, left: 10),
                child: Row(
                  children: [Icon(Icons.settings), Text("settingsdrawer".tr)],
                ),
              ),
            ),
            InkWell(
              onTap: () async{
                 GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              Get.off(Login_In());
              },
              child: Container(
                padding: EdgeInsets.only(top: 30, left: 10),
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app_rounded),
                    Text("signoutdrawer".tr),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.add_circle, size: 70, color: Colors.orange),
        onPressed: () {
          Get.to(Add_Category());
        },
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            color: Colors.orange,
            iconSize: 40,
            onPressed: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              Get.off(Login_In());
            },
            icon: Icon(Icons.logout),
          ),
        ],
        title: Text("homeapppar".tr),
        titleTextStyle: TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
       
      ),
      body: Obx(() {
        if (homePageController.isLoading.value) {
          return loading();
        } else if (homePageController.data.isEmpty) {
          return Center(
            child: Text("Empty".tr),
            heightFactor: 80,
            widthFactor: 80,
          );
        } else
          return RefreshIndicator(
            onRefresh:() {
              return homePageController.getData();
            },
            child: GridView.builder(
              itemCount: homePageController.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    //Get.to(Opewncontainar());
                    Get.to(NoteView(Iddoc: homePageController.data[index].id));
                  },
                  onLongPress: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.bottomSlide,
                      title: 'AwesamTitle'.tr,
                      desc: "Awesamdecs".tr,
                      btnOkText: "AwesamDelete".tr,
                      btnCancelText: "AwesamRename".tr,
                      btnOkOnPress: () async {
                        await homePageController.DeleteData(
                          homePageController.data[index].id,
                        );
                      },
                      btnCancelOnPress: () {
                        Get.to(
                          Rename_Category(
                            Iddoc: homePageController.data[index].id,
            
                            OldName: homePageController.data[index]["name"],
                          ),
                        );
                      },
                    )..show();
                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset("images/icons8-folder-150.png"),
                          ),
                          Text(
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            homePageController.data[index]["name"],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
      }),
    );
  }
}
