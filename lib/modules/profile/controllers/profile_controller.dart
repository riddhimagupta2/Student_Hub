import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/constants/constant.dart';
import '../../../app/routes/app_route.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/auth_repo.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final Rx<UserModel?> user              = Rx<UserModel?>(null);
  final RxList<String> selectedInterests = <String>[].obs;
  final RxBool isLoading                 = false.obs;
  final RxBool isEditingInterests        = false.obs;

  final nameCtrl = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final u = await _authRepository.fetchCurrentUser();
      user.value = u;
      nameCtrl.text = u?.name ?? '';
      selectedInterests.assignAll(u?.interests ?? []);
    } finally {
      isLoading.value = false;
    }
  }

  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
  }

  bool isInterestSelected(String interest) =>
      selectedInterests.contains(interest);

  Future<void> saveInterests() async {
    if (user.value == null) return;
    isLoading.value = true;
    try {
      await _authRepository.updateInterests(
        user.value!.uid,
        selectedInterests.toList(),
      );
      user.value = user.value!.copyWith(interests: selectedInterests.toList());
      isEditingInterests.value = false;

      Get.snackbar(
        AppConstants.successTitle,
        'Interests updated successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF065F46),
        colorText: const Color(0xFFFFFFFF),
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        AppConstants.errorTitle,
        'Failed to update interests.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF9F1239),
        colorText: const Color(0xFFFFFFFF),
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveName() async {
    if (user.value == null) return;
    final newName = nameCtrl.text.trim();
    if (newName.isEmpty || newName == user.value!.name) return;
    isLoading.value = true;
    try {
      final updated = user.value!.copyWith(name: newName);
      await _authRepository.updateProfile(updated);
      user.value = updated;
      Get.snackbar(
        AppConstants.successTitle,
        'Profile updated!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF065F46),
        colorText: const Color(0xFFFFFFFF),
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
      );
    } catch (_) {
      Get.snackbar(AppConstants.errorTitle, 'Update failed.',
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF43F5E),
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _authRepository.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  String get initials {
    final name = user.value?.name ?? 'S';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    super.onClose();
  }
}