import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trackable.g.dart';

/// Trackable information.
@immutable
@JsonSerializable()
class Trackable {
  /// Creates a new [Trackable].
  const Trackable({
    required this.name,
    required this.boolean,
  });

  /// Creates a new [Trackable] from a JSON map.
  factory Trackable.fromJson(Map<String, dynamic> json) =>
      _$TrackableFromJson(json);

  /// The name of the trackable.
  final String name;

  /// True if the trackable is a boolean, otherwise it is a double value.
  final bool boolean;

  /// Converts the entry to a JSON object.
  Map<String, dynamic> toJson() => _$TrackableToJson(this);

  @override
  bool operator ==(Object other) =>
      other is Trackable &&
      other.runtimeType == runtimeType &&
      other.name == name &&
      other.boolean == boolean;

  @override
  int get hashCode => Object.hash(name, boolean);
}
