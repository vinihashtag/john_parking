import 'package:get/get.dart';

import '../../modules/parking/parking_bindings.dart';
import '../../modules/parking/parking_page.dart';

class RoutesApp {
  RoutesApp._();

  static const String parking = '/parking';

  static final routes = [
    GetPage(
      name: RoutesApp.parking,
      page: () => const ParkingPage(),
      binding: ParkingBindings(),
    ),
  ];
}
