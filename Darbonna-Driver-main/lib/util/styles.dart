import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle sfProLight = GoogleFonts.cairo(
  fontWeight: FontWeight.w300,
);

TextStyle textRegular = GoogleFonts.cairo(
  fontWeight: FontWeight.w400,
);

TextStyle textMedium = GoogleFonts.cairo(
  fontWeight: FontWeight.w500,
);

TextStyle textSemiBold = GoogleFonts.cairo(
  fontWeight: FontWeight.w600,
);

TextStyle textBold = GoogleFonts.cairo(
  fontWeight: FontWeight.w700,
);

TextStyle textHeavy = GoogleFonts.cairo(
  fontWeight: FontWeight.w900,
);

TextStyle textRobotoRegular = GoogleFonts.cairo(
  fontWeight: FontWeight.w400,
);

TextStyle textRobotoMedium = GoogleFonts.cairo(
  fontWeight: FontWeight.w500,
);

TextStyle textRobotoBold = GoogleFonts.cairo(
  fontWeight: FontWeight.w700,
);

TextStyle textRobotoBlack = GoogleFonts.cairo(
  fontWeight: FontWeight.w900,
);

List<BoxShadow>? searchBoxShadow = Get.isDarkMode
    ? null
    : [
        const BoxShadow(
            offset: Offset(0, 3),
            color: Color(0x208F94FB),
            blurRadius: 5,
            spreadRadius: 2)
      ];

List<BoxShadow>? cardShadow = Get.isDarkMode
    ? null
    : [
        BoxShadow(
          offset: const Offset(1, 0),
          blurRadius: 1,
          spreadRadius: 1,
          color: Colors.black.withValues(alpha: 0.5),
        )
      ];

List<BoxShadow>? shadow = Get.isDarkMode
    ? [
        BoxShadow(
            offset: const Offset(0, 3),
            color: Colors.grey[100]!,
            blurRadius: 1,
            spreadRadius: 2)
      ]
    : [
        BoxShadow(
            offset: const Offset(0, 3),
            color: Colors.grey[100]!,
            blurRadius: 1,
            spreadRadius: 2)
      ];
