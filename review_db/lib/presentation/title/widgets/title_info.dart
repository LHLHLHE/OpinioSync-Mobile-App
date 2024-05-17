import 'package:flutter/material.dart';
import 'package:review_db/data/titles/models.dart' as titles_data;
import 'package:review_db/presentation/core/utils.dart';

class TitleInfo extends StatelessWidget {
  const TitleInfo({super.key, required this.title});

  final titles_data.Title title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            TitleInfoContainer(text: title.year.toString(),),
            TitleInfoContainer(text: title.category.name,),
            for (var genre in title.genres)
              TitleInfoContainer(text: genre.name),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: getColorFromRating(title.rating),
                size: 20.0,
              ),
              Text(
                title.rating.toString(),
                style: TextStyle(
                  color: getColorFromRating(title.rating),
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(title.description),
        ),
      ]
    );
  }
}


class TitleInfoContainer extends StatelessWidget {
  const TitleInfoContainer({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(20.0),
          right: Radius.circular(20.0)
        )
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
