import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movie_provider.g.dart';

enum GenreChoice { action, adventure, comedy, drama, fantasy, horror, mystery, thriller }

class MovieState {
  int id;
  String title;
  GenreChoice genre;

  MovieState({
    required this.id,
    required this.title,
    required this.genre,
  });

  MovieState copyWith({
    int? id,
    String? title,
    GenreChoice? genre,
  }) {
    return MovieState(
      id: id ?? this.id,
      title: title ?? this.title,
      genre: genre ?? this.genre,
    );
  }
}

@riverpod
class MovieStateEvent extends _$MovieStateEvent {
  @override
  List<MovieState> build() {
    return [
      MovieState(id: 1, title: "Lord of The Mysteries", genre: GenreChoice.horror),
      MovieState(id: 2, title: "Circle of Inevitability", genre: GenreChoice.mystery),
      MovieState(id: 3, title: "I Used To Be an Idol", genre: GenreChoice.comedy),
    ];
  }

  void deleteList(int id) {
    state = state.where((element) => element.id != id).toList();
  }

  void addList(String title, GenreChoice genre) {
    final int newId = state.isEmpty ? 1 : (state.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1);

    final newMovie = MovieState(id: newId, title: title, genre: genre);
    state = [...state, newMovie];
  }

  void editList(int id, String title, GenreChoice genre) {
    List<MovieState> movie = [...state];
    int index = movie.indexWhere((element) => element.id == id);
    MovieState updateMovie = MovieState(id: index, title: title, genre: genre);
    movie[index] = updateMovie;
    state = movie;
  }
}
