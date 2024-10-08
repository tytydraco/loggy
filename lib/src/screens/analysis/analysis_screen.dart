import 'package:flutter/material.dart';
import 'package:loggy/src/screens/analysis/trackables_correlations.dart';
import 'package:loggy/src/utils/list_instance.dart';
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
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis'),
      ),
      body: Consumer<ListInstance>(
        builder: (context, listInstance, _) {
          // Calculate correlational coefficients.
          final trackablesCorrelations =
              TrackablesCorrelations(listInstance.list.entries);
          final coefficients =
              trackablesCorrelations.calculateAll(listInstance.list.trackables);

          return ListView.separated(
            itemBuilder: (context, index) {
              final data = coefficients.entries.elementAt(index);
              final percentage = (data.value * 100).round();
              var prettyPercentage = '$percentage%';

              // Format for explicit sign and red/green color indicator for
              // positive/negative correlation.
              Color? textColor;
              if (percentage > 0) {
                textColor = Colors.green;
                prettyPercentage = '+$prettyPercentage';
              } else if (percentage < 0) {
                textColor = Colors.red;
              }

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
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
