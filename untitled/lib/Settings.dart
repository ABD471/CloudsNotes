import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:untitled/Getx/Controller.dart';
import 'package:untitled/locale/Locale_controller.dart';

// ignore: must_be_immutable
class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController search = TextEditingController();
  late final themesContoller contoller;
  late final LocaleController contollerlocal;

  late List<DropdownMenuEntry> _language;


  late String? selected;

  @override
  void initState() {
    contollerlocal = Get.put(LocaleController());
    contoller = Get.put(themesContoller());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selected = Get.locale!.toLanguageTag();
    _language = [
      DropdownMenuEntry(value: "ar", label: "Arabic"),
      DropdownMenuEntry(value: "en", label: "English"),
    ];
    return Scaffold(
      appBar: AppBar(title: Text("Settings".tr)),
      body: Column(
        children: [
          Text("Language and Input".tr, style: TextStyle(fontSize: 25)),
          DropdownMenu(
            onSelected: (value) {
              contollerlocal.changelung(value);
            },
            dropdownMenuEntries: _language,
            enableSearch: true,
            width: 466,
            hintText: Get.locale!.languageCode,
          ),
          Text("Themes".tr, style: TextStyle(fontSize: 25)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                bool isdark = contoller.selected.value;
                print(isdark);
                return FlutterSwitch(
                  onToggle: (value) {
                    if (value) {
                      contoller.changeThemes(ThemeMode.dark, true);
                    } else {
                      contoller.changeThemes(ThemeMode.light, false);
                    }
                  },
                  value: isdark,
                  inactiveIcon: Icon(Icons.light_mode),

                  width: 60,
                  height: 30,
                  toggleSize: 25,
                  borderRadius: 20,
                  padding: 2,
                  activeColor: Colors.blueAccent,
                  inactiveColor: Colors.grey,
                  activeToggleColor: Colors.white,
                  inactiveToggleColor: Colors.grey[400],

                  activeIcon: Icon(Icons.dark_mode, color: Colors.black),
                  // disabled: true,
                );
              }),
              Text('Select Mode'.tr),
            ],
          ),
        ],
      ),
    );
  }
}

//AppTextField(textEditingController:search ,hint:"3" ,title: "6",);
