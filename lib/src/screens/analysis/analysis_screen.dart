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
    super.build(context);

    final coefficients = _calculateCorrelations();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis'),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          final data = coefficients.entries.elementAt(index);
          final percentage = (data.value * 100).truncate();
          final prettyPercentage = '$percentage%';

          Color? textColor;
          if (percentage > 0) textColor = Colors.green;
          if (percentage < 0) textColor = Colors.red;

          return ListTile(
            title: Text(data.key),
            trailing: Text(
              prettyPercentage,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const Divider(),
        itemCount: coefficients.length,
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
