import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TextFont extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? textColor;
  final TextAlign textAlign;
  final int? maxLines;
  final bool fixParagraphMargin;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final Function(String)? filter;
  final bool autoSizeText;
  final double? minFontSize;
  final double? maxFontSize;

  const TextFont({
    Key? key,
    required this.text,
    this.fontSize = 20,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.left,
    this.textColor,
    this.maxLines,
    this.fixParagraphMargin = false,
    this.overflow,
    this.softWrap,
    this.decoration,
    this.decorationColor,
    this.filter,
    this.autoSizeText = false,
    this.maxFontSize,
    this.minFontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? finalTextColor;
    if (textColor == null) {
      finalTextColor = Theme.of(context).textTheme.bodyMedium!.color;
    } else {
      finalTextColor = textColor;
    }
    final TextStyle textStyle = TextStyle(
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: finalTextColor,
      overflow: overflow,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: 2,
      height: 1.1,
    );
    return autoSizeText
        ? AutoSizeText(
            filter != null ? filter!(text) : text,
            maxLines: maxLines,
            textAlign: textAlign,
            overflow: overflow ?? TextOverflow.ellipsis,
            style: textStyle,
            softWrap: softWrap,
            minFontSize: minFontSize ?? fontSize - 10,
            maxFontSize: maxFontSize ?? fontSize + 10,
          )
        : Text(
            filter != null ? filter!(text) : text,
            maxLines: maxLines,
            textAlign: textAlign,
            overflow: overflow ?? TextOverflow.ellipsis,
            style: textStyle,
            softWrap: softWrap,
          );
  }
}
