import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:review_db/data/titles/models.dart' as titles_data;
import 'package:review_db/presentation/core/utils.dart';
import 'package:review_db/presentation/title/bloc/title_page_bloc.dart';


class TitleListTile extends StatelessWidget {
  const TitleListTile({super.key, required this.title});

  final titles_data.Title title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        BlocProvider.of<DetailTitleBloc>(context).setTitleId(title.id);
        Navigator.pushNamed(
          context,
          '/title_detail',
        );
      },
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image(image: title.getImage(), height: 130, width: 91,),
          ),
          const SizedBox(width: 10.0,),
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${title.year}, ${title.category.name}',
                  style: const TextStyle(fontSize: 13.0),
                ),
                Text(
                  List<String>.generate(
                    title.genres.length,
                    (int index) => title.genres[index].name,
                    growable: false
                  ).join(', '),
                  style: const TextStyle(fontSize: 13.0),
                )
              ],
            ),
          ),
          const Spacer(),
          Container(
            width: 42.0,
            height: 23.0,
            decoration: BoxDecoration(
              color: getColorFromRating(title.rating),
              borderRadius: const BorderRadius.all(Radius.circular(20))
              ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.white, size: 15.0,),
                Text(title.rating.toString(), style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.0
                ),)
              ],
            )
          )
        ],
      )
    );
  }
}
