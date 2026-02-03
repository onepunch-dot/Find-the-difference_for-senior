import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/loading/loading_page.dart';
import '../../features/home/home_page.dart';
import '../../features/stages/stage_list_page.dart';

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
    // 추후 추가될 라우트:
    // - /stages/:stageId (StagePage)
    // - /result (ResultPage)
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('페이지를 찾을 수 없습니다: ${state.uri}'),
    ),
  ),
);
