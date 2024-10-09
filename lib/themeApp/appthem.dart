import 'package:flutter/material.dart';

class MedicalTheme {
  static Color primaryColor = const Color(0xFF00796B); // لون أخضر هادئ
  static Color accentColor = const Color(0xFF80CBC4); // لون أخضر فاتح
  static Color backgroundColor =
      const Color(0xFFF1F8F9); // لون خلفية أبيض مائل للأزرق
  static Color buttonColor = const Color(0xFF0288D1); // أزرق داكن للأزرار
  static Color textColor = const Color(0xFF212121); // لون نص أسود داكن
  static Color subtitleTextColor = const Color(0xFF757575); // لون نص رمادي
  static Color errorColor = const Color(0xFFD32F2F); // لون أحمر للأخطاء

  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      buttonTheme: ButtonThemeData(
        buttonColor: buttonColor,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
            color: textColor, fontSize: 32, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: textColor, fontSize: 16),
        bodyMedium: TextStyle(color: subtitleTextColor, fontSize: 14),
      ),
      cardColor: errorColor,
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: accentColor)
          .copyWith(background: backgroundColor),
    );
  }
}
