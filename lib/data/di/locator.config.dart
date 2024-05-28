// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:themoviedb_app/data/local/movie_db.dart' as _i4;
import 'package:themoviedb_app/data/remote/client.dart' as _i3;
import 'package:themoviedb_app/repositories/movies_repository.dart' as _i5;
import 'package:themoviedb_app/ui/screens/movies/movies_model.dart' as _i6;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.Client>(() => _i3.Client());
    gh.lazySingleton<_i4.MovieDb>(() => _i4.MovieDb());
    gh.lazySingleton<_i5.MovieRepository>(() => _i5.MovieRepository(
          gh<_i3.Client>(),
          gh<_i4.MovieDb>(),
        ));
    gh.factory<_i6.MoviesModel>(
        () => _i6.MoviesModel(gh<_i5.MovieRepository>()));
    return this;
  }
}
