import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:review_db/data/reviews/repository.dart';
import 'package:review_db/data/titles/repository.dart';
import 'package:review_db/presentation/title/bloc/title_page_event.dart';
import 'package:review_db/presentation/title/bloc/title_page_state.dart';

class DetailTitleBloc extends Bloc<DetailTitleEvent, DetailTitleState> {
  final TitlesRepository _titlesRepository;
  final ReviewsRepository _reviewsRepository;
  int _titleId = 0;

  void setTitleId(int titleId) {
    _titleId = titleId;
  }

  DetailTitleBloc(this._titlesRepository, this._reviewsRepository) : super(TitleLoadingState()) {
    on<LoadTitleEvent>((event, emit) async {
      emit(TitleLoadingState());
      try {
        final title = await _titlesRepository.getTitleById(_titleId);
        final reviews = await _reviewsRepository.getTitleReviews(_titleId);
        emit(TitleLoadedState(title, reviews));
      } catch (e) {
        emit(TitleErrorState(e.toString()));
      }
    });
  }
}
