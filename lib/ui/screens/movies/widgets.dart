import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb_app/data/models/movie.dart';
import 'package:themoviedb_app/ui/screens/movies/movies_model.dart';
import 'package:themoviedb_app/ui/widgets/moviedb_image.dart';

class MovieItemListView extends StatelessWidget {
  final Movie movie;

  const MovieItemListView({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MovieDbImage(movie.fullPath, height: 96, width: 64),
            const Gap(12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.originalTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(4),
                  Text(movie.releaseDate),
                  const Gap(4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.yellow),
                      const Gap(4),
                      Text(
                        movie.voteAverage.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            onPressed: () {
              final model = context.read<MoviesModel>();
              model.toggleFavorite(movie);
            },
            icon: Icon(
              movie.isFavorite ? Icons.bookmark : Icons.bookmark_border,
              size: 24,
              color: Colors.yellow,
            ),
          ),
        ),
      ],
    );
  }
}
