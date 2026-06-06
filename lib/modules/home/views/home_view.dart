import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/colours.dart';
import '../../create_post/views/create_post_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/home_controller.dart';
import 'feed_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: controller.selectedIndex.value,
        children: const [
          FeedView(),
          CreatePostView(),
          ProfileView(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    ));
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Obx(() => NavigationBar(
        selectedIndex: controller.selectedIndex.value,
        onDestinationSelected: controller.changeTab,
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 64,
        indicatorColor: AppColors.primaryPale,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined,
                color: controller.selectedIndex.value == 0
                    ? AppColors.primary
                    : AppColors.textTertiary),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_square,
                color: controller.selectedIndex.value == 1
                    ? AppColors.primary
                    : AppColors.textTertiary),
            label: 'Post',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded,
                color: controller.selectedIndex.value == 2
                    ? AppColors.primary
                    : AppColors.textTertiary),
            label: 'Profile',
          ),
        ],
      )),
    );
  }
}