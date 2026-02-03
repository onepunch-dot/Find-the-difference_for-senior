import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'stage_viewmodel.dart';
import 'widgets/image_viewer.dart';
import 'widgets/hint_dialog.dart';
import 'hint_service.dart';
import '../../domain/models/stage.dart';
import '../../domain/models/answer.dart';
import '../ads/widgets/banner_ad_widget.dart';
import '../ads/rewarded_ad_service.dart';
import '../../data/supabase/repositories/stage_repository_impl.dart';
import '../../data/supabase/supabase_client.dart';

class StagePage extends StatelessWidget {
  final Stage stage;
  final Stage? nextStage;

  const StagePage({
    super.key,
    required this.stage,
    this.nextStage,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StageViewModel(stage: stage),
      child: _StagePageContent(
        currentStage: stage,
        nextStage: nextStage,
      ),
    );
  }
}

class _StagePageContent extends StatefulWidget {
  final Stage currentStage;
  final Stage? nextStage;

  const _StagePageContent({
    required this.currentStage,
    this.nextStage,
  });

  @override
  State<_StagePageContent> createState() => _StagePageContentState();
}

class _StagePageContentState extends State<_StagePageContent> {
  late final TransformationController _transformationController;
  late final HintService _hintService;
  Answer? _currentHint; // 현재 표시 중인 힌트

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _hintService = HintService();
    _hintService.initialize();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<StageViewModel>();
      viewModel.addListener(() {
        if (viewModel.isCompleted && mounted) {
          _navigateToResult();
        }
      });
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _hintService.dispose();
    super.dispose();
  }

  void _navigateToResult() async {
    // 완료 기록 저장
    final userId = SupabaseClientManager.currentUserId;
    if (userId != null) {
      final repository = StageRepositoryImpl();
      await repository.markStageAsCompleted(userId, widget.currentStage.id);
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.push('/result', extra: {
          'completedStage': widget.currentStage,
          'nextStage': widget.nextStage,
        });
      }
    });
  }

  void _toggleZoom() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();

    if (currentScale > 1.5) {
      // 확대되어 있으면 리셋
      _transformationController.value = Matrix4.identity();
    } else {
      // 2배 확대
      final matrix = Matrix4.identity();
      matrix.setEntry(0, 0, 2.0); // scale x
      matrix.setEntry(1, 1, 2.0); // scale y
      matrix.setEntry(2, 2, 2.0); // scale z
      _transformationController.value = matrix;
    }
  }

  void _showHintDialog() {
    showDialog(
      context: context,
      builder: (context) => HintDialog(
        freeHintsRemaining: _hintService.freeHintsRemaining,
        onUseFreeHint: _useFreeHint,
        onWatchAd: _watchAdForHint,
      ),
    );
  }

  Future<void> _useFreeHint() async {
    final success = await _hintService.useFreeHint();
    if (success) {
      _showHint();
    }
  }

  Future<void> _watchAdForHint() async {
    final rewardedAdService = RewardedAdService();

    // 광고 로드
    await rewardedAdService.loadAd();

    // 광고 시청
    final earned = await rewardedAdService.showAd();

    if (earned && mounted) {
      // 힌트 추가
      await _hintService.addHintFromAd();
      _showHint();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('광고를 끝까지 시청해주세요')),
      );
    }
  }

  void _showHint() {
    final viewModel = context.read<StageViewModel>();
    final hint = viewModel.useHint();

    if (hint != null) {
      setState(() {
        _currentHint = hint;
      });

      // 3초 후 힌트 제거
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _currentHint = null;
          });
        }
      });
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 정답을 찾았습니다!')),
      );
    }
  }

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
        backgroundColor: const Color(0xFFFFF9F2),
        body: Column(
          children: [
            _buildHeader(context, viewModel),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // Original image
                    Expanded(
                      child: _buildImageContainer(
                        context,
                        viewModel,
                        label: 'Original',
                        imageUrl: viewModel.stage.imageAUrl ?? '',
                        labelColor: Colors.black.withValues(alpha: 0.4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Find the Changes image
                    Expanded(
                      child: _buildImageContainer(
                        context,
                        viewModel,
                        label: 'Find the Changes',
                        imageUrl: viewModel.stage.imageBUrl ?? '',
                        labelColor: const Color(0xFF7C3AED).withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, StageViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2).withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFFFF3E0),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Back button
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  onPressed: () async {
                    final shouldExit = await _showExitConfirmDialog(context);
                    if (shouldExit == true && context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Progress
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'PROGRESS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: Color(0xFF999999),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${viewModel.foundCount}/${viewModel.totalCount}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: viewModel.totalCount > 0
                            ? viewModel.foundCount / viewModel.totalCount
                            : 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFD42426),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Zoom button
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.zoom_in, size: 20, color: Color(0xFF7C3AED)),
                  onPressed: _toggleZoom,
                ),
              ),
              const SizedBox(width: 8),
              // Hint button
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.lightbulb, size: 20, color: Colors.white),
                  onPressed: _showHintDialog,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer(
    BuildContext context,
    StageViewModel viewModel, {
    required String label,
    required String imageUrl,
    required Color labelColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            // Image viewer
            ImageViewer(
              imageUrl: imageUrl,
              answers: viewModel.stage.answers,
              foundAnswers: viewModel.foundAnswers,
              onTap: (tapX, tapY) => viewModel.checkAnswer(tapX, tapY),
              transformationController: _transformationController,
              hintAnswer: _currentHint,
            ),
            // Label
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: labelColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showExitConfirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '나가기',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text('정말 나가시겠습니까?\n진행 상황은 저장되지 않습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('나가기'),
          ),
        ],
      ),
    );
  }
}
