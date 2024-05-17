import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:review_db/data/comments/models.dart';
import 'package:review_db/presentation/auth/bloc/auth_bloc.dart';
import 'package:review_db/presentation/auth/bloc/auth_event.dart';
import 'package:review_db/presentation/auth/bloc/auth_state.dart';
import 'package:review_db/presentation/comments/bloc/comments_page_bloc.dart';
import 'package:review_db/presentation/comments/bloc/comments_page_event.dart';
import 'package:review_db/presentation/comments/bloc/comments_page_state.dart';
import 'package:review_db/presentation/profile/bloc/profile_page_bloc.dart';
import 'package:review_db/presentation/profile/bloc/profile_page_event.dart';
import 'package:review_db/presentation/profile/bloc/profile_page_state.dart';


class CommentsArea extends StatelessWidget {
  const CommentsArea({super.key, required this.comments});

  final List<Comment> comments;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(         
          padding: const EdgeInsets.only(top: 5.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (BuildContext context, int index) {
            return CommentCard(comment: comments[index]);                                           
          }
        )
      ]
    );
  }
}


class CommentCard extends StatelessWidget {
  const CommentCard({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: BlocListener<CommentsBloc, CommentsState>(
        listener: (context, state) {
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          bloc: BlocProvider.of<AuthBloc>(context)..add(CheckLoggedInEvent()),
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
                                    name: comment.author,
                                    radius: 12,
                                    fontsize: 14,
                                  )
                                ),
                                Text(
                                  comment.author,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ]
                            ),
                            comment.author == stateProfile.user.username ? Row(
                              children: [
                                IconButton(
                                  tooltip: 'Delete comment',
                                  icon: Icon(
                                    size: 18,
                                    CupertinoIcons.delete_simple,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<CommentsBloc>(context).setCommentId(comment.id);
                                    BlocProvider.of<CommentsBloc>(context).add(DeleteCommentEvent());
                                  },
                                ),
                                IconButton(
                                  onPressed: () {
                                    BlocProvider.of<CommentsBloc>(context).setCommentId(comment.id);
                                    BlocProvider.of<CommentsBloc>(context).setCommentText(comment.text);
                                    BlocProvider.of<CommentsBloc>(context).add(EditingCommentEvent());
                                  },
                                  tooltip: 'Edit comment',
                                  icon: Icon(
                                    size: 18,
                                    CupertinoIcons.pencil,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ]
                            ) : const SizedBox()
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Text(comment.text),
                        const SizedBox(height: 10.0,),
                        Text(comment.pubDate),
                      ],
                    )
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
      )
    );
  }
}