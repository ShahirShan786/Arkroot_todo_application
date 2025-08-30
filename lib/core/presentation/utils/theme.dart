import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/* Light theme default */
AppColors appColors = AppColorsDark();
ThemeData appTheme = getDarkTheme();

/* Dark theme default */
// AppColors appColors = AppColorsDark();
// ThemeData appTheme = getDarkTheme();

ThemeData getLightTheme() {
  return ThemeData(
    applyElevationOverlayColor: false,
    dividerColor: const Color(0xFFECEDF1),
    brightness: Brightness.light,
    primaryColor: const Color(0xFF246BFD),
    textTheme: TextTheme(
      titleSmall: GoogleFonts.caveat(
        textStyle: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: appColors.textColor,
        ),
      ),
      headlineLarge: GoogleFonts.urbanist(
        textStyle: TextStyle(
          fontSize: 22.sp,
          color: appColors.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      headlineMedium: GoogleFonts.urbanist(
        textStyle: TextStyle(
          fontSize: 20.sp,
          color: appColors.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      headlineSmall: GoogleFonts.urbanist(
        textStyle: TextStyle(
          fontSize: 18.sp,
          color: appColors.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      labelLarge: GoogleFonts.urbanist(
        textStyle: TextStyle(
          fontSize: 16.sp,
          color: appColors.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      labelMedium: GoogleFonts.urbanist(
        textStyle: TextStyle(
          fontSize: 14.sp,
          color: appColors.textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      labelSmall: GoogleFonts.urbanist(
        textStyle: TextStyle(
          fontSize: 20.sp,
          color: appColors.textColor,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );
}

ThemeData getDarkTheme() {
  return ThemeData(
    applyElevationOverlayColor: true,
    dividerColor: const Color(0xFFECEDF1),
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF246BFD),
    textTheme: TextTheme(
      titleSmall: GoogleFonts.caveat(
        textStyle: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: appColors.textColor,
        ),
      ),
      headlineLarge: GoogleFonts.urbanist(
        textStyle: TextStyle(
          fontSize: 22.sp,
          color: appColors.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      headlineMedium: GoogleFonts.urbanist(
        textStyle: TextStyle(
          fontSize: 20.sp,
          color: appColors.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      headlineSmall: GoogleFonts.urbanist(
        textStyle: TextStyle(
          fontSize: 18.sp,
          color: appColors.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      labelLarge: GoogleFonts.inter(
        textStyle: TextStyle(
          fontSize: 16.sp,
          color: appColors.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      labelMedium: GoogleFonts.inter(
        textStyle: TextStyle(
          fontSize: 14.sp,
          color: appColors.textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      labelSmall: GoogleFonts.inter(
        textStyle: TextStyle(
          fontSize: 12.sp,
          color: appColors.textColor,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );
}

abstract class AppColors {
  final Color screenBg;
  final Color appBarBg;
  final Color appBarcolor;
  final Color progressCircleBg;
  final Color pleasantButtonBg;
  final Color pleasantButtonBgHover;
  final Color buttonTextColor;
  final Color negativeButtonBg;
  final Color negativeButtonBgHover;
  final Color buttonTextColorHover;
  final Color textColor;
  final Color linkTextColor;

  final Color tileBgColor;
  final Color tileBgColorHover;
  final Color tileTextColor;
  final Color tileTextColorHover;

  final InputBorder textInputEnabledBorder;
  final InputBorder textInputFocusedBorder;
  final Color textInputFillColor;
  final TextStyle textInputStyle;
  final TextStyle textInputLabelStyle;
  final TextStyle pleasantButtonTextStyle;
  final TextStyle appBarTextStyle;
  final Color listDividerColor;
  final IconThemeData appBarIconTheme;
  final double appBarElevation;
  final Color primaryColor;
  final Color disableBgColor;
  final Color sideMenuHighlight;
  final Color sideMenuNormal;
  final Color sideMenuDisable;
  final Color sideMenuBg;
  final Color inputBgFill;
  final List<Color> rainbowColors;

  AppColors({
    required this.screenBg,
    required this.appBarBg,
    required this.appBarcolor,
    required this.progressCircleBg,
    required this.pleasantButtonBg,
    required this.negativeButtonBg,
    required this.buttonTextColor,
    required this.buttonTextColorHover,
    required this.pleasantButtonBgHover,
    required this.negativeButtonBgHover,
    required this.textColor,
    required this.textInputEnabledBorder,
    required this.textInputFocusedBorder,
    required this.textInputFillColor,
    required this.textInputStyle,
    required this.textInputLabelStyle,
    required this.pleasantButtonTextStyle,
    required this.appBarTextStyle,
    required this.listDividerColor,
    required this.appBarIconTheme,
    required this.appBarElevation,
    required this.primaryColor,
    required this.disableBgColor,
    required this.sideMenuHighlight,
    required this.sideMenuNormal,
    required this.sideMenuDisable,
    required this.sideMenuBg,
    required this.inputBgFill,
    required this.rainbowColors,
    required this.linkTextColor,
    required this.tileBgColor,
    required this.tileBgColorHover,
    required this.tileTextColor,
    required this.tileTextColorHover,
  });
}

class AppColorsLight extends AppColors {
  AppColorsLight()
    : super(
        screenBg: const Color(0xFFFFFFFF), // White background for light
        appBarBg: const Color(0xFFFFFFFF),
        appBarcolor: const Color(0xFF1A1A1A),
        progressCircleBg: const Color(0xFF1E6F9F), // Primary
        pleasantButtonBg: const Color(0xFF1E6F9F), // Primary
        pleasantButtonBgHover: const Color(
          0xFF155470,
        ), // Darker shade of primary
        negativeButtonBg: const Color.fromARGB(255, 248, 53, 95),
        negativeButtonBgHover: const Color.fromARGB(255, 255, 42, 42),
        buttonTextColor: const Color(0xFFFFFFFF), // onSurface
        buttonTextColorHover: const Color(0xFFDDDDDD),
        textColor: const Color(0xFF1A1A1A), // Surface text (dark text)
        textInputEnabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        textInputFocusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: const Color(0xFF1E6F9F)),
        ),
        textInputFillColor: Colors.grey[100]!,
        textInputStyle: const TextStyle(color: Color(0xFF1A1A1A)),
        textInputLabelStyle: const TextStyle(color: Color(0xFF1A1A1A)),
        pleasantButtonTextStyle: const TextStyle(color: Colors.white),
        appBarTextStyle: GoogleFonts.righteous(
          textStyle: const TextStyle(color: Color(0xFF1A1A1A)),
        ),
        listDividerColor: Colors.grey[400]!,
        appBarIconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
        appBarElevation: 8,
        primaryColor: const Color(0xFF1E6F9F),
        disableBgColor: Colors.black54,
        sideMenuHighlight: const Color(0xFF1E6F9F),
        sideMenuNormal: Colors.grey,
        sideMenuDisable: Colors.grey.shade400,
        sideMenuBg: const Color(0xFFFFFFFF),
        inputBgFill: Colors.grey[200]!,
        rainbowColors: [
          const Color(0xFF1E6F9F), // Primary as base
          Colors.teal,
          Colors.blueGrey,
          Colors.cyan,
          Colors.indigo,
          Colors.deepPurple,
          Colors.blue,
        ],
        linkTextColor: const Color(0xFF1E6F9F),
        tileBgColor: const Color(0xFFFFFFFF),
        tileBgColorHover: const Color(0xFF1E6F9F),
        tileTextColor: const Color(0xFF1A1A1A),
        tileTextColorHover: Colors.white,
      );
}

class AppColorsDark extends AppColors {
  AppColorsDark()
    : super(
        screenBg: const Color(0xFF1A1A1A), // Surface
        appBarBg: const Color(0xFF1A1A1A),
        appBarcolor: const Color(0xFF1A1A1A),
        progressCircleBg: const Color(0xFF1E6F9F), // Primary
        pleasantButtonBg: const Color(0xFF1E6F9F), // Primary
        pleasantButtonBgHover: const Color(0xFF155470), // Darker shade
        negativeButtonBg: const Color.fromARGB(255, 248, 53, 95),
        negativeButtonBgHover: const Color.fromARGB(255, 255, 42, 42),
        buttonTextColor: const Color(0xFFFFFFFF), // onSurface
        buttonTextColorHover: const Color(0xFFDDDDDD),
        textColor: const Color(0xFFFFFFFF), // onSurface
        textInputEnabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
        textInputFocusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          borderSide: const BorderSide(color: Color(0xFF1E6F9F)),
        ),
        textInputFillColor: const Color(0xFF2A2A2A),
        textInputStyle: const TextStyle(color: Colors.white),
        textInputLabelStyle: const TextStyle(color: Colors.white70),
        pleasantButtonTextStyle: const TextStyle(color: Colors.white),
        appBarTextStyle: GoogleFonts.righteous(
          textStyle: const TextStyle(color: Colors.white),
        ),
        listDividerColor: Colors.grey[700]!,
        appBarIconTheme: const IconThemeData(color: Colors.white),
        appBarElevation: 8,
        primaryColor: const Color(0xFF1E6F9F),
        disableBgColor: Colors.white54,
        sideMenuHighlight: const Color(0xFF1E6F9F),
        sideMenuNormal: Colors.white38,
        sideMenuDisable: Colors.white24,
        sideMenuBg: const Color(0xFF1A1A1A),
        inputBgFill: const Color(0xFF2A2A2A),
        rainbowColors: [
          const Color(0xFF1E6F9F),
          Colors.teal,
          Colors.blueGrey,
          Colors.cyan,
          Colors.indigo,
          Colors.deepPurple,
          Colors.blue,
        ],
        linkTextColor: const Color(0xFF1E6F9F),
        tileBgColor: const Color(0xFF1A1A1A),
        tileBgColorHover: const Color(0xFF1E6F9F),
        tileTextColor: Colors.white,
        tileTextColorHover: Colors.white70,
      );
}
