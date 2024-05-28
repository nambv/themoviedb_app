import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:themoviedb_app/bases/base_state.dart';
import 'package:themoviedb_app/ui/screens/movies/favorite_dialog.dart';
import 'package:themoviedb_app/ui/screens/movies/movies_model.dart';
import 'package:themoviedb_app/ui/screens/movies/widgets.dart';
import 'package:themoviedb_app/ui/widgets/loading_widget.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends BaseState<MoviesModel, MoviesScreen> {
  late TextEditingController _searchController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(handleScrollForLoadMore);
  }

  void handleScrollForLoadMore() {
    if (_scrollController.position.extentAfter < 100) {
      model.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie DB App"),
      ),
      body: super.build(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showGeneralDialog(
            context: context,
            barrierColor: Colors.black12.withOpacity(0.6),
            // Background color
            barrierDismissible: false,
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (context, __, ___) {
              return FavoriteDialog(movies: model.favoriteMovies);
            },
          );
        },
        backgroundColor: Colors.yellow,
        icon: const Icon(Icons.bookmark, color: Colors.black),
        label: const Text("My favorite"),
      ),
    );
  }

  @override
  buildLoadingView() => const MovieDbLoadingWidget();

  @override
  buildLoadedView(BuildContext context, MoviesModel model) {
    final movies = model.movies;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onChanged: (text) {
              if (text == "") {
                _onClearSearchText();
              }
            },
            onSubmitted: _onSearchExecute,
            decoration: InputDecoration(
              hintText: "Search by title here",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => _onClearSearchText(),
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              contentPadding: const EdgeInsets.all(12),
              filled: true,
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              model.loadData(refresh: true);
            },
            child: ListView.separated(
              shrinkWrap: true,
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              separatorBuilder: (_, __) => const Gap(16),
              itemCount: movies.length,
              itemBuilder: (_, index) {
                return MovieItemListView(movie: movies[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  _onClearSearchText() {
    _searchController.text = "";

    model.keyword = "";
    model.isSearching = false;
    model.loadData(refresh: true);
  }

  _onSearchExecute(String keyword) {
    model.keyword = keyword;
    model.isSearching = true;
    model.loadData(refresh: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
