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
  late GenreChoice _selectedGenre = GenreChoice.action;
  bool get isEditing => widget.isEditing;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.movie?.title ?? '');
    _selectedGenre = widget.movie?.genre ?? GenreChoice.action;
  }

  @override
  Widget build(BuildContext context) {
    final movieEvent = ref.watch(movieStateEventProvider.notifier);

    return AlertDialog(
      title: const Text('Add New Movie'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Movie Title'),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<GenreChoice>(
            value: _selectedGenre,
            decoration: const InputDecoration(labelText: 'Select Genre'),
            items: GenreChoice.values.map((genre) {
              return DropdownMenuItem(value: genre, child: Text(genre.name.toUpperCase()));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedGenre = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              if (isEditing) {
                movieEvent.editList(
                  widget.movie!.id,
                  _titleController.text,
                  _selectedGenre,
                );
              } else {
                movieEvent.addList(
                  _titleController.text,
                  _selectedGenre,
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
