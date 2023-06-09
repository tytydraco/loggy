import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loggy/src/data/constants.dart';
import 'package:loggy/src/data/storage_base.dart';
import 'package:loggy/src/models/entry.dart';
import 'package:loggy/src/widgets/rating_toggle_group.dart';
import 'package:provider/provider.dart';

/// Edit an entry or add a new one.
class EditScreen extends StatefulWidget {
  /// Creates a new [EditScreen].
  const EditScreen({super.key, this.initialEntry});

  /// The initial entry to edit, if specified.
  final Entry? initialEntry;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late final _storage = context.read<StorageBase>();

  late int? _ratingIndex =
      widget.initialEntry != null ? widget.initialEntry!.rating.value : null;
  late DateTime _date = widget.initialEntry != null
      ? widget.initialEntry!.timestamp
      : DateTime.now();

  final _dateStringFormatter = DateFormat.yMMMMd().add_jm();

  late final _trackablesChecked = widget.initialEntry?.trackables != null
      ? {for (var t in widget.initialEntry!.trackables!) t: true}
      : <String, bool>{};

  Future<DateTime?> _selectTimestamp(DateTime initial) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(0),
      lastDate: DateTime.now(),
    );

    if (newDate == null) return null;

    if (!context.mounted) return null;

    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_date),
    );

    if (newTime == null) return null;

    final selectedDate = DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      newTime.hour,
      newTime.minute,
    );

    if (selectedDate.isAfter(DateTime.now())) return null;

    return selectedDate;
  }

  Future<bool> _confirmExit() async {
    final editedEntry = _getEditedEntry();

    // Exit if no changes were made.
    if (widget.initialEntry != null && editedEntry == widget.initialEntry) {
      return true;
    }

    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm exit'),
            content: const Text(
              'Are you sure you want to exit without saving?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Exit'),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmed && context.mounted) return true;

    return false;
  }

  List<String>? _getCheckedTrackables() {
    if (_trackablesChecked.isEmpty) return null;

    return _trackablesChecked.entries
        .where((element) => element.value)
        .map((e) => e.key)
        .toList();
  }

  Entry? _getEditedEntry() {
    if (_ratingIndex != null) {
      return Entry(
        timestamp: _date,
        rating: defaultRatingScale[_ratingIndex!],
        trackables: _getCheckedTrackables(),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmExit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              // Date and time.
              OutlinedButton(
                onPressed: () async {
                  final newDate = await _selectTimestamp(_date);
                  if (newDate != null) {
                    setState(() {
                      _date = newDate;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(_dateStringFormatter.format(_date)),
                ),
              ),

              // Rating selection.
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: RatingToggleGroup(
                      defaultRatingScale,
                      initialSelection: _ratingIndex,
                      onSelected: (index) => _ratingIndex = index,
                    ),
                  ),
                ),
              ),

              // Trackable selection.
              Expanded(
                child: ListView.separated(
                  itemBuilder: (_, index) {
                    final trackable = _storage.trackables.elementAt(index);
                    return CheckboxListTile(
                      title: Text(trackable),
                      value: _trackablesChecked.putIfAbsent(
                        trackable,
                        () => false,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _trackablesChecked[trackable] = value!;
                        });
                      },
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: _storage.trackables.length,
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'edit_save',
          onPressed: () {
            final editedEntry = _getEditedEntry();
            if (editedEntry == null) Navigator.pop(context);
            Navigator.pop(context, editedEntry);
          },
          tooltip: 'Save',
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
