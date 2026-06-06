import 'package:get/get.dart';
import '../../create_post/controllers/create_post_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());

    Get.lazyPut<CreatePostController>(() => CreatePostController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
