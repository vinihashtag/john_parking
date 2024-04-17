import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // * Colors default app
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color accentColor = Color(0xFF0D47A1);

  // * Custom colors
  static const Color disableColor = Color(0xffC6C6C6);
  static const Color errorColor = Color(0xffF44336);
  static const Color statusBarColor = Colors.black;
  static const Color greyColor = Color(0xff4F4F4F);
  static const Color disableButtonColor = Color(0xff616161);
  static const Color backgroundColor = Color(0xffE9E9F3);
  static const Color greenColor = Color(0xff4CAF50);
  static const Color redColor = Color(0xffF44336);
  static const Color orangeColor = Color(0xffFF9800);
  static const Color blueColor = Color(0xff2196F3);
  static ThemeData get defaultTheme => ThemeData(
        primaryColor: primaryColor,
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.white,
          foregroundColor: accentColor,
          shadowColor: Colors.black54,
          color: Colors.white,
          elevation: 3,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: accentColor),
        ),
        tabBarTheme: const TabBarTheme(
          labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          unselectedLabelStyle: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 14),
          indicatorColor: primaryColor,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black54,
          tabAlignment: TabAlignment.center,
          splashFactory: NoSplash.splashFactory,
          overlayColor: MaterialStatePropertyAll(Colors.transparent),
          dividerColor: Colors.white,
        ),
        scaffoldBackgroundColor: backgroundColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: const ColorScheme.light(
          secondary: accentColor,
          primary: primaryColor,
          background: backgroundColor,
          surfaceTint: backgroundColor,
        ),
        dividerTheme: const DividerThemeData(color: Color(0xFFEEEEEE), thickness: 1),
        inputDecorationTheme: InputDecorationTheme(
          errorStyle: const TextStyle(fontSize: 12),
          hintStyle: const TextStyle(color: Colors.black12, fontSize: 13),
          errorMaxLines: 2,
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(10),
          prefixIconColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.error)) return redColor;
            return states.contains(MaterialState.focused) ? accentColor : Colors.grey;
          }),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: accentColor, width: 1.8),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: accentColor, width: 1.8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: accentColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppTheme.errorColor, width: 1.8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppTheme.errorColor, width: 2.3),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black54,
            backgroundColor: Colors.white70,
            elevation: 2,
          ),
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: Colors.white,
          elevation: 3,
          surfaceTintColor: Colors.white,
        ),
        useMaterial3: true,
      );
}
