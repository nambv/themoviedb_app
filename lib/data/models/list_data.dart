import 'package:json_annotation/json_annotation.dart';

part 'list_data.g.dart';

@JsonSerializable(genericArgumentFactories: true, createToJson: false)
class ListData<T> {
  final List<T> results;
  final int page;

  ListData({
    required this.results,
    required this.page,
  });

  factory ListData.fromJson(
          Map<String, dynamic> json, T Function(dynamic json) fromJsonT) =>
      _$ListDataFromJson(json, fromJsonT);
}
