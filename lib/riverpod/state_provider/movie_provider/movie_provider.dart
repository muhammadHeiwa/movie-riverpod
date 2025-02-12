import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movie_provider.g.dart';

enum GenreChoice { action, adventure, comedy, drama, fantasy, horror, mystery, thriller }

class MovieState {
  int id;
  String title;
  List<GenreChoice> genres;

  MovieState({
    required this.id,
    required this.title,
    required this.genres,
  });

  MovieState copyWith({
    int? id,
    String? title,
    List<GenreChoice>? genres,
  }) {
    return MovieState(
      id: id ?? this.id,
      title: title ?? this.title,
      genres: genres ?? this.genres,
    );
  }
}

@riverpod
class MovieStateEvent extends _$MovieStateEvent {
  @override
  List<MovieState> build() {
    return [
      MovieState(id: 1, title: "Lord of The Mysteries", genres: [
        GenreChoice.horror,
        GenreChoice.mystery,
        GenreChoice.action,
        GenreChoice.fantasy,
      ]),
      MovieState(id: 2, title: "Circle of Inevitability", genres: [
        GenreChoice.horror,
        GenreChoice.mystery,
        GenreChoice.action,
        GenreChoice.fantasy,
      ]),
      MovieState(id: 3, title: "I Used To Be an Idol", genres: [
        GenreChoice.comedy,
        GenreChoice.drama,
      ]),
    ];
  }

  void deleteList(int id) {
    print(id);
    state = state.where((element) => element.id != id).toList();
  }

  void addList(String title, List<GenreChoice> genre) {
    final int newId = state.isEmpty ? 1 : (state.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1);
    print(newId);

    final newMovie = MovieState(id: newId, title: title, genres: genre);
    state = [...state, newMovie];
  }

  void editList(int id, String title, List<GenreChoice> genre) {
    List<MovieState> movie = [...state];
    int index = movie.indexWhere((element) => element.id == id);
    MovieState updateMovie = MovieState(id: id, title: title, genres: genre);
    movie[index] = updateMovie;
    state = movie;
  }
}
