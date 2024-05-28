import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@HiveType(typeId: 0)
@JsonSerializable(createToJson: false)
class Movie {
  @HiveField(0)
  int id;
  @HiveField(1)
  String originalTitle;
  @HiveField(2)
  String posterPath;
  @HiveField(3)
  String releaseDate;
  @HiveField(4)
  String title;
  @HiveField(5)
  double voteAverage;
  @HiveField(6)
  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  bool isFavorite;

  Movie({
    required this.id,
    this.originalTitle = "",
    this.posterPath = "",
    this.releaseDate = "",
    this.title = "",
    this.voteAverage = 0,
    this.isFavorite = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  String get fullPath {
    return "https://image.tmdb.org/t/p/original/$posterPath";
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Movie && runtimeType == other.runtimeType && id == other.id;
}

@HiveType(typeId: 1)
class MovieCollection {
  @HiveField(0)
  List<Movie> movies;

  MovieCollection({required this.movies});
}
