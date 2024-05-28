import 'package:get_it/get_it.dart' show GetIt;
import 'package:injectable/injectable.dart' show injectableInit;

import 'locator.config.dart';

final GetIt locator = GetIt.instance;

@injectableInit
void configureDependencies() {
  locator.init();
}
