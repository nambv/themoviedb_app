import 'package:injectable/injectable.dart';
import 'package:themoviedb_app/data/local/movie_db.dart';
import 'package:themoviedb_app/data/models/movie.dart';
import 'package:themoviedb_app/data/remote/api_endpoint.dart';
import 'package:themoviedb_app/data/remote/client.dart';

import '../data/models/list_data.dart';

@lazySingleton
class MovieRepository {
  final Client _client;
  final MovieDb _database;

  MovieRepository(this._client, this._database);

  Future<List<Movie>> getListMovies({int page = 1}) async {
    final queryParams = <String, dynamic>{"page": page};
    final response = await _client.dio.get(
      DiscoverApi.movie,
      queryParameters: queryParams,
    );

    final data = ListData<Movie>.fromJson(
      response.data,
      (json) => Movie.fromJson(json as Map<String, dynamic>),
    );

    return data.results;
  }

  Future<List<Movie>> getCachedMovies() async {
    final collection = await _database.getMovies();
    return collection.movies;
  }

  Future<List<Movie>> search({String keyword = "", int page = 1}) async {
    final queryParams = <String, dynamic>{"page": page};
    if (keyword != "") {
      queryParams["query"] = keyword;
    }

    final response = await _client.dio.get(
      SearchApi.movie,
      queryParameters: queryParams,
    );

    final data = ListData<Movie>.fromJson(
      response.data,
      (json) => Movie.fromJson(json as Map<String, dynamic>),
    );

    return data.results;
  }

  Future<void> saveMovie(Movie movie) async {
    await _database.storeMovies([movie], isExpanded: true);
  }
}
