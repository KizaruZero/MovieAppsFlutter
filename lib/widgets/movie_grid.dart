// lib/widgets/movie_grid.dart
import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'movie_card.dart';

class MovieGrid extends StatelessWidget {
  final List<Movie> movies;

  const MovieGrid({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: movies[index]);
      },
    );
  }
}
