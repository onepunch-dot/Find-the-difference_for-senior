import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'stage_list_viewmodel.dart';
import 'widgets/stage_card.dart';
import '../../domain/usecases/get_stages_usecase.dart';
import '../../data/supabase/repositories/stage_repository_impl.dart';
import '../../domain/models/stage.dart';
import '../../presentation/widgets/loading_widget.dart';
import '../../presentation/widgets/error_widget.dart';
import '../../presentation/widgets/empty_widget.dart';

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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(themeName),
      ),
      body: _buildBody(context, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, StageListViewModel viewModel) {
    if (viewModel.isLoading) {
      return const LoadingWidget(message: '스테이지를 불러오는 중...');
    }

    if (viewModel.hasError) {
      return AppErrorWidget(
        message: viewModel.errorMessage!,
        onRetry: () => viewModel.loadStages(),
      );
    }

    if (viewModel.stages.isEmpty) {
      return const EmptyWidget(
        message: '사용 가능한 스테이지가 없습니다.',
        icon: Icons.layers_outlined,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: viewModel.stages.length,
      itemBuilder: (context, index) {
        final stageWithStatus = viewModel.stages[index];
        return StageCard(
          stageWithStatus: stageWithStatus,
          onTap: () {
            final result = viewModel.onStageTap(stageWithStatus);
            if (result != null) {
              // 다음 스테이지 찾기
              Stage? nextStage;
              if (index + 1 < viewModel.stages.length) {
                nextStage = viewModel.stages[index + 1].stage;
              }

              // StagePage로 이동
              context.push('/stage', extra: {
                'stage': result.stage,
                'nextStage': nextStage,
              });
            }
          },
        );
      },
    );
  }
}
