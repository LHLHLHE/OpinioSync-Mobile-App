import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:review_db/data/reviews/models.dart';
import 'package:review_db/presentation/auth/bloc/auth_bloc.dart';
import 'package:review_db/presentation/auth/bloc/auth_event.dart';
import 'package:review_db/presentation/auth/bloc/auth_state.dart';
import 'package:review_db/presentation/comments/bloc/comments_page_bloc.dart';
import 'package:review_db/presentation/core/utils.dart';
import 'package:review_db/presentation/profile/bloc/profile_page_bloc.dart';
import 'package:review_db/presentation/profile/bloc/profile_page_event.dart';
import 'package:review_db/presentation/profile/bloc/profile_page_state.dart';
import 'package:review_db/presentation/reviews/bloc/review_page_bloc.dart';
import 'package:review_db/data/titles/models.dart' as titles_data;
import 'package:review_db/presentation/reviews/bloc/review_page_event.dart';
import 'package:review_db/presentation/reviews/bloc/review_page_state.dart';
import 'package:review_db/presentation/title/bloc/title_page_bloc.dart';
import 'package:review_db/presentation/title/bloc/title_page_event.dart';


class ReviewsArea extends StatelessWidget {
  const ReviewsArea({super.key, required this.reviews, required this.title});

  final List<Review> reviews;
  final titles_data.Title title;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewBloc, ReviewState>(
      listener: (context, state) {
        if (state is ReviewDeletedState) {
          BlocProvider.of<DetailTitleBloc>(context).add(LoadTitleEvent());
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        bloc: BlocProvider.of<AuthBloc>(context)..add(LoggedInEvent()),
        builder: (context, stateAuth) {
          BlocProvider.of<ProfileBloc>(context).setToken(stateAuth.props[0].toString());
          return BlocBuilder<ProfileBloc, ProfileState>(
            bloc: BlocProvider.of<ProfileBloc>(context)..add(LoadProfileEvent()),
            builder: (context, stateProfile) { 
              if (stateProfile is ProfileLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (stateProfile is ProfileLoadedState) {   
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Рецензии',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0
                          ),
                        ),
                        reviews.any((element) => element.author == stateProfile.user.username) ? Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                BlocProvider.of<ReviewBloc>(context).setTitle(title);
                                BlocProvider.of<ReviewBloc>(context).setReviewId(reviews.firstWhere((element) => element.author == stateProfile.user.username).id);
                                BlocProvider.of<ReviewBloc>(context).setToken(stateAuth.props[0].toString());
                                BlocProvider.of<ReviewBloc>(context).add(DeleteReviewEvent());
                              },
                              tooltip: 'Delete review',
                              icon: Icon(
                                size: 18,
                                CupertinoIcons.delete_simple,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                BlocProvider.of<ReviewBloc>(context).setTitle(title);
                                BlocProvider.of<ReviewBloc>(context).setReviewId(reviews.firstWhere((element) => element.author == stateProfile.user.username).id);
                                BlocProvider.of<ReviewBloc>(context).setToken(stateAuth.props[0].toString());
                                Navigator.pushNamed(
                                  context,
                                  '/create_review',
                                );
                              },
                              tooltip: 'Edit review',
                              icon: Icon(
                                size: 18,
                                CupertinoIcons.pencil,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ]
                        ) : IconButton(
                          onPressed: () {
                            BlocProvider.of<ReviewBloc>(context).setTitle(title);
                            BlocProvider.of<ReviewBloc>(context).setToken(stateAuth.props[0].toString());
                            Navigator.pushNamed(
                              context,
                              '/create_review',
                            );
                          },
                          tooltip: 'New review',
                          icon: Icon(
                            CupertinoIcons.add,
                            size: 30.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ]
                    ),
                    ListView.builder(         
                      padding: const EdgeInsets.only(top: 5.0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: reviews.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ReviewCard(review: reviews[index], token: stateAuth.props[0].toString());                                           
                      }
                    )
                  ]
                );
              }
              if (stateProfile is ProfileErrorState) {
                return Center(
                  child: Text(stateProfile.error.toString()),
                );
              }
              return Container();
            }
          );
        }
      )
    );
  }
}


class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review, required this.token});

  final Review review;
  final String token;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: 
      Padding(
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
                        fontsize: 17
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
            const Divider(
              thickness: 1.0,
              height: 10.0
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<CommentsBloc>(context).setTitleId(review.title);
                BlocProvider.of<CommentsBloc>(context).setReview(review);
                BlocProvider.of<CommentsBloc>(context).setToken(token);
                Navigator.pushNamed(
                  context,
                  '/comments',
                );
              },
              child: Row(
                children: [
                  Text(
                    'Комментарии',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15.0
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ]
              )
            )
          ],
        )
      )
    );
  }
}
