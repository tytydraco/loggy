// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Entry _$EntryFromJson(Map<String, dynamic> json) => Entry(
      timestamp: const _TimestampJsonConverter()
          .fromJson((json['timestamp'] as num).toInt()),
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
    )..values = (json['values'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      );

Map<String, dynamic> _$EntryToJson(Entry instance) => <String, dynamic>{
      'timestamp': const _TimestampJsonConverter().toJson(instance.timestamp),
      'rating': instance.rating,
      'values': instance.values,
    };
