import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/stage.dart';

class ResultPage extends StatelessWidget {
  final Stage completedStage;
  final Stage? nextStage; // 다음 스테이지 (없으면 null)

  const ResultPage({
    super.key,
    required this.completedStage,
    this.nextStage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // 축하 메시지
              const Text(
                'Well Done!',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6200EE),
                ),
              ),

              const SizedBox(height: 32),

              // 트로피 아이콘
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF6200EE).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events,
                  size: 80,
                  color: Color(0xFF6200EE),
                ),
              ),

              const SizedBox(height: 32),

              // 완료 메시지
              Text(
                'Stage ${completedStage.stageNumber} 완료!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 48),

              // 버튼들
              _buildActionButtons(context),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // 다음 스테이지 버튼
        if (nextStage != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _onNextStage(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6200EE),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                '다음 스테이지',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

        const SizedBox(height: 16),

        // 다시 하기 버튼
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _onRetry(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Color(0xFF6200EE), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              '다시 하기',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6200EE),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 나가기 버튼
        TextButton(
          onPressed: () => _onExit(context),
          child: const Text(
            '나가기',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  void _onNextStage(BuildContext context) {
    if (nextStage != null) {
      // 현재 ResultPage 닫고 StagePage로 교체
      context.pop(); // ResultPage 닫기
      context.pop(); // 이전 StagePage 닫기
      context.push('/stage', extra: nextStage);
    }
  }

  void _onRetry(BuildContext context) {
    // ResultPage 닫고 같은 스테이지 다시 시작
    context.pop(); // ResultPage 닫기
    context.pop(); // 이전 StagePage 닫기
    context.push('/stage', extra: completedStage);
  }

  void _onExit(BuildContext context) {
    // ResultPage와 StagePage 모두 닫고 StageListPage로 돌아가기
    context.pop(); // ResultPage 닫기
    context.pop(); // StagePage 닫기
  }
}
