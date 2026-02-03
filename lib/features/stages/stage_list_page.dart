import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'stage_list_viewmodel.dart';
import '../../domain/usecases/get_stages_usecase.dart';
import '../../data/supabase/repositories/stage_repository_impl.dart';
import '../../domain/models/stage.dart';
import '../../presentation/widgets/loading_widget.dart';
import '../../presentation/widgets/error_widget.dart';
import '../../presentation/widgets/empty_widget.dart';
import 'models/stage_status.dart';

class StageListPage extends StatelessWidget {
  final String themeId;
  final String themeName;

  const StageListPage({
    super.key,
    required this.themeId,
    required this.themeName,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final repository = StageRepositoryImpl();
        return StageListViewModel(
          getStagesUseCase: GetStagesUseCase(repository),
          getCompletedStageIdsUseCase: GetCompletedStageIdsUseCase(repository),
          themeId: themeId,
        )..loadStages();
      },
      child: _StageListPageContent(themeName: themeName),
    );
  }
}

class _StageListPageContent extends StatelessWidget {
  final String themeName;

  const _StageListPageContent({required this.themeName});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StageListViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F8),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          if (viewModel.isLoading)
            const SliverFillRemaining(
              child: LoadingWidget(message: '스테이지를 불러오는 중...'),
            )
          else if (viewModel.hasError)
            SliverFillRemaining(
              child: AppErrorWidget(
                message: viewModel.errorMessage!,
                onRetry: () => viewModel.loadStages(),
              ),
            )
          else if (viewModel.stages.isEmpty)
            const SliverFillRemaining(
              child: EmptyWidget(
                message: '사용 가능한 스테이지가 없습니다.',
                icon: Icons.layers_outlined,
              ),
            )
          else
            SliverList(
              delegate: SliverChildListDelegate([
                _buildProgressDots(),
                const SizedBox(height: 16),
                _buildHeader(),
                const SizedBox(height: 32),
                ..._buildStageCards(context, viewModel),
                _buildBackToTop(context),
                const SizedBox(height: 48),
              ]),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color(0xFFF7F5F8).withValues(alpha: 0.8),
      elevation: 0,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 20),
        onPressed: () => context.pop(),
      ),
      title: Column(
        children: [
          const Text(
            'VOLUME 01',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Color(0xFF6200EE),
            ),
          ),
          const Text(
            'ISSUE NO. 01',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, size: 24),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('검색 기능 구현 예정')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProgressDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFF6200EE),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 12),
        ...List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            themeName.toUpperCase(),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Curated visual experiences for the curious mind.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStageCards(
    BuildContext context,
    StageListViewModel viewModel,
  ) {
    return List.generate(viewModel.stages.length, (index) {
      final stageWithStatus = viewModel.stages[index];
      final isFirst = index == 0;
      final isLocked = stageWithStatus.status == StageStatus.locked;

      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: GestureDetector(
          onTap: isLocked
              ? null
              : () {
                  final result = viewModel.onStageTap(stageWithStatus);
                  if (result != null) {
                    Stage? nextStage;
                    if (index + 1 < viewModel.stages.length) {
                      nextStage = viewModel.stages[index + 1].stage;
                    }
                    context.push('/stage', extra: {
                      'stage': result.stage,
                      'nextStage': nextStage,
                    });
                  }
                },
          child: Stack(
            children: [
              Container(
                height: 480,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: isLocked
                          ? Colors.black.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      // Background
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          image: isLocked
                              ? null
                              : const DecorationImage(
                                  image: NetworkImage(''),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.image,
                            size: 80,
                            color: Colors.grey.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.0),
                              Colors.black.withValues(alpha: 0.8),
                            ],
                            stops: const [0.4, 1.0],
                          ),
                        ),
                      ),
                      // Locked overlay
                      if (isLocked)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                          ),
                          child: Center(
                            child: Transform.rotate(
                              angle: -0.087, // -5 degrees
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    width: 2,
                                  ),
                                ),
                                child: const Text(
                                  'LOCKED',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 4,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      // Featured badge
                      if (isFirst)
                        Positioned(
                          top: 24,
                          right: 24,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6200EE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'FEATURED',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      // Content
                      Positioned(
                        left: 24,
                        right: 24,
                        bottom: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Stage ${stageWithStatus.stage.stageNumber}',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -2,
                                color: isLocked
                                    ? Colors.white.withValues(alpha: 0.4)
                                    : Colors.white,
                                height: 1.1,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isLocked ? 'STATUS' : 'PROGRESS',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                        color: isLocked
                                            ? Colors.white.withValues(alpha: 0.3)
                                            : Colors.white.withValues(alpha: 0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isLocked
                                          ? 'Coming Soon'
                                          : '0/${stageWithStatus.stage.answers.length} Differences Found',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: isLocked
                                            ? Colors.white.withValues(alpha: 0.5)
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                if (!isLocked)
                                  Container(
                                    width: 100,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'PLAY NOW',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.white.withValues(alpha: 0.4),
                                      size: 20,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Grayscale filter for locked
              if (isLocked)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      foregroundDecoration: const BoxDecoration(
                        color: Colors.white,
                        backgroundBlendMode: BlendMode.saturation,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBackToTop(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Scroll to top logic can be added here
        },
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF6200EE),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6200EE).withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'BACK TO TOP',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Color(0xFF6200EE),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
