import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:untitled/main.dart';

class LocaleController  extends GetxController {
 Locale intitialLocale = shared?.getString("language") =="ar" ? Locale("ar"): Locale("en");
  void changelung(String codelung){
    Locale locale = codelung =="ar"? Locale("ar"): Locale("en");
    shared?.setString("language", "$codelung");
    Get.updateLocale(locale);

  }
}