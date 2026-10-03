import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:auth_ui_app/core/migration/legacy_getstorage_migrator.dart';
import 'package:auth_ui_app/features/authentication/screens/splash/splash.dart';
import 'package:auth_ui_app/routes/app_routes.dart';
import 'package:auth_ui_app/services/connectivity_service.dart';
import 'package:auth_ui_app/services/secure_storage_service.dart';
import 'package:auth_ui_app/services/sync_controller.dart';
import 'package:auth_ui_app/utils/constants/text_strings.dart';
import 'package:auth_ui_app/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize lightweight preferences storage
  try {
    await GetStorage.init();
  } catch (e) {
    debugPrint("GetStorage init error: $e");
  }

  // 2. Initialize hardware-backed secure credentials storage and migrate legacy auth tokens
  try {
    await SecureStorageService.instance.initialize();
  } catch (e) {
    debugPrint("SecureStorageService init error: $e");
  }

  // 3. Run one-time database migration from legacy GetStorage to Drift SQLite
  try {
    await LegacyGetStorageMigrator.migrateIfNeeded();
  } catch (e) {
    debugPrint("LegacyGetStorageMigrator error: $e");
  }

  // 4. Initialize connectivity listener and AppLifecycle state observer
  try {
    await ConnectivityService.instance.initialize();
  } catch (e) {
    debugPrint("ConnectivityService init error: $e");
  }

  // 5. Initialize SyncController with Drift SQLite reactive streams
  try {
    Get.put(SyncController(), permanent: true);
  } catch (e) {
    debugPrint("SyncController init error: $e");
  }

  runApp(const AuthUiApp());
}

class AuthUiApp extends StatelessWidget {
  const AuthUiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: TTexts.appName,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: const SplashScreen(),
      getPages: AppRoutes.pages,
    );
  }
}
