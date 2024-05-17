import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:review_db/presentation/reviews/bloc/review_page_bloc.dart';
import 'package:review_db/presentation/reviews/widgets/review_form.dart';
import 'package:review_db/presentation/reviews/widgets/title_card.dart';

class CreateReviewScreen extends StatefulWidget {
  const CreateReviewScreen({super.key,});

  @override
  State<CreateReviewScreen> createState() => _CreateReviewState();
}

class _CreateReviewState extends State<CreateReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TitleCard(title: BlocProvider.of<ReviewBloc>(context).title!),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: CreateReviewForm()
            ),
            ],
          ),
      )
    );
  }
}