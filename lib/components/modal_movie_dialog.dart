import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverstate/riverpod/state_provider/movie_provider/movie_provider.dart';

class ModalMovieDialog extends ConsumerStatefulWidget {
  final bool isEditing;
  final MovieState? movie;
  const ModalMovieDialog({required this.isEditing, this.movie, super.key});

  @override
  ConsumerState<ModalMovieDialog> createState() => _ModalMovieDialogState();
}

class _ModalMovieDialogState extends ConsumerState<ModalMovieDialog> {
  late TextEditingController _titleController = TextEditingController();
  late List<GenreChoice> _selectedGenres = [];
  bool get isEditing => widget.isEditing;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.movie?.title ?? '');
    _selectedGenres = widget.movie?.genres.toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final movieEvent = ref.watch(movieStateEventProvider.notifier);

    return AlertDialog(
      title: const Text('Add New Movie'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Movie Title'),
          ),
          const SizedBox(height: 16),
          const Text(
            "Select Genres", // Add title above checkboxes
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Wrap(
            alignment: WrapAlignment.start,
            children: GenreChoice.values.map((genre) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: _selectedGenres.contains(genre),
                    onChanged: (isChecked) {
                      setState(() {
                        if (isChecked!) {
                          _selectedGenres.add(genre);
                        } else {
                          _selectedGenres.remove(genre);
                        }
                      });
                    },
                  ),
                  Text(genre.name.toUpperCase()),
                ],
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        InkWell(
          onTap: () {
            if (_titleController.text.isNotEmpty) {
              if (isEditing) {
                movieEvent.editList(
                  widget.movie!.id,
                  _titleController.text,
                  _selectedGenres,
                );
              } else {
                movieEvent.addList(
                  _titleController.text,
                  _selectedGenres,
                );
              }
              Navigator.pop(context);
            }
          },
          child: Text(isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
