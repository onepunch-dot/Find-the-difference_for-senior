import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'home_viewmodel.dart';
import 'widgets/theme_card.dart';
import '../../domain/usecases/get_themes_usecase.dart';
import '../../data/supabase/repositories/theme_repository_impl.dart';

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
      body: _buildBody(context, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, HomeViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (viewModel.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              viewModel.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => viewModel.loadThemes(),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (viewModel.themes.isEmpty) {
      return const Center(
        child: Text('사용 가능한 테마가 없습니다.'),
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
