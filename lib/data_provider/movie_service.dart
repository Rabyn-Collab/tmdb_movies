import 'package:flutter_theme/data_provider/movies.dart';
import 'package:dio/dio.dart';

class MovieService{

 static Future<List<Movies>> getMovies(int page, String category) async{
   final dio = Dio();
     final response =
     await dio.get('https://api.themoviedb.org/3/movie/$category', queryParameters: {
       'api_key': '2a0f92600c667e19a1f8',
       'language': 'en-Us',
       'page': page
     });
   if(response.statusCode == 200){
     final data =response.data;
     return  (data['results'] as List).map((e) => Movies.fromJson(e)).toList();
   }else{
     return [];
   }
 }

 static Future<List<Movies>> searchMovies(String searchText, int page) async{
   final dio = Dio();
   final response =
   await dio.get('https://api.themoviedb.org/3/search/movie', queryParameters: {
     'api_key': '2a0f926961d0e191461f8',
     'language': 'en-Us',
     'page': page,
     'query': searchText,
   });
   if(response.statusCode == 200){
     final data =response.data;
     return  (data['results'] as List).map((e) => Movies.fromJson(e)).toList();
   }else{
     return [];
   }
 }


}
