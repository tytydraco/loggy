// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Entry _$EntryFromJson(Map<String, dynamic> json) => Entry(
      timestamp: const _TimestampJsonConverter()
          .fromJson((json['timestamp'] as num).toInt()),
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
      trackables: (json['trackables'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$EntryToJson(Entry instance) => <String, dynamic>{
      'timestamp': const _TimestampJsonConverter().toJson(instance.timestamp),
      'rating': instance.rating,
      'trackables': instance.trackables,
    };
