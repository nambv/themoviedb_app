// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListData<T> _$ListDataFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ListData<T>(
      results: (json['results'] as List<dynamic>).map(fromJsonT).toList(),
      page: (json['page'] as num).toInt(),
    );
