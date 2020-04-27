import 'package:flutter/material.dart';

class AppColor {
  static const primaryColor = Color(0xff1d3e88);
  static final primarySwatch = _Color.generateMaterialColor(primaryColor);
}

class _Color {
  static MaterialColor generateMaterialColor(Color src) {
    final baseDark = multiply(src, src);

    var swatch = <int, Color>{
      50: mix(Colors.white, src, 12),
      100: mix(Colors.white, src, 30),
      200: mix(Colors.white, src, 50),
      300: mix(Colors.white, src, 70),
      400: mix(Colors.white, src, 85),
      500: mix(Colors.white, src, 100),
      600: mix(baseDark, src, 87),
      700: mix(baseDark, src, 70),
      800: mix(baseDark, src, 54),
      900: mix(baseDark, src, 25),
    };

    return MaterialColor(src.value, swatch);
  }

  static Color mix(Color src, Color other, int amount) {
    var p = amount / 100.0;
    var rgba = {
      'r': ((other.red - src.red) * p + src.red).toInt(),
      'g': ((other.green - src.green) * p + src.green).toInt(),
      'b': ((other.blue - src.blue) * p + src.blue).toInt(),
      'a': ((other.alpha - src.alpha) * p + src.alpha).toInt(),
    };

    return Color.fromARGB(rgba['a'], rgba['r'], rgba['g'], rgba['b']);
  }

  static Color multiply(Color a, Color b) {
    return Color.fromARGB(
      255,
      (a.red * b.red / 255.0).floor(),
      (a.green * b.green / 255.0).floor(),
      (a.blue * b.blue / 255.0).floor(),
    );
  }
}
