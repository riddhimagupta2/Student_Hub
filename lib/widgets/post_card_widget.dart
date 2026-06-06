import 'package:flutter/material.dart';
import '../app/constants/constant.dart';
import '../app/theme/colours.dart';
import '../app/theme/text_style.dart';
import '../data/models/post.dart';


class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onTap;

  const PostCard({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    final catStyle = _getCategoryStyle(post.category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryPale, Color(0xFFC7D2FE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Center(
                      child: Text('👤', style: TextStyle(fontSize: 15)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Anonymous Student',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(post.timeAgo, style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                post.content,
                style: AppTextStyles.bodyMedium,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: catStyle.bgColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${AppConstants.categoryEmoji[post.category] ?? '💬'} ',
                          style: const TextStyle(fontSize: 11),
                        ),
                        Text(
                          post.category,
                          style: AppTextStyles.captionBold.copyWith(
                            color: catStyle.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _CategoryStyle _getCategoryStyle(String category) {
    switch (category) {
      case 'Technology':
        return _CategoryStyle(AppColors.catTechBg, AppColors.catTechText);
      case 'Career':
        return _CategoryStyle(AppColors.catCareerBg, AppColors.catCareerText);
      case 'Study Abroad':
        return _CategoryStyle(AppColors.catAbroadBg, AppColors.catAbroadText);
      default:
        return _CategoryStyle(AppColors.catGeneralBg, AppColors.catGeneralText);
    }
  }
}

class _CategoryStyle {
  final Color bgColor;
  final Color textColor;
  const _CategoryStyle(this.bgColor, this.textColor);
}
