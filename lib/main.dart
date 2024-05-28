import 'package:flutter/material.dart';
import 'package:themoviedb_app/data/local/movie_db.dart';
import 'package:themoviedb_app/moviedb_app.dart';

import 'data/di/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await MovieDb.initialize();
  runApp(const MovieDbApp());
}
