import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverstate/riverpod/state_provider/movie_provider/movie_provider.dart';

part 'genre_provider.g.dart';

@riverpod
class GenreState extends _$GenreState {
  @override
  List<String> build() {
    return ["Action", "Adventure", "Comedy", "Drama", "Fantasy", "Horror", "Mystery", "Thriller"];
  }

  void addGenre(String genre) {
    if (!state.contains(genre)) {
      state = [...state, genre];
    }
  }

  void deleteGenre(String genre) {
    state = state.where((g) => g != genre).toList();
    ref.read(movieStateEventProvider.notifier).removeGenreFromMovies(genre);
  }
}
