import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverstate/components/modal_movie_dialog.dart';
import 'package:riverstate/riverpod/state_provider/movie_provider/movie_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'State Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieList = ref.watch(movieStateEventProvider);
    final movieEvent = ref.watch(movieStateEventProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: movieList.isEmpty
          ? const Center(child: Text('No movies available.'))
          : ListView.builder(
              itemCount: movieList.length,
              itemBuilder: (context, index) {
                final movie = movieList[index];
                return ListTile(
                  title: Text(movie.title),
                  subtitle: Text(movie.genre.name.toUpperCase()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => ModalMovieDialog(
                            movie: movie,
                            isEditing: true,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => movieEvent.deleteList(movie.id),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => ModalMovieDialog(isEditing: false),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
