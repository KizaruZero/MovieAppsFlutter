import 'package:flutter/material.dart';
import '../../services/tmdb_service.dart';
import '../../widgets/movie_grid.dart';
import '../../models/movie.dart';

class TopRatedScreen extends StatelessWidget {
  final TMDBService _tmdbService = TMDBService();

  TopRatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _tmdbService.getMovies('/movie/top_rated'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MovieGrid(movies: snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
