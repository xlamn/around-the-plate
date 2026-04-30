import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

FThemeData get plateLight {
  const touch = true;

  const colors = FColors(
    brightness: .light,
    systemOverlayStyle: .dark,
    barrier: Color(0x33000000),
    background: Color(0xFFFAFAFA),
    foreground: Color(0xFF09090B),
    primary: Color(0xFF5094C2),
    primaryForeground: Color(0xFFFAFAFA),
    secondary: Color(0xFFF4F4F5),
    secondaryForeground: Color(0xFF18181B),
    muted: Color(0xFFF4F4F5),
    mutedForeground: Color(0xFF71717B),
    destructive: Color(0xFFD63050),
    destructiveForeground: Color(0xFFFAFAFA),
    error: Color(0xFFD63050),
    errorForeground: Color(0xFFFAFAFA),
    card: Color(0xFFFFFFFF),
    border: Color(0xFFE5E5E5),
  );

  final typography = _typography(colors: colors, touch: touch);
  final style = _style(colors: colors, typography: typography, touch: touch);

  return FThemeData(
    colors: colors,
    typography: typography,
    style: style,
    touch: touch,
  );
}

FThemeData get plateDark {
  const touch = true;

  const colors = FColors(
    brightness: .dark,
    systemOverlayStyle: .light,
    barrier: Color(0x7A000000),
    background: Color(0xFF0F0F0F),
    foreground: Color(0xFFFAFAFA),
    primary: Color(0xFF7AB8DF),
    primaryForeground: Color(0xFF0F0F0F),
    secondary: Color(0xFF1E1E1E),
    secondaryForeground: Color(0xFFFAFAFA),
    muted: Color(0xFF1E1E1E),
    mutedForeground: Color(0xFF737373),
    destructive: Color(0xFFFF5252),
    destructiveForeground: Color(0xFFFAFAFA),
    error: Color(0xFFFF5252),
    errorForeground: Color(0xFFFAFAFA),
    card: Color(0xFF1A1A1A),
    border: Color(0xFF2E2E2E),
  );

  final typography = _typography(colors: colors, touch: touch);
  final style = _style(colors: colors, typography: typography, touch: touch);

  return FThemeData(
    colors: colors,
    typography: typography,
    style: style,
    touch: touch,
  );
}

FTypography _typography({
  required FColors colors,
  required bool touch,
}) {
  final font = FTypography.defaultFontFamily;
  final color = colors.foreground;

  if (touch) {
    return FTypography(
      fontFamily: font,
      xs3: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 10,
        height: 1,
        leadingDistribution: .even,
      ),
      xs2: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 12,
        height: 1,
        leadingDistribution: .even,
      ),
      xs: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 14,
        height: 1.25,
        leadingDistribution: .even,
      ),
      sm: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 16,
        height: 1.5,
        leadingDistribution: .even,
      ),
      md: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 18,
        height: 1.75,
        letterSpacing: -0.2,
        leadingDistribution: .even,
      ),
      lg: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 20,
        height: 1.75,
        letterSpacing: -0.3,
        leadingDistribution: .even,
      ),
      xl: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 22,
        height: 2,
        letterSpacing: -0.4,
        leadingDistribution: .even,
      ),
      xl2: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 30,
        height: 2.25,
        letterSpacing: -0.5,
        leadingDistribution: .even,
      ),
      xl3: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 36,
        height: 2.5,
        letterSpacing: -0.7,
        leadingDistribution: .even,
      ),
      xl4: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 48,
        height: 1,
        letterSpacing: -1.0,
        leadingDistribution: .even,
      ),
      xl5: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 60,
        height: 1,
        letterSpacing: -1.2,
        leadingDistribution: .even,
      ),
      xl6: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 72,
        height: 1,
        letterSpacing: -1.5,
        leadingDistribution: .even,
      ),
      xl7: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 96,
        height: 1,
        letterSpacing: -2.0,
        leadingDistribution: .even,
      ),
      xl8: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 108,
        height: 1,
        letterSpacing: -2.0,
        leadingDistribution: .even,
      ),
    );
  } else {
    return FTypography(
      fontFamily: font,
      xs3: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 8,
        height: 1,
        leadingDistribution: .even,
      ),
      xs2: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 10,
        height: 1,
        leadingDistribution: .even,
      ),
      xs: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 12,
        height: 1,
        leadingDistribution: .even,
      ),
      sm: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 14,
        height: 1.25,
        leadingDistribution: .even,
      ),
      md: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 16,
        height: 1.5,
        letterSpacing: -0.1,
        leadingDistribution: .even,
      ),
      lg: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 18,
        height: 1.75,
        letterSpacing: -0.2,
        leadingDistribution: .even,
      ),
      xl: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 20,
        height: 1.75,
        letterSpacing: -0.3,
        leadingDistribution: .even,
      ),
      xl2: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 22,
        height: 2,
        letterSpacing: -0.4,
        leadingDistribution: .even,
      ),
      xl3: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 30,
        height: 2.25,
        letterSpacing: -0.6,
        leadingDistribution: .even,
      ),
      xl4: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 36,
        height: 2.5,
        letterSpacing: -0.8,
        leadingDistribution: .even,
      ),
      xl5: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 48,
        height: 1,
        letterSpacing: -1.0,
        leadingDistribution: .even,
      ),
      xl6: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 60,
        height: 1,
        letterSpacing: -1.2,
        leadingDistribution: .even,
      ),
      xl7: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 72,
        height: 1,
        letterSpacing: -1.5,
        leadingDistribution: .even,
      ),
      xl8: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: 96,
        height: 1,
        letterSpacing: -2.0,
        leadingDistribution: .even,
      ),
    );
  }
}

FStyle _style({
  required FColors colors,
  required FTypography typography,
  required bool touch,
}) {
  const borderRadius = FBorderRadius();
  return FStyle(
    formFieldStyle: .inherit(
      colors: colors,
      typography: typography,
      touch: touch,
    ),
    focusedOutlineStyle: FFocusedOutlineStyle(
      color: colors.primary,
      borderRadius: borderRadius.md,
    ),
    sizes: FSizes.inherit(touch: touch),
    iconStyle: IconThemeData(
      color: colors.foreground,
      size: typography.lg.fontSize,
    ),
    tappableStyle: FTappableStyle(),
    hapticFeedback: const FHapticFeedback(),
    borderRadius: const FBorderRadius(),
    borderWidth: 1,
    pagePadding: const .symmetric(vertical: 8, horizontal: 12),
    shadow: const [
      BoxShadow(color: Color(0x0d000000), offset: Offset(0, 1), blurRadius: 2),
    ],
  );
}
