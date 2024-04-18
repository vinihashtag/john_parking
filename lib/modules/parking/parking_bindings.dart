import 'package:get/get.dart';
import 'package:john_parking/data/repositories/parking/parking_repository.dart';
import 'package:john_parking/data/repositories/parking/parking_repository_interface.dart';
import '../../data/database/database_provider.dart';
import './parking_controller.dart';

class ParkingBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(DatabaseProvider());
    Get.put<IParkingRepository>(ParkingRepository(Get.find()));
    Get.put(ParkingController(Get.find()));
  }
}
