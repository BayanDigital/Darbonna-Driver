import 'package:flutter/material.dart';

class CustomThemeColors extends ThemeExtension<CustomThemeColors> {
  final Color upComingTagColor;


  const CustomThemeColors({
    required this.upComingTagColor,

  });

  // Predefined themes for light and dark modes
  factory CustomThemeColors.light() => const CustomThemeColors(
    upComingTagColor: Color(0xff5D40B2),

  );

  factory CustomThemeColors.dark() => const CustomThemeColors(
    upComingTagColor: Color(0xff5D40B2),

  );

  @override
  CustomThemeColors copyWith({
    Color? upComingTagColor,

  }) {
    return CustomThemeColors(
      upComingTagColor: upComingTagColor ?? this.upComingTagColor,
    );
  }

  @override
  CustomThemeColors lerp(ThemeExtension<CustomThemeColors>? other, double t) {
    if (other is! CustomThemeColors) return this;

    return CustomThemeColors(
      upComingTagColor: Color.lerp(upComingTagColor, other.upComingTagColor, t)!,
    );
  }
}