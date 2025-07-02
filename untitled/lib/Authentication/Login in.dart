import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled/Components/CostumBottun.dart';
import 'package:untitled/Components/loading.dart';
import '../Components/CostumFiledText.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class Login_In extends StatelessWidget {
  late TextEditingController Email = TextEditingController();
  late TextEditingController Password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
// sing in away with Google .
  Future signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return;
      }
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      Get.offNamed("/HomePage");
    } catch (e) {
      print(e.toString());
    }
  }

  // restart password .
  Future restPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: Email.text);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Success'.tr,
        desc:
            'password Reset'.tr,

        btnOkOnPress: () {},
      )..show();
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: 'Error'.tr,
        desc: 'please Confirm '.tr,

        btnOkOnPress: () {},
      )..show();
    }
  }

  // login in away emii and password .
  Future loginEmailandPassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        isLoading = true;

        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: Email.text,
              password: Password.text,
            );
        isLoading = false;

        if (credential.user!.emailVerified) {
          isLoading = false;

          Navigator.of(context).pushReplacementNamed("HomePage");
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Warning'.tr,
            desc:
                'To Activate Your Account ,please go To Tour Email And Confirm The Link sender',

            btnOkOnPress: () {},
          )..show();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          isLoading = false;

          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Warning'.tr,
            desc: 'No user found'.tr,

            btnOkOnPress: () {},
          )..show();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading == true
              ? loading()
              : Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                height: 250,
                                child: Image.asset(
                                  "images/icons8-sticky-notes-200.png",
                                ),
                              ),
                            ),
                            Text(
                              "login1".tr,
                              style: TextStyle(
                               // color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(height: 10),
                            Text(
                              "login2".tr,
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                            Container(height: 10),
                            Text(
                              "login3".tr,
                              style: TextStyle(
                               // color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Costumfiledtext(
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "filed is Empty".tr;
                                }
                                if (!val.endsWith("@gmail.com")) {
                                  return " Example 123@gmail.com";
                                }
                                return null;
                              },
                              hintText: "login4".tr,
                              Mycontroller: Email,
                            ),
                            Container(height: 10),
                            Text(
                              "login5".tr,
                              style: TextStyle(
                              //  color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Costumfiledtext(
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "filed is Empty".tr;
                                }
                                return null;
                              },
                              hintText: "login6".tr,
                              Mycontroller: Password,
                            ),

                            InkWell(
                              onTap: () async {
                                await restPassword(context);
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "login7".tr,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: CostumBottoun(
                                Title: "login8".tr,
                                onPressed: () async {
                                  await loginEmailandPassword(context);
                                },
                              ),
                            ),
                            Center(child: Text("login9".tr)),

                            Padding(
                              padding: const EdgeInsets.only(
                                right: 60,
                                left: 60,
                              ),
                              child: SizedBox(
                                child: MaterialButton(
                                  textColor: Colors.white,
                                  onPressed: () {
                                    signInWithGoogle();
                                  },
                                  child: Row(
                                    children: [
                                      Text("login10".tr),
                                      Image.asset(
                                        "images/icons8-google-36.png",
                                      ),
                                    ],
                                  ),
                                  color: Colors.orange[300],
                                  shape: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Container(height: 15),

                            Padding(
                              padding: const EdgeInsets.only(
                                left: 75,
                                right: 50,
                              ),
                              child: Row(
                                spacing: 10,
                                children: [
                                  Text("login11".tr),
                                  InkWell(
                                    child: Text(
                                      "login12".tr,
                                      style: TextStyle(
                                        color: Colors.orange[900],
                                      ),
                                    ),
                                    onTap: () {
                                      Get.offNamed("/Sing_up");
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
