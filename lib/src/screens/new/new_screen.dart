import 'package:flutter/material.dart';
import 'package:loggy/src/data/constants.dart';
import 'package:loggy/src/widgets/rating_toggle_group.dart';

/// Add a new entry.
class NewScreen extends StatefulWidget {
  /// Creates a new [NewScreen].
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: const [
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: RatingToggleGroup(defaultRatingScale),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /* todo */
        },
        tooltip: 'Save',
        child: const Icon(Icons.save),
      ),
    );
  }
}
