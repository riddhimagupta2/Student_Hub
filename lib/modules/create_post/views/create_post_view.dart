import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/constants/constant.dart';
import '../../../app/theme/colours.dart';
import '../../../app/theme/text_style.dart';
import '../../../widgets/custom_button.dart';
import '../controllers/create_post_controller.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CreatePostController>();
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: c.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildHeader(),
              const SizedBox(height: 20),
              _buildAnonymousBanner(),
              const SizedBox(height: 20),
              _buildContentField(c),
              const SizedBox(height: 20),
              _buildCategorySelector(c),
              const SizedBox(height: 24),
              Obx(
                () => CustomButton(
                  label: 'Post Anonymously 🕵️',
                  onTap: c.submitPost,
                  isLoading: c.isLoading.value,
                  icon: Icons.send_rounded,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text('Create Post', style: AppTextStyles.h2),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.primaryPale,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            'Anonymous',
            style: AppTextStyles.monoSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnonymousBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryPale, Color(0xFFE0E7FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC7D2FE), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('🕵️', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your identity is protected',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Posts appear as "Anonymous Student"',
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF6366F1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentField(CreatePostController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("What's on your mind?", style: AppTextStyles.inputLabel),
            Obx(
              () => Text(
                '${c.charCount.value}/${AppConstants.maxPostLength}',
                style: AppTextStyles.caption.copyWith(
                  color: c.charCount.value > AppConstants.maxPostLength - 50
                      ? AppColors.error
                      : AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: c.contentCtrl,
          validator: c.validateContent,
          maxLines: 6,
          maxLength: AppConstants.maxPostLength,
          textInputAction: TextInputAction.newline,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            hintText:
                'Share something useful with the community — a question, tip, resource, or experience…',
            hintStyle: AppTextStyles.inputHint.copyWith(fontSize: 13),
            alignLabelWithHint: true,
            counterText: '',
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector(CreatePostController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Category', style: AppTextStyles.inputLabel),
        const SizedBox(height: 10),
        Obx(() {
          final selected = c.selectedCategory.value;
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3.2,
            ),
            itemCount: AppConstants.interestCategories.length,
            itemBuilder: (_, i) {
              final cat = AppConstants.interestCategories[i];
              final isSelected = selected == cat;
              return GestureDetector(
                onTap: () => c.selectCategory(cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryPale
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppConstants.categoryEmoji[cat] ?? '💬',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        cat.replaceAll(' Discussion', ''),
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
