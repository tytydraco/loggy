import 'package:flutter/material.dart';
import 'package:loggy/src/data/storage_base.dart';
import 'package:loggy/src/utils/trackables_correlations.dart';
import 'package:provider/provider.dart';

/// Perform analysis for entries.
class AnalysisScreen extends StatefulWidget {
  /// Creates a new [AnalysisScreen].
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen>
    with AutomaticKeepAliveClientMixin {
  late final _storage = context.read<StorageBase>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis'),
      ),
      body: Center(
        child: OutlinedButton(
          onPressed: _calculateCorrelations,
          child: const Text('Test'),
        ),
      ),
    );
  }

  Map<String, double> _calculateCorrelations() {
    final trackablesCorrelations = TrackablesCorrelations(_storage.entries);
    return trackablesCorrelations.calculateAll(_storage.trackables);
  }

  @override
  bool get wantKeepAlive => true;
}
