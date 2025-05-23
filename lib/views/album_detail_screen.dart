
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/album_bloc.dart';
import '../blocs/album_event.dart';
import '../blocs/album_state.dart';
import '../models/album.dart';
import 'widgets/error_view.dart';
import 'widgets/loading_indicator.dart';
import 'widgets/photo_card.dart';

class AlbumDetailScreen extends StatelessWidget {
  final int albumId;

  const AlbumDetailScreen({
    super.key,
    required this.albumId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AlbumBloc, AlbumState>(
          builder: (context, state) {
            if (state is AlbumLoaded) {
              final album = state.albums.firstWhere(
                    (a) => a.id == albumId,
                orElse: () => Album(id: -1, userId: -1, title: 'Not Found'),
              );
              return Text(album.title,style: TextStyle(color: Colors.white,
              fontWeight: FontWeight.bold,
               fontSize: 20.0,),
                );
            }
            return const Text('Loading...');
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white,),
          onPressed: () => context.pop(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFf5f7fa), Color(0xFFc3cfe2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<AlbumBloc, AlbumState>(
            builder: (context, state) {
              if (state is AlbumLoaded) {
                final photos = state.albumPhotos[albumId];

                if (photos == null) {
                  context.read<AlbumBloc>().add(LoadAlbumPhotos(albumId));
                  return const LoadingIndicator();
                }

                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    final photo = photos[index];
                    return PhotoCard(photo: photo);
                  },
                );
              }

              if (state is AlbumError) {
                return ErrorView(
                  message: state.message,
                  onRetry: () => context.read<AlbumBloc>().add(LoadAlbumPhotos(albumId)),
                );
              }

              return const LoadingIndicator();
            },
          ),
        ),
      ),
    );
  }
}

