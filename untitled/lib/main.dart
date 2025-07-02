import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Getx/Binding.dart';
import 'package:untitled/Getx/Controller.dart';
import 'package:untitled/locale/Locale.dart';
import 'package:untitled/locale/Locale_controller.dart';
import 'HomePage/HomePage.dart';
import 'Authentication/Login in.dart';
import 'Authentication/Sign Up.dart';
import 'HomePage/Add_Category.dart';

SharedPreferences? shared;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  shared = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  late themesContoller contoller;
  late LocaleController _controller;
  @override
  void initState() {
    _controller = Get.put(LocaleController());
    contoller = Get.put(themesContoller());
    Firebase.initializeApp();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: MyLocale(),
        locale: _controller.intitialLocale,
        theme: Themes.customLightTheme,
        themeMode: contoller.selectedThemes.value,
        darkTheme: Themes.customDarkTheme,
        getPages: [
          GetPage(
            name: "/Sing_up",
            page: () => Sign_Up(),
            binding: SingUpBinding(),
          ),
          GetPage(name: "/Login_In", page: () => Login_In()),
          GetPage(
            name: "/HomePage",
            page: () => HomePage(),
            binding: HomePageBinding(),
          ),
          GetPage(name: "/Add_Notes", page: () => Add_Category()),
        ],
        initialRoute:
            FirebaseAuth.instance.currentUser != null &&
                    FirebaseAuth.instance.currentUser!.emailVerified
                ? "/HomePage"
                : "/Login_In",
      );
    });
  }
}

class Themes {
  static ThemeData customDarkTheme = ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(backgroundColor: Colors.black),
    scaffoldBackgroundColor: Colors.black,
    drawerTheme: DrawerThemeData(backgroundColor: Colors.indigo),
    cardTheme: CardThemeData(
      color: Colors.black,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.transparent, width: 0),
      ),
      shadowColor: Colors.white,
      elevation: 3,
    ),
    cardColor: Colors.black,
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
      labelMedium: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.black12,
      actionTextColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black,
      hintStyle: TextStyle(color: Colors.white54),
      labelStyle: TextStyle(color: Colors.white),
      floatingLabelStyle: TextStyle(color: Colors.blueAccent),
    ),
  );
  static ThemeData customLightTheme = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(backgroundColor: Colors.grey[300]),
  );
}
