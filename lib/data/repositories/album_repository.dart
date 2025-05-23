

import '../../models/album.dart';
import '../../models/photo.dart';
import '../../services/api_service.dart';

class AlbumRepository {
  final ApiService _apiService;

  AlbumRepository({required ApiService apiService}) : _apiService = apiService;

  Future<List<Album>> getAlbums() async {
    return await _apiService.getAlbums();
  }

  Future<List<Photo>> getPhotosByAlbumId(int albumId) async {
    return await _apiService.getPhotosByAlbumId(albumId);
  }
}