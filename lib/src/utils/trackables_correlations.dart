import 'dart:math';

import 'package:collection/collection.dart';
import 'package:loggy/src/models/entry.dart';

/// Calculate correlations of data.
class TrackablesCorrelations {
  /// Creates a new [TrackablesCorrelations].
  TrackablesCorrelations(this.entries);

  /// Entries to use.
  final Iterable<Entry> entries;

  double _stdDev(List<int> nums) {
    final mean = nums.average;
    final squaredDiffs = nums.map((e) => pow(e - mean, 2)).toList();
    final variance = squaredDiffs.sum / nums.length;
    return sqrt(variance);
  }

  /// Calculate the correlation coefficient for a single trackable.
  double calculateFor(String trackable) {
    final x = entries
        .map((e) => (e.trackables?.contains(trackable) ?? false) ? 1 : 0)
        .toList();
    final y = entries.map((e) => e.rating.value).toList();

    // No data yet.
    if (x.isEmpty || y.isEmpty) return 0;

    final xMean = x.average;
    final xStdDev = _stdDev(x);
    final stdXs = x.map((e) => (e - xMean) / xStdDev).toList();

    final yMean = y.average;
    final yStdDev = _stdDev(x);
    final stdYs = y.map((e) => (e - yMean) / yStdDev).toList();

    // No correlation yet.
    if (xStdDev == 0 || yStdDev == 0) return 0;

    final stdZs = Map.fromIterables(stdXs, stdYs)
        .entries
        .map((e) => e.value * e.key)
        .toList();

    return stdZs.sum / (stdZs.length - 1);
  }

  /// Calculate the correlation coefficient for all trackables.
  Map<String, double> calculateAll(Iterable<String> trackables) {
    return Map.fromIterable(
      trackables,
      value: (e) => calculateFor(e as String),
    );
  }
}
