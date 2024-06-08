import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:themoviedb_app/data/models/movie.dart';
import 'package:themoviedb_app/ui/widgets/moviedb_image.dart';

class FavoriteDialog extends StatefulWidget {
  final List<Movie> movies;

  const FavoriteDialog({super.key, required this.movies});

  @override
  State<FavoriteDialog> createState() => _FavoriteDialogState();
}

class _FavoriteDialogState extends State<FavoriteDialog> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Material(
              color: Colors.transparent,
              child: Ink(
                decoration: const ShapeDecoration(
                  shape: CircleBorder(),
                  color: Colors.white12,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.yellow),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
          Center(
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                      disableCenter: false,
                      aspectRatio: 2 / 3,
                      enlargeCenterPage: true,
                      autoPlay: false,
                      viewportFraction: 0.72,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() => _current = index);
                      },
                    ),
                    items: widget.movies.map((item) {
                      return MovieDbImage(item.fullPath,
                          height: 172, fit: BoxFit.contain);
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.movies.asMap().entries.map((entry) {
                      return Container(
                        width: 12.0,
                        height: 12.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.yellow.withOpacity(
                                _current == entry.key ? 0.9 : 0.4)),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
