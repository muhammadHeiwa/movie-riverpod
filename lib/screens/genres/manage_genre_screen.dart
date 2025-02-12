import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverstate/riverpod/state_provider/genre_provider/genre_provider.dart';

class ManageGenresScreen extends ConsumerStatefulWidget {
  const ManageGenresScreen({super.key});

  @override
  ConsumerState createState() => _ManageGenresScreenState();
}

class _ManageGenresScreenState extends ConsumerState<ManageGenresScreen> {
  final TextEditingController _genreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final genreList = ref.watch(genreStateProvider);
    final genreEvent = ref.watch(genreStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Genres'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _genreController,
              decoration: InputDecoration(
                labelText: "New Genre",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_genreController.text.isNotEmpty) {
                      genreEvent.addGenre(_genreController.text);
                      _genreController.clear();
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: genreList.length,
              itemBuilder: (context, index) {
                final genre = genreList[index];
                return ListTile(
                  title: Text(genre),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => genreEvent.deleteGenre(genre),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
