import 'package:flutter/material.dart';
import '../../services/tmdb_service.dart';
import '../../widgets/movie_grid.dart';
import '../../models/movie.dart';

class FavoritesScreen extends StatelessWidget {
  final TMDBService _tmdbService = TMDBService();

  FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _tmdbService.getMovies('/account/{account_id}/favorite/movies'),
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
