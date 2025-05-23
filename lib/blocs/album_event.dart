import 'package:equatable/equatable.dart';

abstract class AlbumEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAlbums extends AlbumEvent {}

class LoadAlbumPhotos extends AlbumEvent {
  final int albumId;

  LoadAlbumPhotos(this.albumId);

  @override
  List<Object?> get props => [albumId];
}