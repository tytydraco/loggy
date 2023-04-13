import 'package:flutter/material.dart';

/// The list of existing trackables.
class TrackablesList extends StatelessWidget {
  /// Creates a new [TrackablesList].
  const TrackablesList({
    super.key,
    required this.trackables,
    this.onTap,
  });

  /// The set of trackables.
  final Set<String> trackables;

  /// The handler when a trackable is tapped.
  final void Function(String trackable)? onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, index) {
        final trackable = trackables.elementAt(index);
        return InkWell(
          onTap: () => onTap?.call(trackable),
          child: SizedBox(
            height: 50,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  trackable,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(),
      itemCount: trackables.length,
    );
  }
}
