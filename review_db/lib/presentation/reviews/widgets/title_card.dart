import 'package:flutter/material.dart';
import 'package:review_db/data/titles/models.dart' as titles_data;

class TitleCard extends StatelessWidget {
  const TitleCard({super.key, required this.title});

  final titles_data.Title title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Image(image: title.getImage(), height: 130, width: 91,),
        ),
        Text(
          title.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500
          ),
        ),
      ]
    );
  }
}