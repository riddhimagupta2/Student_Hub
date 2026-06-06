import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../app/constants/constant.dart';
import '../../../data/models/post.dart';
import '../../../data/repositories/auth_repo.dart';
import '../../../data/repositories/post_repo.dart';

class CreatePostController extends GetxController {
  final PostRepository _postRepository = Get.find<PostRepository>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final formKey = GlobalKey<FormState>();
  final contentCtrl = TextEditingController();
  final RxString selectedCategory = 'Technology'.obs;
  final RxBool isLoading = false.obs;
  final RxInt charCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    contentCtrl.addListener(() {
      charCount.value = contentCtrl.text.length;
    });
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  String? validateContent(String? val) {
    if (val == null || val.trim().isEmpty)
      return 'Please write something to post';
    if (val.trim().length < AppConstants.minPostLength) {
      return 'Post must be at least ${AppConstants.minPostLength} characters';
    }
    if (val.trim().length > AppConstants.maxPostLength) {
      return 'Post cannot exceed ${AppConstants.maxPostLength} characters';
    }
    return null;
  }

  Future<void> submitPost() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;

    try {
      final uid = _authRepository.currentUser?.uid ?? '';
      final post = PostModel(
        postId: const Uuid().v4(),
        content: contentCtrl.text.trim(),
        category: selectedCategory.value,
        timestamp: DateTime.now(),
        userId: uid,
      );

      await _postRepository.createPost(post);
      contentCtrl.clear();
      charCount.value = 0;

      Get.snackbar(
        AppConstants.successTitle,
        'Your anonymous post is now live! 🕵️',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF065F46),
        colorText: const Color(0xFFFFFFFF),
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        icon: const Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.white,
        ),
      );

      Get.back();
    } catch (e) {
      Get.snackbar(
        AppConstants.errorTitle,
        'Failed to post. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF9F1239),
        colorText: const Color(0xFFFFFFFF),
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    contentCtrl.dispose();
    super.onClose();
  }
}
