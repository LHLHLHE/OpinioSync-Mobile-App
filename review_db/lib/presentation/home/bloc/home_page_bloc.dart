import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:review_db/data/titles/repository.dart';
import 'package:review_db/presentation/home/bloc/home_page_event.dart';
import 'package:review_db/presentation/home/bloc/home_page_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TitlesRepository _titlesRepository;
  
  String? _searchValue = null;
  String? _categoryFilterValue = null;
  String? _genreFilterValue = null;

  void setSearchValue(String searchValue) {
    _searchValue = searchValue;
  }

  void setCategoryFilterValue(String? categoryFilterValue) {
    _categoryFilterValue = categoryFilterValue;
  }

  void setGenreFilterValue(String? genreFilterValue) {
    _genreFilterValue = genreFilterValue;
  }

  HomeBloc(this._titlesRepository) : super(TitlesLoadingState()) {
    on<LoadTitlesEvent>((event, emit) async {
      emit(TitlesLoadingState());
      try {
        final titles = await _titlesRepository.getTitles(
          category: _categoryFilterValue,
          genre: _genreFilterValue,
          name: _searchValue
        );
        final categories = await _titlesRepository.getCategories();
        final genres = await _titlesRepository.getGenres();
        emit(TitlesLoadedState(titles, categories, genres));
      } catch (e) {
        emit(TitlesErrorState(e.toString()));
      }
    });
  }
}
