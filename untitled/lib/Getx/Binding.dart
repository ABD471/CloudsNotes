import 'package:get/get.dart';
import 'package:untitled/Getx/Controller.dart';

class HomePageBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> EditeNotesController());
    Get.put<HomePageController>(HomePageController());
    Get.lazyPut(()=>themesContoller());
    
  }

}
class SingUpBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>SingUpController());
  }

}