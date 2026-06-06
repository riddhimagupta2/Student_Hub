import 'package:get/get.dart';
import '../../../app/routes/app_route.dart';
import '../../../data/repositories/auth_repo.dart';


class SplashController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  @override
  void onInit() {
    super.onInit();
    print("SplashController Init");
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    print("Splash auth checking...");

    await Future.delayed(const Duration(seconds: 2));

    final user = _authRepository.currentUser;
    print("Current user: $user");
    if (user != null) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}