import 'package:flutter/cupertino.dart';

Color kBackground = Color(0xfff5f5f7);
Color kPrimary = Color(0xff00BFA6);
Color kTextColor = Color(0xFF535353);
Color kTextLightColor = Color(0xFFACACAC);
const noImageUrl =
    "https://upload.wikimedia.org/wikipedia/commons/thumb/archive/a/ac/20121003093557%21No_image_available.svg/120px-No_image_available.svg.png";
const kDefaultPaddin = 20.0;

const dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";
double value = 0;

class MenuHandler {
  void handleDrawer() {
    value == 0 ? value = 1 : value = 0;
  }
}
