import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/photo.dart';
import 'album_event.dart';
import 'album_state.dart';


import '../../data/repositories/album_repository.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository repository;

  AlbumBloc({required this.repository}) : super(AlbumInitial()) {
    on<LoadAlbums>(_onLoadAlbums);
    on<LoadAlbumPhotos>(_onLoadAlbumPhotos);
  }

  Future<void> _onLoadAlbums(LoadAlbums event, Emitter<AlbumState> emit) async {
    try {
      emit(AlbumLoading());
      final albums = await repository.getAlbums(); // Use repository instead of apiService
      emit(AlbumLoaded(albums: albums));
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }

  Future<void> _onLoadAlbumPhotos(LoadAlbumPhotos event, Emitter<AlbumState> emit) async {
    try {
      final currentState = state;
      if (currentState is AlbumLoaded) {
        final photos = await repository.getPhotosByAlbumId(event.albumId); // Use repository
        final updatedPhotos = Map<int, List<Photo>>.from(currentState.albumPhotos);
        updatedPhotos[event.albumId] = photos;
        emit(AlbumLoaded(
          albums: currentState.albums,
          albumPhotos: updatedPhotos,
        ));
      }
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }
}
