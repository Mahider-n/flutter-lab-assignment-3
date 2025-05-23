
import 'dart:convert';
import 'dart:io';
import '../models/album.dart';
import '../models/photo.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  final HttpClient _httpClient = HttpClient();

  Future<List<Album>> getAlbums() async {
    try {
      final request = await _httpClient.getUrl(Uri.parse('$baseUrl/albums'));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> jsonData = json.decode(body);
        return jsonData.map((json) => Album.fromJson(json)).toList();
      } else {
        throw HttpException(
          'Failed to load albums - Status code: ${response.statusCode}',
          uri: Uri.parse('$baseUrl/albums'),
        );
      }
    } on SocketException {
      throw const SocketException('No Internet connection');
    } catch (e) {
      throw HttpException('Failed to fetch albums', uri: Uri.parse('$baseUrl/albums'));
    }
  }

  Future<List<Photo>> getPhotosByAlbumId(int albumId) async {
    try {
      final request = await _httpClient.getUrl(Uri.parse('$baseUrl/photos?albumId=$albumId'));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> jsonData = json.decode(body);
        return jsonData.map((json) => Photo.fromJson(json)).toList();
      } else {
        throw HttpException(
          'Failed to load photos for album $albumId - Status code: ${response.statusCode}',
          uri: Uri.parse('$baseUrl/photos?albumId=$albumId'),
        );
      }
    } on SocketException {
      throw const SocketException('No Internet connection');
    } catch (e) {
      throw HttpException('Failed to fetch photos for album $albumId',
          uri: Uri.parse('$baseUrl/photos?albumId=$albumId'));
    }
  }

  // Add close method for HttpClient when needed
  void dispose() {
    _httpClient.close();
  }
}



















