import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:review_db/data/reviews/models.dart' as reviews_data;
import 'package:review_db/presentation/core/utils.dart';


class Review extends StatelessWidget {
  const Review({super.key, required this.review});

  final reviews_data.Review review;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: ProfilePicture(
                      name: review.author,
                      radius: 15,
                      fontsize: 17,
                    )
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.author, style: const TextStyle(fontWeight: FontWeight.bold),),
                      Text(review.pubDate),
                    ],
                  )
                ]
              ),
              Container(
                width: 50.0,
                height: 25.0,
                decoration: BoxDecoration(
                  color: getColorFromRating(review.score),
                  borderRadius: const BorderRadius.all(Radius.circular(20))
                  ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 20.0,),
                    Text(
                      review.score.toString(),
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                )
              )
            ],
          ),
          const SizedBox(height: 10.0,),
          Text(review.text),
        ],
      )
    );
  }
}