import 'package:flutter/material.dart';
import '../../../domain/models/answer.dart';

/// 이미지 뷰어 (터치 처리 + 정답 마커 표시 + 줌/드래그)
class ImageViewer extends StatefulWidget {
  final String? imageUrl;
  final List<Answer> answers;
  final Set<int> foundAnswers;
  final Function(double tapX, double tapY) onTap;
  final TransformationController transformationController;
  final Answer? hintAnswer; // 힌트로 표시할 정답

  const ImageViewer({
    super.key,
    required this.imageUrl,
    required this.answers,
    required this.foundAnswers,
    required this.onTap,
    required this.transformationController,
    this.hintAnswer,
  });

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer>
    with SingleTickerProviderStateMixin {
  Offset? _wrongTapPosition;
  late AnimationController _hintAnimationController;
  late Animation<double> _hintAnimation;

  @override
  void initState() {
    super.initState();
    _hintAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _hintAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _hintAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _hintAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: widget.transformationController,
      minScale: 1.0,
      maxScale: 4.0,
      panEnabled: true,
      scaleEnabled: true,
      child: GestureDetector(
        onTapUp: (details) {
          _handleTap(details.localPosition);
        },
        child: Container(
          color: Colors.grey.shade900,
          child: Stack(
            children: [
              // 이미지
              if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                Positioned.fill(
                  child: Image.network(
                    widget.imageUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.error, color: Colors.red, size: 48),
                      );
                    },
                  ),
                )
              else
                const Center(
                  child: Icon(Icons.image, color: Colors.grey, size: 64),
                ),

              // 정답 마커 (찾은 정답들)
              ...widget.foundAnswers.map((index) {
                final answer = widget.answers[index];
                return _buildAnswerMarker(answer);
              }),

              // 힌트 마커 (점멸)
              if (widget.hintAnswer != null)
                _buildHintMarker(widget.hintAnswer!),

              // 오답 피드백 (빨간 점)
              if (_wrongTapPosition != null)
                Positioned(
                  left: _wrongTapPosition!.dx - 10,
                  top: _wrongTapPosition!.dy - 10,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(Offset position) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;

    // 현재 transformation을 고려하여 실제 이미지 좌표 계산
    final matrix = widget.transformationController.value;
    final inverseMatrix = Matrix4.inverted(matrix);

    // 탭 위치를 transformation 전 좌표로 변환
    final transformedPosition = MatrixUtils.transformPoint(
      inverseMatrix,
      position,
    );

    // 탭 좌표를 0.0~1.0 비율로 변환
    final tapX = transformedPosition.dx / size.width;
    final tapY = transformedPosition.dy / size.height;

    // 정답 판정
    final isCorrect = widget.onTap(tapX, tapY);

    if (!isCorrect) {
      // 오답: 빨간 점 표시 (100ms)
      setState(() {
        _wrongTapPosition = position;
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            _wrongTapPosition = null;
          });
        }
      });
    }
  }

  Widget _buildAnswerMarker(Answer answer) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        // 비율 좌표를 실제 픽셀로 변환
        final centerX = answer.x * size.width;
        final centerY = answer.y * size.height;
        final radiusPixels = answer.radius * size.width;

        return Positioned(
          left: centerX - radiusPixels,
          top: centerY - radiusPixels,
          child: Container(
            width: radiusPixels * 2,
            height: radiusPixels * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF7C3AED),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                  blurStyle: BlurStyle.inner,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHintMarker(Answer answer) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        // 비율 좌표를 실제 픽셀로 변환
        final centerX = answer.x * size.width;
        final centerY = answer.y * size.height;
        final radiusPixels = answer.radius * size.width;

        return Positioned(
          left: centerX - radiusPixels,
          top: centerY - radiusPixels,
          child: AnimatedBuilder(
            animation: _hintAnimation,
            builder: (context, child) {
              return Container(
                width: radiusPixels * 2,
                height: radiusPixels * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: _hintAnimation.value),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: _hintAnimation.value * 0.6),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
