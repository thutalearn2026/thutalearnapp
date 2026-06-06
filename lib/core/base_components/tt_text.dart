import 'package:flutter/material.dart';
import '../core.dart';

enum TtFontFamily {
  waso,
  pyidaungsu,
  riffic,
  lora,
}

class TtText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? height;
  final TextDecoration? decoration;
  final TtFontFamily? family;
  final int maxLength;
  final int? maxLines;
  final TextOverflow? overflow;
  final Paint? foreground;
  final List<Shadow>? shadows;
  final FontStyle? fontStyle;
  final Color? decorationColor;
  final bool isHTML;
  const TtText(
    this.text, {
    super.key,
    this.textAlign,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.height,
    this.family = TtFontFamily.pyidaungsu,
    this.decoration,
    this.maxLength = 100000,
    this.maxLines,
    this.overflow,
    this.foreground,
    this.shadows,
    this.fontStyle,
    this.decorationColor,
    this.isHTML = false,
  });

  @override
  Widget build(BuildContext context) {
    String showText = text;
    TextStyle textStyle = TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: family.toString().split(".").last,
      fontWeight: fontWeight,
      height: height,
      decoration: decoration,
      foreground: foreground,
      shadows: shadows,
      fontStyle: fontStyle,
      decorationColor: decorationColor,
    );

    if (isHTML) {
      // showText = parse(showText).documentElement?.text ?? "";
    }
    if (showText.length > maxLength) {
      // return SizedBox.expand(
      //   child: Marquee(
      //     text: showText,
      //     style: textStyle,
      //     textScaleFactor: 1.0,
      //   ),
      // );
    }

    return Text(
      showText,
      textAlign: textAlign,
      textScaler: TextScaler.linear(1.0),
      overflow: overflow,
      maxLines: maxLines,
      style: textStyle,
    );
  }
}

// bool hasTextOverflow(
//   String text, {
//   double minWidth = 240,
//   double maxWidth = 240,
//   required TextStyle style,
//   int maxLines = 1,
// }) {
//   final TextPainter textPainter = TextPainter(
//     text: TextSpan(text: text, style: style),
//     maxLines: maxLines,
//     textScaleFactor: Constants.textScaleFactor,
//     textDirection: TextDirection.ltr,
//   )..layout(minWidth: minWidth, maxWidth: maxWidth);
//
//   return textPainter.didExceedMaxLines;
// }
