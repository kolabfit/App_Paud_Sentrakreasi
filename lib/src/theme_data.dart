part of '../main.dart';

class AppThemeData {
  const AppThemeData({
    required this.id,
    required this.name,
    required this.bg,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.asset,
    required this.widgetBg,
    required this.widgetBorder,
    required this.gradientStart,
    required this.gradientEnd,
    this.backgroundAsset,
    this.dark = false,
  });

  final String id;
  final String name;
  final Color bg;
  final Color primary;
  final Color secondary;
  final Color accent;
  final String asset;
  final bool dark;
  final Color widgetBg;
  final Color widgetBorder;
  final Color gradientStart;
  final Color gradientEnd;
  final String? backgroundAsset;

  bool get night => id == 'malam';
}

class NightPalette {
  static const midnight = Color(0xff101B3D);
  static const midnight2 = Color(0xff172458);
  static const purple = Color(0xff21183F);
  static const surface = Color(0xff302452);
  static const lavender = Color(0xffAFA6FF);
  static const cyan = Color(0xff63E6FF);
  static const mint = Color(0xff93F6D7);
  static const gold = Color(0xffFFD978);
  static const text = Color(0xffF5F2FF);
  static const muted = Color(0xffC9C2E8);
}

const appThemes = [
  AppThemeData(
    id: 'default',
    name: 'Default',
    bg: Color(0xfff7fbff),
    primary: Color(0xff1498bd),
    secondary: Color(0xffff8f1f),
    accent: Color(0xff40c8f4),
    asset: 'assets/images/Anak_hebat.png',
    widgetBg: Colors.white,
    widgetBorder: Color(0xff1498bd),
    gradientStart: Color(0xfff7fbff),
    gradientEnd: Color(0xfffff2dd),
    backgroundAsset: 'assets/images/Background_image.png',
  ),
  AppThemeData(
    id: 'malam',
    name: 'Mode Malam',
    bg: NightPalette.midnight,
    primary: Color(0xff9D7CFF),
    secondary: NightPalette.mint,
    accent: NightPalette.gold,
    asset: 'assets/images/Mode_Malam.png',
    dark: true,
    widgetBg: Color(0xcc302452),
    widgetBorder: NightPalette.cyan,
    gradientStart: Color(0xff101B3D),
    gradientEnd: Color(0xff27194C),
    backgroundAsset: 'assets/images/Background_Image_Malam.png',
  ),
];
