import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:review_db/presentation/core/widgets/app_bar.dart';
import 'package:review_db/presentation/home/bloc/home_page_bloc.dart';
import 'package:review_db/presentation/home/bloc/home_page_event.dart';
import 'package:review_db/presentation/home/bloc/home_page_state.dart';
import 'package:review_db/presentation/home/widgets/title_card.dart';
import 'package:review_db/data/titles/models.dart' as titles_data;

final titles_data.Category _defaultSelectedCategory = titles_data.Category('Все', '');
final titles_data.Genre _defaultSelectedGenre = titles_data.Genre('Все', '');

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _filterIsSelected = false;

  titles_data.Category _selectedCategory = _defaultSelectedCategory;
  titles_data.Genre _selectedGenre = _defaultSelectedGenre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Главная', parent: widget),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 7.0, right: 7.0),
            child: CupertinoSearchTextField(
              onChanged: (value) {
                searchTitle(value);
              },
              onSubmitted: (value) {
                searchTitle(value);
              },
            )
          ),
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              bloc: BlocProvider.of<HomeBloc>(context)..add(LoadTitlesEvent()),
              builder: (context, state) {
                if (state is TitlesLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is TitlesLoadedState) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: DropdownSearch<titles_data.Category>(
                                selectedItem: _selectedCategory,
                                itemAsString: (titles_data.Category category) => category.name,
                                items: [_defaultSelectedCategory,...state.categories],
                                dropdownDecoratorProps: const DropDownDecoratorProps(
                                  baseStyle: TextStyle(fontSize: 12.0),
                                  dropdownSearchDecoration: InputDecoration(
                                    labelStyle: TextStyle(fontSize: 10.0),
                                    labelText: 'Категория',
                                    hintText: 'Выбор категории',
                                  ),
                                ),
                                onChanged: (titles_data.Category? category) {
                                  if (category == _defaultSelectedCategory) {
                                    BlocProvider.of<HomeBloc>(context).setCategoryFilterValue(null);
                                    setState(() {
                                      if (_selectedGenre == _defaultSelectedGenre) {
                                        _filterIsSelected = false;
                                      }
                                      _selectedCategory = category!;
                                    });
                                  } else {
                                    BlocProvider.of<HomeBloc>(context).setCategoryFilterValue(category!.slug);
                                    setState(() {
                                      _filterIsSelected = true;
                                      _selectedCategory = category;
                                    });
                                  }
                                },
                              )
                            ),
                            Expanded(
                              child: DropdownSearch<titles_data.Genre>(
                                selectedItem: _selectedGenre,
                                itemAsString: (titles_data.Genre genre) => genre.name,
                                items: [_defaultSelectedGenre,...state.genres],
                                dropdownDecoratorProps: const DropDownDecoratorProps(
                                  baseStyle: TextStyle(fontSize: 12.0),
                                  dropdownSearchDecoration: InputDecoration(
                                    labelStyle: TextStyle(fontSize: 10.0),
                                    labelText: 'Жанр',
                                    hintText: 'Выбор жанра',
                                  ),
                                ),
                                onChanged: (titles_data.Genre? genre) {
                                  if (genre == _defaultSelectedGenre) {
                                    BlocProvider.of<HomeBloc>(context).setGenreFilterValue(null);
                                    setState(() {
                                      if (_selectedCategory == _defaultSelectedCategory) {
                                        _filterIsSelected = false;
                                      }
                                      _selectedGenre = genre!;
                                    });
                                  } else {
                                    BlocProvider.of<HomeBloc>(context).setGenreFilterValue(genre!.slug);
                                    setState(() {
                                      _filterIsSelected = true;
                                      _selectedGenre = genre;
                                    });
                                  }
                                },
                              )
                            ),
                          ],
                        )
                      ),
                      _filterIsSelected == true ? TextButton(
                        onPressed: () {
                          HomeBloc bloc = BlocProvider.of<HomeBloc>(context);
                          bloc.setCategoryFilterValue(null);
                          bloc.setGenreFilterValue(null);
                          bloc.add(LoadTitlesEvent());
                          setState(() {
                            _filterIsSelected = false;
                            _selectedCategory = _defaultSelectedCategory;
                            _selectedGenre = _defaultSelectedGenre;
                          });
                        },
                        child: const Text('Сбросить все')
                      ) : const SizedBox(),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            BlocProvider.of<HomeBloc>(context).add(LoadTitlesEvent());
                          },
                          child: ListView.builder(                                                  
                            itemCount: state.titles.length,
                            itemBuilder: (BuildContext context, int index) {
                              return TitleListTile(title: state.titles[index]);                                           
                            }
                          )
                        )
                      ),
                    ]
                  );
                }
                if (state is TitlesErrorState) {
                  return Center(
                    child: Text(state.error.toString()),
                  );
                }
                return Container();
              }
            )
          ),
        ]
      )
    );
  }

  void searchTitle(String value) {
    HomeBloc bloc = BlocProvider.of<HomeBloc>(context);
    bloc.setSearchValue(value);
    bloc.add(LoadTitlesEvent());
  }
}
