import 'package:flutter/material.dart';

TextSpan buildHighlightedTitle(
  String title,
  String searchQuery,
  bool isCompleted,
) {
  if (searchQuery.isEmpty) {
    return TextSpan(
      text: title,
      style: TextStyle(
        color: isCompleted ? Colors.grey[500] : Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        decoration:
            isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
        decorationColor: Colors.grey[800],
        decorationThickness: 3,
      ),
    );
  }

  final List<TextSpan> spans = [];
  final String lowerText = title.toLowerCase();
  final String lowerQuery = searchQuery.toLowerCase();
  int start = 0;

  while (true) {
    final int index = lowerText.indexOf(lowerQuery, start);
    if (index == -1) {
      if (start < title.length) {
        spans.add(createTextSpan(title.substring(start), isCompleted, false));
      }
      break;
    }

    if (index > start) {
      spans.add(
        createTextSpan(title.substring(start, index), isCompleted, false),
      );
    }

    spans.add(
      createTextSpan(
        title.substring(index, index + searchQuery.length),
        isCompleted,
        true,
      ),
    );

    start = index + searchQuery.length;
  }

  return TextSpan(children: spans);
}

TextSpan createTextSpan(String text, bool isCompleted, bool isHighlighted) {
  return TextSpan(
    text: text,
    style: TextStyle(
      color:
          isHighlighted
              ? (isCompleted ? Colors.orange[300] : Colors.yellow[300])
              : (isCompleted ? Colors.grey[500] : Colors.white),
      backgroundColor:
          isHighlighted ? Colors.yellow[700]?.withOpacity(0.3) : null,
      fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
      decoration:
          isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
      decorationColor: Colors.grey[800],
      decorationThickness: 3,
    ),
  );
}
