import 'package:flutter/material.dart';
import 'package:flutter_quill/translations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_flutter/pages/home_page.dart';
import 'package:note_flutter/pages/write_note_page.dart';
import 'package:note_flutter/pages/write_todo_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'database/database.dart';
import 'inject.dart';

CustomTransitionPage _fadeTransition(
    BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'todo',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return _fadeTransition(context, state, const WriteTodoPage());
            },
          ),
          GoRoute(
            path: 'todo/:id',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return _fadeTransition(context, state, WriteTodoPage(id: state.pathParameters['id']));
            },
          ),
          GoRoute(
            path: 'note',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return _fadeTransition(context, state, const WriteNotePage());
            },
          ),
          GoRoute(
            path: 'note/:id',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return _fadeTransition(context, state, WriteNotePage(id: state.pathParameters['id']));
            },
          ),
        ]),
  ],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FlutterQuillLocalizations.delegate,
        ],
    );
  }
}
