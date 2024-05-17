import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:review_db/presentation/title/bloc/title_page_bloc.dart';
import 'package:review_db/presentation/title/bloc/title_page_event.dart';
import 'package:review_db/presentation/title/bloc/title_page_state.dart';
import 'package:review_db/presentation/title/widgets/title_details.dart';

class DetailTitle extends StatefulWidget {
  const DetailTitle({super.key});

  @override
  State<DetailTitle> createState() => _DetailTitleState();
}

class _DetailTitleState extends State<DetailTitle> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailTitleBloc, DetailTitleState>(
        bloc: BlocProvider.of<DetailTitleBloc>(context)..add(LoadTitleEvent()),
        builder: (context, state) {
          if (state is TitleLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is TitleLoadedState) {
            return CustomScrollView(
              slivers: [
                TitleSliverAppBar(title: state.title),
                TitleSliverToBoxAdapter(
                  title: state.title,
                  reviews: state.reviews,
                ),
              ]
            );
          }
          if (state is TitleErrorState) {
            return Center(
              child: Text(state.error.toString()),
            );
          }
          return Container();
        }
      ),
    );
  }
}
