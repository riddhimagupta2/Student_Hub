import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/constants/constant.dart';
import '../../../app/routes/app_route.dart';
import '../../../data/repositories/auth_repo.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  late TabController tabController;

  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  final loginEmailCtrl = TextEditingController();
  final loginPasswordCtrl = TextEditingController();

  final regNameCtrl = TextEditingController();
  final regEmailCtrl = TextEditingController();
  final regPasswordCtrl = TextEditingController();
  final regConfirmCtrl = TextEditingController();

  final RxBool isLoginLoading = false.obs;
  final RxBool isRegisterLoading = false.obs;
  final RxBool loginObscure = true.obs;
  final RxBool regObscure = true.obs;
  final RxBool regConfirmObscure = true.obs;

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;
    isLoginLoading.value = true;
    try {
      await _authRepository.login(
        email: loginEmailCtrl.text,
        password: loginPasswordCtrl.text,
      );
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      _showError(_parseFirebaseError(e.toString()));
    } finally {
      isLoginLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;
    isRegisterLoading.value = true;
    try {
      await _authRepository.register(
        name: regNameCtrl.text.trim(),
        email: regEmailCtrl.text.trim(),
        password: regPasswordCtrl.text,
      );
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      _showError(_parseFirebaseError(e.toString()));
    } finally {
      isRegisterLoading.value = false;
    }
  }

  String? validateName(String? val) {
    if (val == null || val.trim().isEmpty) return 'Name is required';
    if (val.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? validateEmail(String? val) {
    if (val == null || val.trim().isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(val.trim())) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String? val) {
    if (val == null || val.isEmpty) return 'Password is required';
    if (val.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? val) {
    if (val == null || val.isEmpty) return 'Please confirm your password';
    if (val != regPasswordCtrl.text) return 'Passwords do not match';
    return null;
  }

  void toggleLoginObscure() => loginObscure.value = !loginObscure.value;
  void toggleRegObscure() => regObscure.value = !regObscure.value;
  void toggleConfirmObscure() =>
      regConfirmObscure.value = !regConfirmObscure.value;

  void _showError(String message) {
    Get.snackbar(
      AppConstants.errorTitle,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF9F1239),
      colorText: const Color(0xFFFFFFFF),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
    );
  }

  String _parseFirebaseError(String error) {
    if (error.contains('user-not-found'))
      return 'No account found with this email.';
    if (error.contains('wrong-password'))
      return 'Incorrect password. Please try again.';
    if (error.contains('email-already-in-use'))
      return 'This email is already registered.';
    if (error.contains('weak-password')) return 'Password is too weak.';
    if (error.contains('invalid-email'))
      return 'Please enter a valid email address.';
    if (error.contains('network-request-failed'))
      return 'No internet connection.';
    if (error.contains('too-many-requests'))
      return 'Too many attempts. Please try later.';
    return 'Something went wrong. Please try again.';
  }

  @override
  void onClose() {
    loginEmailCtrl.dispose();
    loginPasswordCtrl.dispose();
    regNameCtrl.dispose();
    regEmailCtrl.dispose();
    regPasswordCtrl.dispose();
    regConfirmCtrl.dispose();
    super.onClose();
  }
}
