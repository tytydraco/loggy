// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rating _$RatingFromJson(Map<String, dynamic> json) => Rating(
      value: (json['value'] as num).toInt(),
      name: json['name'] as String,
      color:
          const _ColorJsonConverter().fromJson((json['color'] as num).toInt()),
    );

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'value': instance.value,
      'name': instance.name,
      'color': const _ColorJsonConverter().toJson(instance.color),
    };
