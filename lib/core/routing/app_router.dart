import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/loading/loading_page.dart';
import '../../features/home/home_page.dart';

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
    // 추후 추가될 라우트:
    // - /themes/:themeId/stages (StageListPage)
    // - /stages/:stageId (StagePage)
    // - /result (ResultPage)
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('페이지를 찾을 수 없습니다: ${state.uri}'),
    ),
  ),
);
