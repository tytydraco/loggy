import 'dart:ui';

import 'package:meta/meta.dart';

/// An entry rating.
@immutable
class Rating {
  /// Creates a new [Rating].
  const Rating({
    required this.value,
    required this.name,
    required this.color,
  });

  /// Creates a new [Rating] from a JSON map.
  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      value: json['value'] as int,
      name: json['name'] as String,
      color: Color(json['color'] as int),
    );
  }

  /// The integer value.
  final int value;

  /// The display name.
  final String name;

  /// The rating color.
  final Color color;

  /// Converts the rating to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'name': name,
      'color': color.value,
    };
  }

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
