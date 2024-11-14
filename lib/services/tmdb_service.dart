import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_constants.dart';
import '../models/movie.dart';

class TMDBService {
  Future<List<Movie>> getMovies(String endpoint) async {
    final response = await http.get(
      Uri.parse(
          '${ApiConstants.baseUrl}$endpoint?api_key=${ApiConstants.apiKey}'),
      headers: {
        'Authorization': 'Bearer ${ApiConstants.bearerToken}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];

    final response = await http.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/search/movie?api_key=${ApiConstants.apiKey}&query=$query'),
      headers: {
        'Authorization': 'Bearer ${ApiConstants.bearerToken}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }

  Future<void> addToFavorites(int movieId) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/account/{account_id}/favorite'),
      headers: {
        'Authorization': 'Bearer ${ApiConstants.bearerToken}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'media_type': 'movie',
        'media_id': movieId,
        'favorite': true,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add to favorites');
    }
  }
}
