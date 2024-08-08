import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'rating.g.dart';

/// An entry rating.
@immutable
@JsonSerializable()
class Rating {
  /// Creates a new [Rating].
  const Rating({
    required this.value,
    required this.name,
    required this.color,
  });

  /// Creates a new [Rating] from a JSON map.
  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);

  /// The integer value.
  final int value;

  /// The display name.
  final String name;

  /// The rating color.
  @_ColorJsonConverter()
  final Color color;

  /// Converts the rating to a JSON object.
  Map<String, dynamic> toJson() => _$RatingToJson(this);

  @override
  bool operator ==(Object other) =>
      other is Rating &&
      other.runtimeType == runtimeType &&
      other.value == value &&
      other.name == name &&
      other.color.value == color.value;

  @override
  int get hashCode => Object.hash(value, name, color.value);
}

class _ColorJsonConverter extends JsonConverter<Color, int> {
  const _ColorJsonConverter();

  @override
  Color fromJson(int value) => Color(value);

  @override
  int toJson(Color color) => color.value;
}
