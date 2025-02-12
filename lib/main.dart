import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color.fromARGB(255, 125, 196, 255), Colors.blue],
            ),
          ),
        ),
      ),
      body: movieList.isEmpty
          ? const Center(child: Text('No movies available.'))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: movieList.map((movie) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Slidable(
                      key: ValueKey(movie.id),
                      endActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) => showDialog(
                              context: context,
                              builder: (context) => ModalMovieDialog(
                                movie: movie,
                                isEditing: true,
                              ),
                            ),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: (_) => movieEvent.deleteList(movie.id),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.movie,
                          color: Colors.blue,
                          size: 28,
                        ),
                        title: Text(movie.title),
                        subtitle: Text(movie.genre.name.toUpperCase()),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => ModalMovieDialog(isEditing: false),
        ),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
