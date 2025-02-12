import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:riverstate/core/widget/app/app_drawer_widget.dart';
import 'package:riverstate/riverpod/state_provider/genre_provider/genre_provider.dart';
import 'package:riverstate/screens/home/components/modal_movie_dialog.dart';
import 'package:riverstate/riverpod/state_provider/movie_provider/movie_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? selectedGenre;

  @override
  Widget build(BuildContext context) {
    final movieList = ref.watch(movieStateEventProvider);
    final movieEvent = ref.watch(movieStateEventProvider.notifier);
    final genreList = ref.watch(genreStateProvider);

    final filteredMovies =
        selectedGenre == null ? movieList : movieList.where((movie) => movie.genres.contains(selectedGenre)).toList();

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
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawerWidget(),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: selectedGenre == null,
                  selectedColor: Colors.blue,
                  labelStyle: TextStyle(color: selectedGenre == null ? Colors.white : Colors.black),
                  checkmarkColor: Colors.white,
                  onSelected: (_) => setState(() => selectedGenre = null),
                ),
                ...genreList.map((genre) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(genre),
                      selected: selectedGenre == genre,
                      selectedColor: Colors.blue,
                      labelStyle: TextStyle(color: selectedGenre == genre ? Colors.white : Colors.black),
                      checkmarkColor: Colors.white,
                      onSelected: (selected) {
                        setState(() {
                          selectedGenre = selected ? genre : null;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          Expanded(
            child: filteredMovies.isEmpty
                ? const Center(child: Text('No movies available.'))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: filteredMovies.map((movie) {
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
                              subtitle: Text("Genres: ${movie.genres.join(', ')}"),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
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
