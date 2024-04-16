import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './parking_controller.dart';

class ParkingPage extends GetView<ParkingController> {
  const ParkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ParkingPage'),
      ),
      body: Container(),
    );
  }
}
