
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/album_bloc.dart';
import '../blocs/album_event.dart';
import '../blocs/album_state.dart';
import 'widgets/album_card.dart';
import 'widgets/error_view.dart';
import 'widgets/loading_indicator.dart';

class AlbumListScreen extends StatelessWidget {
  const AlbumListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Albums',
          style: TextStyle(color: Colors.white,
          fontWeight: FontWeight.bold, // Bold text
          fontSize: 20.0,),
        ),
        centerTitle: true,
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
        child: BlocBuilder<AlbumBloc, AlbumState>(
          builder: (context, state) {
            if (state is AlbumInitial) {
              context.read<AlbumBloc>().add(LoadAlbums());
              return const LoadingIndicator();
            }
            if (state is AlbumLoading) {
              return const LoadingIndicator();
            }

            if (state is AlbumError) {
              return ErrorView(
                message: state.message,
                onRetry: () => context.read<AlbumBloc>().add(LoadAlbums()),
              );
            }

            if (state is AlbumLoaded) {
              return Padding(
                // 👇 Add top padding for the entire screen
                padding: const EdgeInsets.only(top: 20.0),
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<AlbumBloc>().add(LoadAlbums());
                  },
                  child: Padding(
                    // Existing horizontal padding
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: state.albums.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final album = state.albums[index];
                        final photos = state.albumPhotos[album.id] ?? [];

                        if (photos.isEmpty) {
                          context.read<AlbumBloc>().add(LoadAlbumPhotos(album.id));
                        }

                        return AlbumCard(
                          album: album,
                          photos: photos,
                          onTap: () => context.push('/album/${album.id}', extra: album),
                        );
                      },
                    ),
                  ),
                ),
              );
            }
            return const Center(child: Text('Unknown state'));
          },
        ),
      ),
    );
  }
}
