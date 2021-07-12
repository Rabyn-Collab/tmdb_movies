import 'package:flutter_theme/data_provider/movies.dart';
class Category{
  static String popular = 'popular';
  static String upcoming = 'upcoming';
  static String topRated = 'top_rated';
 static String none = '';
}



class MainState{
List<Movies> movies;
int page;
String category;
String searchText;

MainState({this.category, this.movies, this.page, this.searchText});

MainState.initial():
    movies =[],
page = 1,
category = Category.popular,
searchText= '';

MainState copyWith({List<Movies> movies, int page,
    String category,String searchText}){
  return MainState(
  movies: movies ?? this.movies,
    page: page ?? this.page,
    category: category ?? this.category,
    searchText: searchText ?? this.searchText
  );
}

}