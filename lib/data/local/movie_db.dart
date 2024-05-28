import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:themoviedb_app/data/models/movie.dart';

class BoxName {
  static const movies = "movies";
}

@lazySingleton
class MovieDb {
  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<Movie>(MovieAdapter());
    Hive.registerAdapter<MovieCollection>(MovieCollectionAdapter());
  }

  Future<void> storeMovies(List<Movie> data, {bool isExpanded = false}) async {
    const boxName_ = BoxName.movies;

    var box = await Hive.openBox<MovieCollection>(boxName_);
    late MovieCollection newData;

    if (box.containsKey(boxName_) && isExpanded) {
      MovieCollection oldData = box.get(boxName_)!;
      final movies = <Movie>{...oldData.movies, ...data}.toList();
      newData = MovieCollection(movies: movies);
    } else {
      newData = MovieCollection(movies: data);
    }
    box.put(boxName_, newData);
  }

  Future<MovieCollection> getMovies() async {
    const boxName_ = BoxName.movies;

    final box = await Hive.openBox<MovieCollection>(boxName_);
    return box.get(boxName_, defaultValue: MovieCollection(movies: []))!;
  }
}
