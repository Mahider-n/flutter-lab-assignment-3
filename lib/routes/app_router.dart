import 'package:go_router/go_router.dart';
import '../views/album_list_screen.dart';
import '../views/album_detail_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AlbumListScreen(),
      ),
      GoRoute(
        path: '/album/:id',
        builder: (context, state) {
          final albumId = int.parse(state.pathParameters['id']!);
          return AlbumDetailScreen(albumId: albumId); // Pass ID instead of object
          // final album = state.extra as Album;
          // return AlbumDetailScreen(album: album);
        },
      ),
    ],
  );
} 