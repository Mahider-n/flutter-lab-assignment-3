
import 'package:flutter/material.dart';
import 'package:flutter_assignment_new/routes/app_router.dart';
import 'package:flutter_assignment_new/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/album_bloc.dart';
import 'blocs/album_event.dart';
import 'data/repositories/album_repository.dart';

//
class LifecycleEventHandler extends WidgetsBindingObserver {
  final Function()? onDetach;

  LifecycleEventHandler({this.onDetach});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      onDetach?.call();
    }
  }
}

void main() {
  final apiService = ApiService();
  WidgetsFlutterBinding.ensureInitialized();
  // Register lifecycle observer
  WidgetsBinding.instance.addObserver(
    LifecycleEventHandler(
      onDetach: () => apiService.dispose(),
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => ApiService()),
        RepositoryProvider(
          create: (context) => AlbumRepository(
            apiService: RepositoryProvider.of<ApiService>(context),
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => AlbumBloc(
          repository: RepositoryProvider.of<AlbumRepository>(context),
        )..add(LoadAlbums()), // Load albums immediately
        child: MaterialApp.router(
          title: 'Album Viewer',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
