import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'home_viewmodel.dart';
import 'widgets/theme_card.dart';
import '../../domain/usecases/get_themes_usecase.dart';
import '../../data/supabase/repositories/theme_repository_impl.dart';
import '../ads/widgets/banner_ad_widget.dart';
import '../../presentation/widgets/loading_widget.dart';
import '../../presentation/widgets/error_widget.dart';
import '../../presentation/widgets/empty_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final repository = ThemeRepositoryImpl();
        return HomeViewModel(
          getThemesUseCase: GetThemesUseCase(repository),
          getPurchasedThemeIdsUseCase: GetPurchasedThemeIdsUseCase(repository),
        )..loadThemes();
      },
      child: const _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('틀린그림찾기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 설정 페이지로 이동 (추후 구현)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('설정 페이지 구현 예정')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildBody(context, viewModel)),
          const BannerAdWidget(), // 배너 광고
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeViewModel viewModel) {
    if (viewModel.isLoading) {
      return const LoadingWidget(message: '테마를 불러오는 중...');
    }

    if (viewModel.hasError) {
      return AppErrorWidget(
        message: viewModel.errorMessage!,
        onRetry: () => viewModel.loadThemes(),
      );
    }

    if (viewModel.themes.isEmpty) {
      return const EmptyWidget(
        message: '사용 가능한 테마가 없습니다.',
        icon: Icons.category_outlined,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: viewModel.themes.length,
      itemBuilder: (context, index) {
        final themeWithStatus = viewModel.themes[index];
        return ThemeCard(
          themeWithStatus: themeWithStatus,
          onTap: () {
            final result = viewModel.onThemeTap(themeWithStatus);
            if (result != null) {
              // StageListPage로 이동
              context.push(
                '/themes/${result.theme.id}/stages?themeName=${Uri.encodeComponent(result.theme.name)}',
              );
            }
          },
        );
      },
    );
  }
}
