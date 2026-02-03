import 'package:flutter/material.dart';
import '../models/stage_status.dart';

class StageCard extends StatelessWidget {
  final StageWithStatus stageWithStatus;
  final VoidCallback onTap;

  const StageCard({
    super.key,
    required this.stageWithStatus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final stage = stageWithStatus.stage;
    final status = stageWithStatus.status;
    final isCompleted = status == StageStatus.completed;
    final isLocked = status == StageStatus.locked;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // 카드 콘텐츠
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 썸네일/미리보기
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getBackgroundColor(status),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: stage.imageAUrl != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              stage.imageAUrl!,
                              fit: BoxFit.cover,
                              color: isCompleted || isLocked
                                  ? Colors.grey.withValues(alpha: 0.5)
                                  : null,
                              colorBlendMode:
                                  isCompleted || isLocked ? BlendMode.saturation : null,
                            ),
                          )
                        : Icon(
                            Icons.image,
                            size: 48,
                            color: _getIconColor(status),
                          ),
                  ),
                ),

                // 스테이지 번호
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Stage ${stage.stageNumber}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isCompleted || isLocked ? Colors.grey : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 완료 체크마크
            if (isCompleted)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

            // 잠금 오버레이
            if (isLocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.lock,
                      size: 48,
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

  Color _getBackgroundColor(StageStatus status) {
    switch (status) {
      case StageStatus.completed:
        return Colors.grey.shade300;
      case StageStatus.available:
        return Colors.purple.shade100;
      case StageStatus.locked:
        return Colors.grey.shade400;
    }
  }

  Color _getIconColor(StageStatus status) {
    switch (status) {
      case StageStatus.completed:
        return Colors.grey;
      case StageStatus.available:
        return Colors.purple.shade300;
      case StageStatus.locked:
        return Colors.grey.shade600;
    }
  }
}
