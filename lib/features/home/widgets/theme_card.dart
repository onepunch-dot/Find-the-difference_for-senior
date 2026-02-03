import 'package:flutter/material.dart';
import '../models/theme_status.dart';

class ThemeCard extends StatelessWidget {
  final ThemeWithStatus themeWithStatus;
  final VoidCallback onTap;

  const ThemeCard({
    super.key,
    required this.themeWithStatus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = themeWithStatus.theme;
    final status = themeWithStatus.status;
    final isLocked = status == ThemeStatus.locked;

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
                // 썸네일
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isLocked ? Colors.grey.shade300 : Colors.purple.shade100,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: theme.thumbnailUrl != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              theme.thumbnailUrl!,
                              fit: BoxFit.cover,
                              color: isLocked ? Colors.grey.withValues(alpha: 0.5) : null,
                              colorBlendMode: isLocked ? BlendMode.saturation : null,
                            ),
                          )
                        : Icon(
                            Icons.image,
                            size: 48,
                            color: isLocked ? Colors.grey : Colors.purple.shade300,
                          ),
                  ),
                ),

                // 테마 정보
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 테마 이름
                        Text(
                          theme.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isLocked ? Colors.grey : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),

                        // 상태 배지
                        _buildStatusBadge(status),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 잠금 오버레이
            if (isLocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
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

            // 구매됨 체크마크
            if (status == ThemeStatus.purchased)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF6200EE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ThemeStatus status) {
    String text;
    Color color;

    switch (status) {
      case ThemeStatus.free:
        text = '무료';
        color = Colors.green;
        break;
      case ThemeStatus.purchased:
        text = '구매됨';
        color = const Color(0xFF6200EE);
        break;
      case ThemeStatus.locked:
        text = '잠김';
        color = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
