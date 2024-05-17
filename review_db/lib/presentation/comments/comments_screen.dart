import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:review_db/presentation/comments/bloc/comments_page_bloc.dart';
import 'package:review_db/presentation/comments/bloc/comments_page_event.dart';
import 'package:review_db/presentation/comments/bloc/comments_page_state.dart';
import 'package:review_db/presentation/comments/widgets/comments.dart';
import 'package:review_db/presentation/comments/widgets/comments_bottom_bar.dart';
import 'package:review_db/presentation/comments/widgets/review.dart';
import 'package:review_db/presentation/core/widgets/app_bar.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Комментарии', parent: widget),
      body: BlocListener<CommentsBloc, CommentsState>(
        listener: (context, state) {
          if (state is CommentCreatedState || state is CommentDeletedState || state is CommentEditedState || state is EditingCommentState) {
            BlocProvider.of<CommentsBloc>(context).add(LoadCommentsEvent());
          }
        },
        child: BlocBuilder<CommentsBloc, CommentsState>(
          bloc: BlocProvider.of<CommentsBloc>(context)..add(LoadCommentsEvent()),
          builder: (context, state) {
            if (state is CommentsLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is CommentsLoadedState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Review(review: state.review),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 10,
                        bottom: 15
                      ),
                      child: CommentsArea(comments: state.comments))
                  ]
                )
              );
            }
            if (state is CommentsErrorState) {
              return Center(
                child: Text(state.error.toString()),
              );
            }
            return Container();
          }
        )
      ),
      bottomNavigationBar: CommentsBottomAppBar()
    );
  }
}