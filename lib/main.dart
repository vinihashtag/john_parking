import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'shared/routes/app_routes.dart';
import 'shared/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'John Parking',
      debugShowCheckedModeBanner: false,
      initialBinding: MainBindings(),
      theme: AppTheme.defaultTheme,
      getPages: RoutesApp.routes,
      initialRoute: RoutesApp.parking,
    );
  }
}

class MainBindings implements Bindings {
  @override
  void dependencies() {}
}
