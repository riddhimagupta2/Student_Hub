import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/constants/constant.dart';
import '../../../app/theme/colours.dart';
import '../../../app/theme/text_style.dart';
import '../../../widgets/category_chip.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/post_card_widget.dart';
import '../controllers/home_controller.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(c)),
          SliverToBoxAdapter(child: _buildCategoryFilter(c)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: Obx(() {
              final posts = c.posts;
              final selected = c.selectedCategory.value;
              if (c.isLoading.value) {
                return SliverToBoxAdapter(child: LoadingWidget(itemCount: 4));
              }
              if (posts.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: EmptyStateWidget(
                      emoji: '🌐',
                      title: selected == 'All' ? 'No posts yet' : 'No $selected posts yet',
                      subtitle: selected == 'All'
                          ? 'Be the first to share something with the community!'
                          : 'No posts found in $selected category.',
                      buttonLabel: 'Create First Post',
                      onButtonTap: () => c.changeTab(1),
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => PostCard(post: c.posts[i]),
                  childCount: c.posts.length,
                ),
              );
            }),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildHeader(HomeController c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.greeting, style: AppTextStyles.h2),
                const SizedBox(height: 2),
                Text(
                  'Discover what\'s new',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.notifications_none_rounded,
                    size: 22,
                    color: AppColors.textSecondary,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(HomeController c) {
    return SizedBox(
      height: 54,
      child: Obx(() {
        final selected = c.selectedCategory.value;

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          scrollDirection: Axis.horizontal,
          itemCount: AppConstants.categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (ctx, i) {
            final cat = AppConstants.categories[i];

            return CategoryChip(
              label: cat,
              emoji: AppConstants.categoryEmoji[cat],
              isSelected: selected == cat,
              onTap: () => c.filterByCategory(cat),
            );
          },
        );
      }),
    );
  }
}
