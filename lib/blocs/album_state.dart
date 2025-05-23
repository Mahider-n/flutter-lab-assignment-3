

// States
import 'package:equatable/equatable.dart';

import '../models/album.dart';
import '../models/photo.dart';

abstract class AlbumState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AlbumInitial extends AlbumState {}

class AlbumLoading extends AlbumState {}

class AlbumLoaded extends AlbumState {
  final List<Album> albums;
  final Map<int, List<Photo>> albumPhotos;

  AlbumLoaded({
    required this.albums,
    this.albumPhotos = const {},
  });

  @override
  List<Object?> get props => [albums, albumPhotos];
}

class AlbumError extends AlbumState {
  final String message;

  AlbumError(this.message);

  @override
  List<Object?> get props => [message];
}

