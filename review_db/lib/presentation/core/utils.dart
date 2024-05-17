import 'package:flutter/material.dart';

Color getColorFromRating(int rating) {
  if (rating >= 6) {
    return const Color.fromARGB(243, 11, 174, 30);
  }
  else if (rating == 5) {
    return Colors.grey;
  }
  else {
    return Colors.red;
  }
}