import 'package:flutter/material.dart';

/// 힌트 다이얼로그 (무료 힌트 없을 때)
class HintDialog extends StatelessWidget {
  final int freeHintsRemaining;
  final VoidCallback onUseFreeHint;
  final VoidCallback onWatchAd;

  const HintDialog({
    super.key,
    required this.freeHintsRemaining,
    required this.onUseFreeHint,
    required this.onWatchAd,
  });

  @override
  Widget build(BuildContext context) {
    final hasFreeHints = freeHintsRemaining > 0;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.lightbulb,
            color: Colors.amber[700],
            size: 28,
          ),
          const SizedBox(width: 8),
          const Text(
            '힌트',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasFreeHints) ...[
            Text(
              '오늘 남은 무료 힌트: $freeHintsRemaining개',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '힌트를 사용하시겠습니까?',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ] else ...[
            const Text(
              '오늘의 무료 힌트를 모두 사용했습니다.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.video_library,
                    color: Colors.amber[700],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      '광고를 시청하고\n힌트를 받으세요!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        if (hasFreeHints)
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onUseFreeHint();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[700],
              foregroundColor: Colors.white,
            ),
            child: const Text('힌트 사용'),
          )
        else
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onWatchAd();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[700],
              foregroundColor: Colors.white,
            ),
            child: const Text('광고 보기'),
          ),
      ],
    );
  }
}
