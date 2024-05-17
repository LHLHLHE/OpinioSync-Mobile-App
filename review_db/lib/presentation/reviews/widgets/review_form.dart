import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:review_db/data/reviews/models.dart';
import 'package:review_db/presentation/reviews/bloc/review_page_bloc.dart';
import 'package:review_db/presentation/reviews/bloc/review_page_event.dart';
import 'package:review_db/presentation/reviews/bloc/review_page_state.dart';


class CreateReviewForm extends StatefulWidget {
  const CreateReviewForm({super.key});

  @override
  State<CreateReviewForm> createState() => _CreateReviewFormState();
}

class _CreateReviewFormState extends State<CreateReviewForm> {
  final _formKey = GlobalKey<FormState>();
  double _score = 0;
  final TextEditingController _reviewTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: BlocListener<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state is ReviewLoadedState) {
            Review? review = state.review;
            if (review != null) {
              _score = review.score.toDouble();
              _reviewTextController.text = review.text;
            }
          }
          if (state is ReviewCreatedState || state is ReviewEditedState) {
            Navigator.pop(context, true);
            Navigator.pushReplacementNamed(context, '/title_detail');
          }
        },
        child: BlocBuilder<ReviewBloc, ReviewState>(
          bloc: BlocProvider.of<ReviewBloc>(context)..add(LoadReviewEvent()),
          builder: (context, state) {
            if (state is LoadingReviewState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: state is ReviewErrorState
                    ? Card(child: Text(state.error))
                    : const SizedBox.shrink()
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: RatingBar.builder(
                    initialRating: _score,
                    itemSize: 31.0,
                    wrapAlignment: WrapAlignment.center,
                    minRating: 1,
                    maxRating: 10,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 10,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (score) {
                      _score = score;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextFormField(
                    autocorrect: false,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Текст рецензии'
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: _reviewTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Поле не заполнено';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Center(
                    child: CupertinoButton.filled(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          String reviewText = _reviewTextController.text;
                          int score = _score.toInt();

                          if (state is ReviewLoadedState && state.review != null) {
                            BlocProvider.of<ReviewBloc>(context).add(
                              EditReviewEvent(
                                CreateReview(
                                  reviewText,
                                  score
                                )
                              )
                            );
                          } else {
                            BlocProvider.of<ReviewBloc>(context).add(
                              PostReviewEvent(
                                CreateReview(
                                  reviewText,
                                  score
                                )
                              )
                            );
                          }
                        }
                      },
                      child: const Text('Опубликовать'),
                    ),
                  )
                ),
              ],
            );
          }
        )
      )
    );
  }
}