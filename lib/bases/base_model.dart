import 'package:flutter/foundation.dart';

import '../data/enum.dart';

abstract class BaseModel extends ChangeNotifier {
  ViewState viewState = ViewState.initial;
  dynamic error;
  StackTrace? stackTrace;

  bool get autoLoadData => false;

  BaseModel() {
    if (autoLoadData) loadData();
  }

  Future<void> loadData({bool refresh = false}) async {
    try {
      if (!refresh) setState(ViewState.loading);
      await executeLoadData(refresh: refresh);

      setState(ViewState.loaded, forceUpdate: true);
    } catch (error, stacktrace) {
      handleErrorState(error, stacktrace);
    }
  }

  handleErrorState(error, stacktrace);

  setState(
    ViewState newState, {
    forceUpdate = false,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (!forceUpdate && viewState == newState) return;
    viewState = newState;
    if (viewState == ViewState.error) {
      this.error = error;
      this.stackTrace = stackTrace;
    }
    notifyListeners();
  }

  Future<void> executeLoadData({bool refresh = false}) async => Future.value();
}
