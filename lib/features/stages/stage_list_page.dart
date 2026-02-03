import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'stage_list_viewmodel.dart';
import 'widgets/stage_card.dart';
import '../../domain/usecases/get_stages_usecase.dart';
import '../../data/supabase/repositories/stage_repository_impl.dart';

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
              onPressed: () => viewModel.loadStages(),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (viewModel.stages.isEmpty) {
      return const Center(
        child: Text('사용 가능한 스테이지가 없습니다.'),
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
          onTap: () => viewModel.onStageTap(stageWithStatus),
        );
      },
    );
  }
}
