import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/loading/loading_page.dart';
import '../../features/home/home_page.dart';
import '../../features/stages/stage_list_page.dart';
import '../../features/stage_play/stage_page.dart';
import '../../features/result/result_page.dart';
import '../../features/settings/settings_page.dart';
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
        // extra가 Stage 또는 Map일 수 있음
        if (state.extra is Stage) {
          return StagePage(stage: state.extra as Stage);
        } else {
          final data = state.extra as Map<String, dynamic>;
          return StagePage(
            stage: data['stage'] as Stage,
            nextStage: data['nextStage'] as Stage?,
          );
        }
      },
    ),
    GoRoute(
      path: '/result',
      name: 'result',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final completedStage = data['completedStage'] as Stage;
        final nextStage = data['nextStage'] as Stage?;
        return ResultPage(
          completedStage: completedStage,
          nextStage: nextStage,
        );
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('페이지를 찾을 수 없습니다: ${state.uri}'),
    ),
  ),
);
