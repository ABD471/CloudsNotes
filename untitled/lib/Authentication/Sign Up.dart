import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/Components/CostumBottun.dart';
import 'package:untitled/Components/loading.dart';
import '../Components/CostumFiledText.dart';
import '../Getx/Controller.dart';

// ignore: must_be_immutable
class Sign_Up extends StatelessWidget {
  late TextEditingController Email = TextEditingController();
  late TextEditingController Password = TextEditingController();
  late TextEditingController UserName = TextEditingController();
  final SingUpController _controller = Get.find();
  final RegExp _upperCase = RegExp(r'[A-Z]');
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
// create user away Email and Password 
  void createUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        _controller.isloading.value = true;

        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: Email.text,
              password: Password.text,
            );

        await FirebaseAuth.instance.currentUser!.sendEmailVerification();
        _controller.isloading.value = false;

        Get.offNamed('/Login_In');
        Get.snackbar(
          "Success".tr,
          "An account confirmation".tr,
          animationDuration: Duration(seconds: 8),
          borderColor: Colors.orange[400],
          borderWidth: 5,
          //colorText: Colors.black,
         // snackStyle: SnackStyle.GROUNDED,W
          duration: Duration(seconds: 5),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          _controller.isloading.value = false;

          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error'.tr,
            desc:
                'The account already'.tr,

            btnOkOnPress: () {},
          )..show();
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }
  // end create user .

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () =>
            _controller.isloading.value
                ? loading()
                : Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            Container(
                              height: 220,
                              child: Image.asset(
                                "images/icons8-sticky-notes-200.png",
                              ),
                            ),
                            Text(
                              "sign1".tr,
                              style: TextStyle(
                                //color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(height: 10),
                            Text(
                              "sign2".tr,
                              //style: TextStyle(color: Colors.grey[500]),
                            ),
                            Container(height: 10),
                            Text(
                              "sign3".tr,
                              style: TextStyle(
                              //  color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Costumfiledtext(
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please Enter your Name".tr;
                                }
                                return null;
                              },
                              hintText: "sign4".tr,
                              Mycontroller: UserName,
                            ),
                            Container(height: 10),
                            Text(
                              "sign5".tr,
                              style: TextStyle(
                            //    color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Costumfiledtext(
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please Enter Your Email".tr;
                                }
                                if (!val.endsWith("@gmail.com")) {
                                  return "Example 123@gmail.com";
                                }
                                return null;
                              },
                              hintText: "sign6".tr,
                              Mycontroller: Email,
                            ),
                            Container(height: 10),
                            Text(
                              "sign7".tr,
                              style: TextStyle(
                              //  color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Costumfiledtext(
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please Enter Your Password.".tr;
                                }
                                if (val.length < 8) {
                                  return "Password must be at least 8 Characters long.".tr;
                                }
                                if (!_upperCase.hasMatch(val)) {
                                  return "Password must contain at least one uppercase letter.".tr;
                                }
                                return null;
                              },
                              hintText: "sign8".tr,
                              Mycontroller: Password,
                            ),
                            Container(height: 10),
                            

                            Container(height: 15),

                            CostumBottoun(
                              Title: "sign9".tr,
                              onPressed: () async {
                                createUser(context);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 75,
                                right: 50,
                              ),
                              child: Row(
                                spacing: 10,
                                children: [
                                  Text("sign10".tr),
                                  InkWell(
                                    child: Text(
                                      "sign11".tr,
                                      style: TextStyle(
                                        color: Colors.orange[900],
                                      ),
                                    ),
                                    onTap: () {
                                      Get.offNamed("/Login_In");
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}
