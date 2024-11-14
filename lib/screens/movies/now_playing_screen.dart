import 'package:flutter/material.dart';
import '../../services/tmdb_service.dart';
import '../../widgets/movie_grid.dart';
import '../../models/movie.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  final TMDBService _tmdbService = TMDBService();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  // ignore: unused_field
  String _searchQuery = '';
  Future<List<Movie>>? _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = _tmdbService.getMovies('/movie/now_playing');
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _searchQuery = query;
      _moviesFuture = query.isEmpty
          ? _tmdbService.getMovies('/movie/now_playing')
          : _tmdbService.searchMovies(query);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : const Text('Kizaru Movie'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _performSearch('');
                }
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies found'));
          }
          return MovieGrid(movies: snapshot.data!);
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search movies...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white70),
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: (query) {
        _performSearch(query);
      },
    );
  }
}
