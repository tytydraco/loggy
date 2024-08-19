import 'dart:math';

import 'package:collection/collection.dart';
import 'package:loggy/src/models/entry.dart';
import 'package:loggy/src/models/trackable.dart';

/// Calculate correlations of data.
class TrackablesCorrelations {
  /// Creates a new [TrackablesCorrelations].
  TrackablesCorrelations(this.entries);

  /// Entries to use.
  final Iterable<Entry> entries;

  double _stdDev(List<double> nums) {
    if (nums.length <= 1) return 0;

    final squaredDiffs = nums.map((e) => pow(e - nums.average, 2)).toList();
    final variance = squaredDiffs.sum / (nums.length - 1);
    return sqrt(variance);
  }

  /// Calculate the correlation coefficient for a single trackable.
  double calculateFor(Trackable trackable) {
    final x = entries.map((e) => e.values[trackable.name] ?? 0).toList();
    final y = entries.map((e) => e.rating.value.toDouble()).toList();

    // No data yet.
    if (x.isEmpty || y.isEmpty) return 0;

    final xStdDev = _stdDev(x);
    final yStdDev = _stdDev(y);

    // No correlation yet.
    if (xStdDev == 0 || yStdDev == 0) return 0;

    final xDeltas = x.map((e) => e - x.average).toList();
    final yDeltas = y.map((e) => e - y.average).toList();

    final products = List.generate(entries.length, (index) {
      return xDeltas[index] * yDeltas[index];
    });

    return products.sum / (products.length - 1) / (xStdDev * yStdDev);
  }

  /// Calculate the correlation coefficient for all trackables.
  Map<Trackable, double> calculateAll(Iterable<Trackable> trackables) {
    return Map.fromIterable(
      trackables,
      value: (e) => calculateFor(e as Trackable),
    );
  }
}
