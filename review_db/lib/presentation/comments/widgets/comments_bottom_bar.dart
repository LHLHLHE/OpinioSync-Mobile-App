import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:review_db/data/comments/models.dart';
import 'package:review_db/presentation/comments/bloc/comments_page_bloc.dart';
import 'package:review_db/presentation/comments/bloc/comments_page_event.dart';
import 'package:review_db/presentation/comments/bloc/comments_page_state.dart';


class CommentsBottomAppBar extends StatelessWidget {
  CommentsBottomAppBar({super.key});

  final _commentFormKey = GlobalKey<FormState>();
  final TextEditingController _commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _commentFormKey,
      child: BlocListener<CommentsBloc, CommentsState>(
        listener: (context, state) {
          if (state is EditingCommentState) {
            _commentTextController.text = BlocProvider.of<CommentsBloc>(context).getCommentText();
          }
          // if (state is CommentCreatedState) {
          //   BlocProvider.of<CommentsBloc>(context).add(LoadCommentsEvent());
          // }
        },
        child: BlocBuilder<CommentsBloc, CommentsState>(
          bloc: BlocProvider.of<CommentsBloc>(context),
          builder: (context, state) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20.0, left: 10.0),
                child: Row(
                  children: [
                    Flexible(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 30.0,
                          maxHeight: 130.0,
                        ),
                        child: Scrollbar(
                          child: TextFormField(
                            autocorrect: false,
                            controller: _commentTextController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Поле не заполнено';
                              }
                              return null;
                            },
                            cursorColor: Theme.of(context).colorScheme.primary,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1.0
                                ),
                                borderRadius: BorderRadius.circular(25.0)
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1.0
                                ),
                                borderRadius: BorderRadius.circular(30.0)
                              ),
                              contentPadding: const EdgeInsets.only(
                                top: 2.0,
                                left: 13.0,
                                right: 13.0,
                                bottom: 2.0
                              ),
                              hintText: "Напишите комментарий",
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        size: 25,
                        CupertinoIcons.arrow_up_circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        if (_commentFormKey.currentState!.validate()) {
                          CommentsBloc commentsBloc = BlocProvider.of<CommentsBloc>(context);
                          if (commentsBloc.getCommentText() != '') {
                            commentsBloc.add(
                              EditCommentEvent(
                                CreateComment(
                                  _commentTextController.text,
                                )
                              )
                            );
                            commentsBloc.setCommentText('');
                          } else {
                            commentsBloc.add(
                              PostCommentEvent(
                                CreateComment(
                                  _commentTextController.text,
                                )
                              )
                            );
                          }
                          _commentTextController.clear();
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                      },
                    ),
                  ],
                )
              )
            );
          }
        )
      )
    );
  }
}
