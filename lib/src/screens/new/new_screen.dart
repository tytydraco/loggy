import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loggy/src/data/constants.dart';
import 'package:loggy/src/models/entry.dart';
import 'package:loggy/src/widgets/rating_toggle_group.dart';

/// Add a new entry.
class NewScreen extends StatefulWidget {
  /// Creates a new [NewScreen].
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  DateTime _date = DateTime.now();
  int? _ratingIndex;
  final _dateStringFormatter = DateFormat.yMMMMd().add_jm();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New'),
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
                    onSelected: (index) => _ratingIndex = index,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_ratingIndex != null) {
            final entry = Entry(
              timestamp: _date,
              rating: defaultRatingScale[_ratingIndex!],
            );

            Navigator.pop(context, entry);
          } else {
            Navigator.pop(context);
          }
        },
        tooltip: 'Save',
        child: const Icon(Icons.save),
      ),
    );
  }
}
