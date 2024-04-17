import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension FormattedDateString on String {
  DateTime get toDate {
    try {
      if (trim().isEmpty) return DateTime.now();

      if (length > 10) {
        return DateFormat('dd/MM/yyyy HH:mm').parse(this);
      } else if (length == 10) {
        return DateFormat('dd/MM/yyyy').parse(this);
      } else {
        return DateFormat('HH:mm').parse(this);
      }
    } catch (_) {
      return DateTime.now();
    }
  }

  /// If the {fontWeightStyle} param is different of null the {fontWeight} param will be ignored
  TextSpan toBoldTextSpan(TextStyle defaultStyle,
      {FontWeight fontWeight = FontWeight.w700, TextStyle? fontWeightStyle}) {
    List<TextSpan> textSpans = [];

    RegExp regExp = RegExp(r'\*([^*]+)\*');
    List<RegExpMatch> matches = regExp.allMatches(this).toList();

    int currentIndex = 0;

    for (RegExpMatch match in matches) {
      if (match.start > currentIndex) {
        textSpans.add(TextSpan(text: substring(currentIndex, match.start), style: defaultStyle));
      }

      TextStyle boldStyle = fontWeightStyle ?? defaultStyle.copyWith(fontWeight: fontWeight);
      textSpans.add(TextSpan(text: match.group(1), style: boldStyle));

      currentIndex = match.end;
    }

    if (currentIndex < length) {
      textSpans.add(TextSpan(text: substring(currentIndex), style: defaultStyle));
    }

    return TextSpan(children: textSpans);
  }

  TextSpan toTextSpanColorBold({required TextStyle defaultStyle}) {
    List<InlineSpan> spans = [];
    RegExp regex = RegExp(r'<span style="(?:font-weight: (\d+);)?(?: color: #([0-9a-fA-F]+);)?">(.*?)<\/span>');
    int lastIndex = 0;

    for (Match match in regex.allMatches(this)) {
      final fontWeight = match.group(1);
      final colorHex = match.group(2);
      final content = match.group(3);

      if (lastIndex < match.start) {
        spans.add(TextSpan(
          text: substring(lastIndex, match.start),
          style: defaultStyle,
        ));
      }

      FontWeight weight = FontWeight.normal;

      if (fontWeight != null) {
        if (fontWeight == '700') {
          weight = FontWeight.bold;
        } else if (fontWeight == '500') {
          weight = FontWeight.w500;
        } else if (fontWeight == '600') {
          weight = FontWeight.w600;
        }
      }

      Color? color;

      if (colorHex != null) {
        color = Color(int.parse('0xFF$colorHex'.toUpperCase()));
      }

      spans.add(TextSpan(
        text: content,
        style: defaultStyle.copyWith(fontWeight: weight, color: color),
      ));

      lastIndex = match.end;
    }

    if (lastIndex < length) {
      spans.add(TextSpan(
        text: substring(lastIndex),
        style: defaultStyle,
      ));
    }

    return TextSpan(children: spans);
  }
}
