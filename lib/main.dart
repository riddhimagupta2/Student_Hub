import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import 'app/constants/constant.dart';
import 'app/routes/app_page.dart';
import 'app/routes/app_route.dart';
import 'app/theme/app_theme.dart';
import 'data/repositories/auth_repo.dart';
import 'data/repositories/post_repo.dart';
import 'data/services/auth_service.dart';
import 'data/services/fiirestore_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Get.put<AuthService>(AuthService(), permanent: true);
  Get.put<FirestoreService>(FirestoreService(), permanent: true);

  Get.put<AuthRepository>(
    AuthRepository(Get.find<AuthService>(), Get.find<FirestoreService>()),
    permanent: true,
  );
  Get.put<PostRepository>(
    PostRepository(Get.find<FirestoreService>()),
    permanent: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 280),
      builder: (context, child) {
        return MediaQuery(
          // Prevent font scaling from breaking UI
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaleFactor.clamp(0.85, 1.2),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
