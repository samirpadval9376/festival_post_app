import 'package:festival_post_app/utils/festival_utils.dart';
import 'package:flutter/material.dart';

class FestivalController extends ChangeNotifier {
  int index = 0;
  int bgIndex = 0;

  forward({required int index}) {
    print("=================================");
    print("${allFestival[index]['quote'].length}");
    print("=================================");
    if (index < allFestival[index]['quote'].length - 1) {
      this.index++;
    } else {
      this.index = 0;
    }
    notifyListeners();
  }

  back({required int index}) {
    if (index != 0) {
      this.index--;
    } else {
      this.index = 0;
    }
    notifyListeners();
  }

  List colors = [
    Colors.white,
    Colors.black,
    ...Colors.primaries,
  ];

  Color? textColor;

  changeColor({required int index}) {
    textColor = colors[index];
    notifyListeners();
  }

  changeBackground({required int index}) {
    bgIndex = index;
    notifyListeners();
  }
}
