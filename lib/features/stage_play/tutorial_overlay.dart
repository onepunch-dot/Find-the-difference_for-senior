import 'package:flutter/material.dart';

/// 튜토리얼 오버레이
class TutorialOverlay extends StatefulWidget {
  final VoidCallback onComplete;

  const TutorialOverlay({
    super.key,
    required this.onComplete,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  int _currentStep = 0;

  final List<TutorialStep> _steps = [
    TutorialStep(
      title: '환영합니다!',
      description: '틀린그림찾기 게임에 오신 것을 환영합니다.\n두 이미지를 비교하여 다른 부분을 찾아보세요.',
      icon: Icons.waving_hand,
      position: TutorialPosition.center,
    ),
    TutorialStep(
      title: '정답 찾기',
      description: '다른 부분을 발견하면 탭하세요.\n정답을 찾으면 보라색 링이 표시됩니다.',
      icon: Icons.touch_app,
      position: TutorialPosition.center,
    ),
    TutorialStep(
      title: '줌 기능',
      description: '핀치 제스처로 이미지를 확대할 수 있습니다.\n상단의 줌 버튼을 눌러도 됩니다.',
      icon: Icons.zoom_in,
      position: TutorialPosition.topRight,
    ),
    TutorialStep(
      title: '힌트 사용',
      description: '막히면 힌트를 사용하세요!\n하루에 2개의 무료 힌트를 제공합니다.',
      icon: Icons.lightbulb,
      position: TutorialPosition.topRight,
    ),
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      widget.onComplete();
    }
  }

  void _skip() {
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];

    return Material(
      color: Colors.black.withValues(alpha: 0.8),
      child: SafeArea(
        child: Stack(
          children: [
            // Skip button
            Positioned(
              top: 16,
              right: 16,
              child: TextButton(
                onPressed: _skip,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                child: const Text('건너뛰기'),
              ),
            ),

            // Content
            _buildContent(step),

            // Navigation dots and next button
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _steps.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == _currentStep ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == _currentStep
                              ? const Color(0xFF7C3AED)
                              : Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Next button
                  ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      _currentStep < _steps.length - 1 ? '다음' : '시작하기',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(TutorialStep step) {
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            step.icon,
            size: 40,
            color: const Color(0xFF7C3AED),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          step.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            step.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );

    switch (step.position) {
      case TutorialPosition.center:
        return Center(child: content);
      case TutorialPosition.topRight:
        return Positioned(
          top: 100,
          right: 16,
          left: 16,
          child: content,
        );
      case TutorialPosition.topLeft:
        return Positioned(
          top: 100,
          right: 16,
          left: 16,
          child: content,
        );
      case TutorialPosition.bottom:
        return Positioned(
          bottom: 120,
          left: 16,
          right: 16,
          child: content,
        );
    }
  }
}

class TutorialStep {
  final String title;
  final String description;
  final IconData icon;
  final TutorialPosition position;

  const TutorialStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.position,
  });
}

enum TutorialPosition {
  center,
  topLeft,
  topRight,
  bottom,
}
