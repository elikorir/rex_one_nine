import 'dart:developer';

import 'package:chatzy/config.dart';

class LanguageController extends GetxController {
  int selectedIndex = 0;

  onTapLanguage(index) {
    selectedIndex = index;
    update();
  }

  //on language select
  onLanguageSelectTap(index, data) async {
    selectedIndex = index;

    String lanCode = data["code"].toString().split("_")[0];
    String countryCode = data["code"].toString().split("_")[1];

    Locale? locale = Locale(lanCode, countryCode);

    //language
    var language = await appCtrl.storage.read(session.locale) ?? lanCode;
    debugPrint("LANGUAGE1 $language");
    appCtrl.languageVal = language;
    Get.updateLocale(locale);
    appCtrl.locale = locale;
    update();
    appCtrl.update();
    Get.forceAppUpdate();
  }

  List orderByName = [];

  getLanguageList() async {
    List storageList = appCtrl.storage.read(session.languageList) ?? [];
    Locale locale = appCtrl.locale!;
    if (storageList.isEmpty) {
      FirebaseFirestore.instance
          .collection(collectionName.languages)
          .doc(collectionName.language)
          .snapshots()
          .listen((event) {
        if (event.exists) {
          List lan = event.data()!["language"];

          appCtrl.languagesLists =
              lan.where((element) => element['isActive'] == true).toList();
        }
        appCtrl.languagesLists.sort((a, b) => a["title"].compareTo(b["title"]));
        appCtrl.update();
        appCtrl.storage.write(session.languageList, appCtrl.languagesLists);
        appCtrl.update();
        int index = appCtrl.languagesLists.indexWhere((element) {
          log("EL :${element["code"]}");
          return element['code'].toString() == locale.toString();
        });
        selectedIndex = index;
        update();
      });
    } else {
      if (storageList.isNotEmpty) {
        appCtrl.languagesLists = storageList;
        appCtrl.update();
        int index = appCtrl.languagesLists.indexWhere((element) {
          log("EL :${element["code"]}");
          return element['code'].toString() == locale.toString();
        });
        selectedIndex = index;
        update();
      }
    }
  }
}
