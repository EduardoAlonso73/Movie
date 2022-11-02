import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_response.dart';
import '../models/top_reted_response.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = 'e9d7dd5fdf751acf12d008e240ea6e49';
  final String _language = 'en-US';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  List<Movie> topRated = [];
  Map<int, List<Cast>> moviesCast = {};
  int _popularPage = 0;
  final debouncer = Debouncer(duration: Duration(milliseconds: 500));
  final StreamController<List<Movie>> _suggetionStreamCotroller =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream => _suggetionStreamCotroller.stream;

  MoviesProvider() {
    //  print('Movies provider initialized');
    getDisplayMovies();
    getPopularMovies();
    getTopRated();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint,
        {'api_key': _apiKey, 'language': _language, 'page': '$page'});

    final response = await http.get(url);
    return response.body;
  }

  getDisplayMovies() async {
    final jsonData = await _getJsonData('/3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();

    // if(response.statusCode !=200 ) return print('Error');
    // print(nowPlayingResponse.results[0].title);
  }

  getPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData('/3/movie/popular', _popularPage);
    print( "==================== getPopularMovies ===========================");
    print( jsonData);
    final popularResponse = PopularResponse.fromJson(jsonData);
    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  getTopRated() async {
    _popularPage++;
    final jsonData = await _getJsonData('/3/movie/top_rated', _popularPage);
    print( "==================== getTopRated ===========================");
    print( jsonData);
    final topRatedResponse = TopRatedResponse.fromJson(jsonData);
    topRated = [...topRated, ...topRatedResponse.results];
    notifyListeners();
  }


  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;
    print(
        "==================== Pidiendo inf al sevidor ===========================");

    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);
    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }

  void getSuggetionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final result = await searchMovie(value);
      _suggetionStreamCotroller.add(result);
      //print('Tenemosi valor buscar $value');
    };
    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
