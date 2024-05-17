import 'package:flutter/material.dart';
import 'package:review_db/data/reviews/models.dart';
import 'package:review_db/data/titles/models.dart' as titles_data;
import 'package:review_db/presentation/title/widgets/reviews.dart';
import 'package:review_db/presentation/title/widgets/title_info.dart';


class TitleSliverAppBar extends StatelessWidget {
  const TitleSliverAppBar({super.key, required this.title});

  final titles_data.Title title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      toolbarHeight: 50.0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20.0,
          color: Colors.white,
        ),
      ),
      expandedHeight: 450.0,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20.0)
        ),
        background: Stack(
          children: [
            OverflowBox(
              alignment: Alignment.topCenter,
              maxHeight: double.infinity,
              child: Image(
                image: title.getImage(),
                fit: BoxFit.cover
              ),
            ),
            Positioned.fill(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(1.0), Colors.transparent],
                  ),
                ),
                height: 100,
              ),
            ),
          ]
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(5.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ),
          ),
        ),
      ),
    );
  }
}


class TitleSliverToBoxAdapter extends StatelessWidget {
  const TitleSliverToBoxAdapter({
    super.key,
    required this.title,
    required this.reviews
  });

  final titles_data.Title title;
  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 5.0,
          bottom: 15.0,
          left: 10.0,
          right: 10.0
        ),
        child: Column(
          children: [
            Column(
              children: [
                TitleInfo(title: title),
                ReviewsArea(reviews: reviews, title: title)
              ],
            )
          ]
        )
      )
    );
  }
}
