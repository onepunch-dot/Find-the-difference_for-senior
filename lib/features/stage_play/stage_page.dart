import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'stage_viewmodel.dart';
import 'widgets/image_viewer.dart';
import '../../domain/models/stage.dart';

class StagePage extends StatelessWidget {
  final Stage stage;

  const StagePage({
    super.key,
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StageViewModel(stage: stage),
      child: const _StagePageContent(),
    );
  }
}

class _StagePageContent extends StatelessWidget {
  const _StagePageContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StageViewModel>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _showExitConfirmDialog(context);
        if (shouldExit == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              // 상단 UI (진행 상태 + 힌트 버튼)
              _buildTopBar(context, viewModel),

              // A/B 이미지 뷰어
              Expanded(
                child: Column(
                  children: [
                    // 이미지 A
                    Expanded(
                      child: ImageViewer(
                        imageUrl: viewModel.stage.imageAUrl,
                        answers: viewModel.stage.answers,
                        foundAnswers: viewModel.foundAnswers,
                        onTap: (tapX, tapY) => viewModel.checkAnswer(tapX, tapY),
                      ),
                    ),

                    // 구분선
                    Container(
                      height: 2,
                      color: Colors.grey.shade800,
                    ),

                    // 이미지 B
                    Expanded(
                      child: ImageViewer(
                        imageUrl: viewModel.stage.imageBUrl,
                        answers: viewModel.stage.answers,
                        foundAnswers: viewModel.foundAnswers,
                        onTap: (tapX, tapY) => viewModel.checkAnswer(tapX, tapY),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, StageViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.black.withValues(alpha: 0.5),
      child: Row(
        children: [
          // 뒤로가기 버튼
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              final shouldExit = await _showExitConfirmDialog(context);
              if (shouldExit == true && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),

          const Spacer(),

          // 진행 상태
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF6200EE).withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${viewModel.foundCount}/${viewModel.totalCount}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          const Spacer(),

          // 힌트 버튼
          IconButton(
            icon: const Icon(Icons.lightbulb_outline, color: Colors.amber),
            onPressed: () {
              // 힌트 기능 (추후 구현)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('힌트 기능 구현 예정')),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<bool?> _showExitConfirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('나가기'),
        content: const Text('정말 나가시겠습니까?\n진행 상황은 저장되지 않습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('나가기'),
          ),
        ],
      ),
    );
  }
}
