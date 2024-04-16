import 'package:get/get.dart';
import './parking_controller.dart';

class ParkingBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(ParkingController());
    }
}