import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/constants/constant.dart';
import '../../../app/theme/colours.dart';
import '../../../app/theme/text_style.dart';
import '../../../widgets/category_chip.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/loading_widget.dart';
import '../controllers/profile_controller.dart';


class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProfileController>();
    return SafeArea(
      child: Obx(() {
        if (c.isLoading.value && c.user.value == null) {
          return const LoadingWidget(itemCount: 3);
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('My Profile', style: AppTextStyles.h2),
              const SizedBox(height: 20),
              _buildProfileCard(c),
              const SizedBox(height: 16),
              _buildStatsRow(c),
              const SizedBox(height: 20),
              _buildInterestsSection(c),
              const SizedBox(height: 20),
              _buildActions(c),
              const SizedBox(height: 16),
              CustomButton(
                label: 'Sign Out',
                onTap: c.logout,
                isDanger: true,
                icon: Icons.logout_rounded,
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  
  Widget _buildProfileCard(ProfileController c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          
          Positioned(
            top: -20, right: -20,
            child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Column(
            children: [
              
              Stack(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.4), width: 2.5),
                    ),
                    child: Center(
                      child: Obx(() => Text(
                        c.initials,
                        style: AppTextStyles.h1.copyWith(
                          color: Colors.white,
                          fontSize: 26,
                        ),
                      )),
                    ),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.primary, width: 2),
                      ),
                      child: const Center(
                        child: Icon(Icons.edit_rounded,
                            size: 11, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() => Text(
                c.user.value?.name ?? '—',
                style: AppTextStyles.h2.copyWith(color: Colors.white),
              )),
              const SizedBox(height: 4),
              Obx(() => Text(
                c.user.value?.email ?? '—',
                style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.75)),
              )),
            ],
          ),
        ],
      ),
    );
  }

  
  Widget _buildStatsRow(ProfileController c) {
    return Row(
      children: [
        _statCard('Interests',
            c.user.value?.interests.length.toString() ?? '0', '🎯'),
        const SizedBox(width: 10),
        _statCard('Member', 'Active', '✅'),
        const SizedBox(width: 10),
        _statCard('Posts', '🕵️ Anon', '📝'),
      ],
    );
  }

  Widget _statCard(String label, String value, String emoji) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 6),
            Text(value,
                style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }

  
  Widget _buildInterestsSection(ProfileController c) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Interests', style: AppTextStyles.h3),
              Obx(() => GestureDetector(
                onTap: () {
                  c.isEditingInterests.value = !c.isEditingInterests.value;
                },
                child: Text(
                  c.isEditingInterests.value ? 'Cancel' : 'Edit',
                  style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary, fontWeight: FontWeight.w700),
                ),
              )),
            ],
          ),
          const SizedBox(height: 12),

          
          Obx(() {
            final allCats = AppConstants.interestCategories;
            final cats = c.isEditingInterests.value
                ? allCats
                : (c.user.value?.interests ?? []);

            if (cats.isEmpty) {
              return Text('No interests selected yet.',
                  style: AppTextStyles.bodySmall);
            }

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: cats.map((cat) {
                final isSelected = c.isInterestSelected(cat);
                return CategoryChip(
                  label: cat,
                  emoji: AppConstants.categoryEmoji[cat],
                  isSelected: isSelected,
                  onTap: c.isEditingInterests.value
                      ? () => c.toggleInterest(cat)
                      : () {},
                  showRemove: c.isEditingInterests.value && isSelected,
                  onRemove: () => c.toggleInterest(cat),
                );
              }).toList(),
            );
          }),

          
          Obx(() => c.isEditingInterests.value
              ? Padding(
            padding: const EdgeInsets.only(top: 14),
            child: CustomButton(
              label: 'Save Interests',
              onTap: c.saveInterests,
              isLoading: c.isLoading.value,
              height: 44,
            ),
          )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  
  Widget _buildActions(ProfileController c) {
    return Column(
      children: [
        _profileAction(
          icon: Icons.settings_outlined,
          iconBg: AppColors.primaryPale,
          iconColor: AppColors.primary,
          title: 'Edit Profile',
          subtitle: 'Update your name',
          onTap: () => _showEditNameSheet(c),
        ),
        const SizedBox(height: 8),
        _profileAction(
          icon: Icons.help_outline_rounded,
          iconBg: AppColors.accentLight,
          iconColor: AppColors.accent,
          title: 'Help & Support',
          subtitle: 'FAQs and contact',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _profileAction({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.labelLarge),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }

  void _showEditNameSheet(ProfileController c) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            Text('Edit Name', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            TextField(
              controller: c.nameCtrl,
              style: AppTextStyles.inputText,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person_outline_rounded,
                    size: 20, color: AppColors.textTertiary),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.border, width: 1.5)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: 'Save Name',
              onTap: () async {
                await c.saveName();
                Get.back();
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}