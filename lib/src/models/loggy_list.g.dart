// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loggy_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoggyList _$LoggyListFromJson(Map<String, dynamic> json) => LoggyList(
      name: json['name'] as String,
      entries: (json['entries'] as List<dynamic>)
          .map((e) => Entry.fromJson(e as Map<String, dynamic>))
          .toSet(),
      trackables:
          (json['trackables'] as List<dynamic>).map((e) => e as String).toSet(),
    );

Map<String, dynamic> _$LoggyListToJson(LoggyList instance) => <String, dynamic>{
      'name': instance.name,
      'entries': instance.entries.toList(),
      'trackables': instance.trackables.toList(),
    };
