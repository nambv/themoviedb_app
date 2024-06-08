import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:themoviedb_app/bases/base_state.dart';
import 'package:themoviedb_app/ui/screens/movies/favorite_dialog.dart';
import 'package:themoviedb_app/ui/screens/movies/movies_model.dart';
import 'package:themoviedb_app/ui/screens/movies/widgets.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends BaseState<MoviesModel, MoviesScreen> {
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  Timer? _debounce;

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
        title: const Text(
          "Movie DB App",
          style: TextStyle(color: Colors.yellow),
        ),
      ),
      body: super.build(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final favoriteMovies = model.favoriteMovies;
          if (favoriteMovies.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You haven\'t favorite any movie yet'),
              ),
            );
            return;
          }

          showGeneralDialog(
            context: context,
            barrierColor: Colors.black12.withOpacity(0.6),
            // Background color
            barrierDismissible: false,
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (context, __, ___) {
              return FavoriteDialog(movies: favoriteMovies);
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
  buildLoadingView() {
    return Column(
      children: [
        _searchTextField,
        Expanded(
          child: ListView.separated(
            itemCount: 10,
            shrinkWrap: true,
            itemBuilder: (_, __) => const MovieItemShimmer(),
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const Gap(16),
          ),
        ),
      ],
    );
  }

  @override
  buildLoadedView(BuildContext context, MoviesModel model) {
    final movies = model.movies;

    return Column(
      children: [
        _searchTextField,
        Expanded(
          child: movies.isEmpty
              ? _buildEmptyView()
              : RefreshIndicator(
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

  _buildEmptyView() {
    return const Center(
      child: Text("No data to display"),
    );
  }

  Widget get _searchTextField => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: TextField(
          controller: _searchController,
          cursorColor: Colors.yellow,
          textInputAction: TextInputAction.search,
          onChanged: (text) {
            if (_debounce?.isActive ?? false) _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 500), () {
              if (text == "") {
                _onClearSearchText();
              } else {
                _onSearchExecute(text);
              }
            });
          },
          decoration: InputDecoration(
            hintText: "Search by title here",
            hintStyle: TextStyle(color: Colors.yellow[200]),
            prefixIcon: const Icon(Icons.search, color: Colors.yellow),
            suffixIcon: _searchController.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => _onClearSearchText(),
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.yellow),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.yellow),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.yellow),
              borderRadius: BorderRadius.circular(12.0),
            ),
            contentPadding: const EdgeInsets.all(12),
            filled: true,
          ),
        ),
      );

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
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
