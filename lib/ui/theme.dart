// ui/theme.dart — the celestial design language: deep-space palette and the
// two bundled variable fonts (Cinzel for engraved titles, Raleway for body).
import 'package:flutter/material.dart';

/// Deep-space backdrop — the darkest point of the sky gradient.
const Color kSpaceBlack = Color(0xFF050712);
const Color kSpaceDeep = Color(0xFF080B20);
const Color kSpaceIndigo = Color(0xFF0F1855);
const Color kGold = Color(0xFFFBBF24);
const Color kFaintWhite = Color(0x66FFFFFF);

/// The sky behind every screen.
const RadialGradient kSkyGradient = RadialGradient(
  center: Alignment(-0.5, -0.7),
  radius: 1.4,
  colors: [kSpaceIndigo, kSpaceDeep, kSpaceBlack],
  stops: [0.0, 0.4, 1.0],
);

/// Cinzel (variable) — the engraved, mythic display face.
TextStyle cinzel(double size,
        {double weight = 600, Color color = Colors.white, double? spacing}) =>
    TextStyle(
      fontFamily: 'Cinzel',
      fontSize: size,
      color: color,
      letterSpacing: spacing,
      fontVariations: [FontVariation('wght', weight)],
    );

/// Raleway (variable) — quiet UI text.
TextStyle raleway(double size,
        {double weight = 400, Color color = Colors.white, double? spacing, double? height}) =>
    TextStyle(
      fontFamily: 'Raleway',
      fontSize: size,
      color: color,
      letterSpacing: spacing,
      height: height,
      fontVariations: [FontVariation('wght', weight)],
    );

ThemeData buildTheme() => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: kSpaceBlack,
      fontFamily: 'Raleway',
      colorScheme: ColorScheme.fromSeed(
          seedColor: kSpaceIndigo, brightness: Brightness.dark),
      splashFactory: InkRipple.splashFactory,
    );
