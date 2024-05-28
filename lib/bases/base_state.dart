import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb_app/data/enum.dart';
import 'package:themoviedb_app/ui/widgets/loading_widget.dart';

import '../data/di/locator.dart';
import 'base_model.dart';

abstract class BaseState<M extends BaseModel, S extends StatefulWidget>
    extends State<S> {
  late M model;

  @override
  void initState() {
    super.initState();
    createModel();
    onModelReady();
  }

  createModel() => model = locator<M>();

  void onModelReady() {
    // Inherit function
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<M>.value(
      value: model,
      child: Consumer<M>(
        builder: (context, model, child) => buildViewByState(context, model),
      ),
    );
  }

  Widget buildViewByState(BuildContext context, M model) {
    switch (model.viewState) {
      case ViewState.loading:
        return buildLoadingView();
      case ViewState.error:
        return buildErrorView(context, model);
      case ViewState.loaded:
        return buildLoadedView(context, model);
      default:
        return Container(color: Colors.white);
    }
  }

  buildLoadingView() => const MovieDbLoadingWidget();

  buildErrorView(BuildContext context, M model) {
    return const Center(
      child: Text("Error here"),
    );
  }

  buildLoadedView(BuildContext context, M model);

  void onRetry() => model.loadData();

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }
}
