import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'home_viewmodel.dart';
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
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          Expanded(child: _buildBody(context, viewModel)),
          const BannerAdWidget(),
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

    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTodayHighlight(context, viewModel),
              const SizedBox(height: 24),
              _buildMoreThemes(context, viewModel),
              const SizedBox(height: 32),
              _buildPageIndicator(viewModel),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: false,
      toolbarHeight: 80,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildIconButton(Icons.music_note, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('음악 설정 구현 예정')),
                );
              }),
              const SizedBox(width: 12),
              _buildIconButton(Icons.vibration, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('진동 설정 구현 예정')),
                );
              }),
              const SizedBox(width: 12),
              _buildIconButton(Icons.settings, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('설정 페이지 구현 예정')),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF6B7280), size: 24),
      ),
    );
  }

  Widget _buildTodayHighlight(BuildContext context, HomeViewModel viewModel) {
    final highlightTheme = viewModel.themes.first;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "TODAY'S HIGHLIGHT",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              final result = viewModel.onThemeTap(highlightTheme);
              if (result != null) {
                context.push(
                  '/themes/${result.theme.id}/stages?themeName=${Uri.encodeComponent(result.theme.name)}',
                );
              }
            },
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Stack(
                  children: [
                    // Background placeholder
                    Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image, size: 64, color: Colors.grey),
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0.4),
                            Colors.white,
                          ],
                          stops: const [0.0, 1.0],
                        ),
                      ),
                    ),
                    // Content
                    Positioned(
                      left: 32,
                      right: 32,
                      bottom: 32,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            highlightTheme.theme.name,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A1A),
                              height: 1.1,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'YOUR PROGRESS',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '0/20',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      backgroundColor: Color(0xFF3B82F6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.black.withValues(alpha: 0.05),
                              ),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.05,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3B82F6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF3B82F6)
                                        .withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(24),
                                  onTap: () {
                                    final result =
                                        viewModel.onThemeTap(highlightTheme);
                                    if (result != null) {
                                      context.push(
                                        '/themes/${result.theme.id}/stages?themeName=${Uri.encodeComponent(result.theme.name)}',
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 14,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.play_arrow,
                                            color: Colors.white, size: 24),
                                        SizedBox(width: 8),
                                        Text(
                                          'PLAY',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreThemes(BuildContext context, HomeViewModel viewModel) {
    final moreThemes = viewModel.themes.skip(1).take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Text(
            'MORE THEMES',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: moreThemes.length,
            itemBuilder: (context, index) {
              final themeWithStatus = moreThemes[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () {
                    final result = viewModel.onThemeTap(themeWithStatus);
                    if (result != null) {
                      context.push(
                        '/themes/${result.theme.id}/stages?themeName=${Uri.encodeComponent(result.theme.name)}',
                      );
                    }
                  },
                  child: Container(
                    width: 175,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: Icon(Icons.image,
                                        size: 48, color: Colors.grey),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.0),
                                        Colors.black.withValues(alpha: 0.6),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 16,
                                  right: 16,
                                  bottom: 16,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        themeWithStatus.theme.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: Colors.white
                                              .withValues(alpha: 0.3),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        child: FractionallySizedBox(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: 0.15,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF3B82F6),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator(HomeViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFFD1D5DB),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFFD1D5DB),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
