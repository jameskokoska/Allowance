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
      fontFamily: 'Avenir',
      color: finalTextColor,
      overflow: overflow,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: 2,
      height: 1.1,
    );
    return Text(
      filter != null ? filter!(text) : text,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: textStyle,
      softWrap: softWrap,
    );
  }
}
