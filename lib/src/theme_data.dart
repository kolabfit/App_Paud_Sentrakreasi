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
    id: 'alam',
    name: 'Alam',
    bg: Color(0xfff2f7f5),
    primary: Color(0xff43d36f),
    secondary: Color(0xff006d4e),
    accent: Color(0xffffc857),
    asset: 'assets/images/Mode_Alam.png',
    widgetBg: Colors.white,
    widgetBorder: Color(0xff43d36f),
    gradientStart: Color(0xfff2f7f5),
    gradientEnd: Color(0xffe0f5ec),
  ),
  AppThemeData(
    id: 'angkasa',
    name: 'Angkasa',
    bg: Color(0xff2d3436),
    primary: Color(0xff6c5ce7),
    secondary: Color(0xffa29bfe),
    accent: Color(0xfffab1a0),
    asset: 'assets/images/Mode_Angkasa.png',
    dark: true,
    widgetBg: Color(0xff3D4446),
    widgetBorder: Color(0xff6C5CE7),
    gradientStart: Color(0xff2d3436),
    gradientEnd: Color(0xff3d3a5c),
  ),
  AppThemeData(
    id: 'malam',
    name: 'Mode Malam',
    bg: Color(0xff121212),
    primary: Color(0xff2c3e50),
    secondary: Color(0xff95a5a6),
    accent: Color(0xfff1c40f),
    asset: 'assets/images/Mode_Malam.png',
    dark: true,
    widgetBg: Color(0xff1E1E1E),
    widgetBorder: Color(0xff2C3E50),
    gradientStart: Color(0xff121212),
    gradientEnd: Color(0xff1a2530),
  ),
  AppThemeData(
    id: 'hewan',
    name: 'Hewan',
    bg: Color(0xfffdf6e9),
    primary: Color(0xffff9a00),
    secondary: Color(0xff827569),
    accent: Color(0xffff6b6b),
    asset: 'assets/images/Mode_Hewan.png',
    widgetBg: Colors.white,
    widgetBorder: Color(0xffFF9A00),
    gradientStart: Color(0xfffdf6e9),
    gradientEnd: Color(0xfffff0d4),
  ),
  AppThemeData(
    id: 'lautan',
    name: 'Laut',
    bg: Color(0xffebf7ff),
    primary: Color(0xff00cec9),
    secondary: Color(0xff0984e3),
    accent: Color(0xff74b9ff),
    asset: 'assets/images/Mode_Laut.png',
    widgetBg: Colors.white,
    widgetBorder: Color(0xff00CEC9),
    gradientStart: Color(0xffebf7ff),
    gradientEnd: Color(0xffd6eeff),
  ),
];
