import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_theme/data_provider/initial_state.dart';
import 'package:flutter_theme/data_provider/movie_service.dart';
import 'package:flutter_theme/data_provider/movies.dart';

class Toggle extends StateNotifier<bool>{
  Toggle([bool state]) : super(state ?? true);

  void toggle(){
    state = false;
  }

}
final toggleProvider =StateNotifierProvider.autoDispose<Toggle, bool>((ref) => Toggle());
final dbProvider = StateNotifierProvider<Db, MainState>((ref) => Db());


class Db extends StateNotifier<MainState>{
  Db([MainState state]) : super(state ?? MainState.initial()) {
    getMovies();
  }

List<Movies> _movies = [];

  Future<void> getMovies() async {
    if(state.searchText.isEmpty){
      if(state.category == Category.popular){
 _movies = await MovieService.getMovies(state.page, state.category);
      }else if(state.category == Category.topRated){
        _movies = await MovieService.getMovies(state.page, state.category);
      }else if(state.category == Category.upcoming){
        _movies = await MovieService.getMovies(state.page, state.category);
      }

    }else{
      _movies = await MovieService.searchMovies(state.searchText, state.page);
    }

    state = state.copyWith(
        movies: [...state.movies, ..._movies,],
        page:  state.page + 1
    );
  }

void updatedCategory(String category){
    state = state.copyWith(
      movies: [],
      page: 1,
      searchText: '',
      category: category
    );
    getMovies();
}


void searchMovies(String searchText){
    state = state.copyWith(
      searchText: searchText,
      movies: [],
      page: 1,
      category: Category.none
    );
    getMovies();
}

}

final videoProvider = FutureProvider.family.autoDispose((ref, id) => Video().getId(id));
class Video {

  Future<String> getId(int id) async{
    final dio = Dio();
    final response =  await dio.get('https://api.themoviedb.org/3/movie/$id/videos', queryParameters: {
      'api_key':'2a0f926961d00c667e191a21c14461f8',
      'language': 'en-US',
    });
  return response.data['results'][0]['key'];

  }

}