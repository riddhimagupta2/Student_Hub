import 'dart:async';
import 'package:get/get.dart';
import '../../../data/models/post.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/auth_repo.dart';
import '../../../data/repositories/post_repo.dart';

class HomeController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final PostRepository _postRepository = Get.find<PostRepository>();

  
  final RxInt selectedIndex          = 0.obs;
  final Rx<UserModel?> currentUser   = Rx<UserModel?>(null);
  final RxList<PostModel> posts      = <PostModel>[].obs;
  final RxString selectedCategory    = 'All'.obs;
  final RxBool isLoading             = true.obs;

  StreamSubscription<List<PostModel>>? _postsSubscription;

  @override
  void onReady() {
    super.onReady();
    _loadUser();
    _listenToPosts();
  }

  
  Future<void> _loadUser() async {
    final user = await _authRepository.fetchCurrentUser();
    currentUser.value = user;
  }


  void _listenToPosts() {
    isLoading.value = true;
    posts.clear();

    _postsSubscription?.cancel();

    _postsSubscription = _postRepository
        .getPostsByCategoryStream(selectedCategory.value)
        .listen((data) {
      posts.assignAll(data);
      isLoading.value = false;
    }, onError: (_) {
      posts.clear();
      isLoading.value = false;
    });
  }

  
  void filterByCategory(String category) {
    if (selectedCategory.value == category) return;
    selectedCategory.value = category;
    _listenToPosts();
  }

  
  void changeTab(int index) {
    selectedIndex.value = index;
  }

  
  Future<void> refreshUser() async {
    await _loadUser();
  }

  String get greeting {
    final name = currentUser.value?.name.split(' ').first ?? 'Student';
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning, $name! ☀';
    if (hour < 17) return 'Good afternoon, $name! ';
    return 'Good evening, $name! ';
  }

  @override
  void onClose() {
    _postsSubscription?.cancel();
    super.onClose();
  }
}