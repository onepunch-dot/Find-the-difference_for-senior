import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/loading/loading_page.dart';
import '../../features/home/home_page.dart';
import '../../features/stages/stage_list_page.dart';
import '../../features/stage_play/stage_page.dart';
import '../../domain/models/stage.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/loading',
  routes: [
    GoRoute(
      path: '/loading',
      name: 'loading',
      builder: (context, state) => const LoadingPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/themes/:themeId/stages',
      name: 'stageList',
      builder: (context, state) {
        final themeId = state.pathParameters['themeId']!;
        final themeName = state.uri.queryParameters['themeName'] ?? '테마';
        return StageListPage(
          themeId: themeId,
          themeName: themeName,
        );
      },
    ),
    GoRoute(
      path: '/stage',
      name: 'stage',
      builder: (context, state) {
        final stage = state.extra as Stage;
        return StagePage(stage: stage);
      },
    ),
    // 추후 추가될 라우트:
    // - /result (ResultPage)
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('페이지를 찾을 수 없습니다: ${state.uri}'),
    ),
  ),
);
