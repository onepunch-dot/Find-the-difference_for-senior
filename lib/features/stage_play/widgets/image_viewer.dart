import 'package:flutter/material.dart';
import '../../../domain/models/answer.dart';

/// 이미지 뷰어 (터치 처리 + 정답 마커 표시)
class ImageViewer extends StatefulWidget {
  final String? imageUrl;
  final List<Answer> answers;
  final Set<int> foundAnswers;
  final Function(double tapX, double tapY) onTap;

  const ImageViewer({
    super.key,
    required this.imageUrl,
    required this.answers,
    required this.foundAnswers,
    required this.onTap,
  });

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  Offset? _wrongTapPosition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        _handleTap(details.localPosition);
      },
      child: Container(
        color: Colors.grey.shade900,
        child: Stack(
          children: [
            // 이미지
            if (widget.imageUrl != null)
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
    );
  }

  void _handleTap(Offset position) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;

    // 탭 좌표를 0.0~1.0 비율로 변환
    final tapX = position.dx / size.width;
    final tapY = position.dy / size.height;

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
}
