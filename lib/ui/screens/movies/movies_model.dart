import 'package:injectable/injectable.dart';
import 'package:themoviedb_app/bases/base_model.dart';
import 'package:themoviedb_app/data/enum.dart';
import 'package:themoviedb_app/data/models/movie.dart';
import 'package:themoviedb_app/repositories/movies_repository.dart';

@injectable
class MoviesModel extends BaseModel {
  final MovieRepository _repository;
  late List<Movie> movies;
  late List<Movie> favoriteMovies = [];
  String keyword = "";

  int page = 1;

  bool isSearching = false;
  bool isRefresh = false;
  bool isLoadMore = false;

  MoviesModel(this._repository);

  @override
  bool get autoLoadData => true;

  @override
  Future<void> executeLoadData({bool refresh = false}) async {
    if (refresh) {
      page = 1;
      isRefresh = false;
    }

    await _loadListItems();
  }

  Future<void> _loadListItems() async {
    final cachedMovies = await _repository.getCachedMovies();
    favoriteMovies =
        cachedMovies.where((element) => element.isFavorite).toList();

    late List<Movie> remoteItems;
    if (isSearching) {
      remoteItems = await _repository.search(keyword: keyword, page: page);
    } else {
      remoteItems = await _repository.getListMovies(page: page);
    }

    for (var i = 0; i < remoteItems.length; i++) {
      final element = remoteItems[i];
      if (cachedMovies.contains(element)) {
        remoteItems[i] =
            cachedMovies.firstWhere((item) => item.id == element.id);
      }
    }

    if (remoteItems.isNotEmpty) {
      if (isLoadMore) {
        movies.addAll(remoteItems);
      } else {
        movies = remoteItems;
      }
      page++;
    }
  }

  Future loadMore() async {
    try {
      if (viewState == ViewState.loading || isLoadMore) {
        return;
      }

      setLoadMore(true, notify: true);

      await Future.delayed(const Duration(milliseconds: 500));
      await _loadListItems();

      setLoadMore(false);
      setState(ViewState.loaded, forceUpdate: true);
    } catch (error, stacktrace) {
      setLoadMore(false);
    }
  }

  setLoadMore(bool value, {bool notify = false}) {
    isLoadMore = value;
    if (notify) notifyListeners();
  }

  toggleFavorite(Movie movie) {
    movie.isFavorite = !movie.isFavorite;
    _repository.saveMovie(movie);

    if (movie.isFavorite) {
      favoriteMovies.add(movie);
    } else {
      favoriteMovies.remove(movie);
    }
    notifyListeners();
  }

  @override
  handleErrorState(error, stacktrace) async {
    movies = await _repository.getCachedMovies();
    setState(ViewState.loaded);
  }
}
