import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:john_parking/shared/theme/app_theme.dart';

import './parking_controller.dart';
import 'widgets/historic_parking_widget.dart';
import 'widgets/list_parking_widget.dart';

class ParkingPage extends GetView<ParkingController> {
  const ParkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('John Parking'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: TabBar(
            controller: controller.tabController,
            indicatorColor: AppTheme.primaryColor,
            indicatorWeight: 6,
            tabs: const [Tab(text: 'Vagas'), Tab(text: 'Histórico')],
          ),
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // * Vacancies
          ListParkingWidget(controller: controller),

          // * Historic
          HistoricParkingWidget(controller: controller),
        ],
      ),
    );
  }
}
