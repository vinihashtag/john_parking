import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:john_parking/shared/animations/animate_do_fades.dart';
import 'package:john_parking/shared/extensions/date_extension.dart';
import 'package:john_parking/shared/extensions/string_extension.dart';

import '../../../data/models/parking_space_model.dart';
import '../../../shared/animations/animate_do_zooms.dart';
import '../../../shared/widgets/custom_sliver_persistent_header.dart';
import '../parking_controller.dart';

class HistoricParkingWidget extends StatelessWidget {
  final ParkingController controller;

  const HistoricParkingWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          floating: true,
          pinned: true,
          delegate: CustomSliverPersistentHeaderDelegate(
            minHeight: 80,
            maxHeight: 80,
            child: FadeInDown(
              duration: const Duration(milliseconds: 400),
              child: Material(
                color: Colors.white,
                shadowColor: Colors.white,
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Data Inicial', style: TextStyle(fontSize: 12)),
                            TextFormField(
                              readOnly: true,
                              textAlign: TextAlign.center,
                              controller: controller.dateInitial,
                              onTap: () async {
                                final result = await Get.dialog(
                                  DatePickerDialog(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                    initialDate: controller.dateInitial.text.toDate,
                                    switchToInputEntryModeIcon:
                                        const Icon(Icons.calendar_month, color: Colors.transparent),
                                  ),
                                );

                                if (result is DateTime) {
                                  if (controller.dateEnd.text.toDate.isBefore(result)) controller.dateEnd.clear();
                                  controller.dateInitial.text = result.formatddMMyyyy;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Data Final', style: TextStyle(fontSize: 12)),
                            TextFormField(
                              readOnly: true,
                              textAlign: TextAlign.center,
                              controller: controller.dateEnd,
                              enabled: controller.dateInitial.text.isNotEmpty,
                              onTap: () async {
                                final result = await Get.dialog(
                                  DatePickerDialog(
                                    firstDate: controller.dateInitial.text.toDate,
                                    lastDate: DateTime.now(),
                                    initialDate: controller.dateEnd.text.toDate,
                                    switchToInputEntryModeIcon:
                                        const Icon(Icons.calendar_month, color: Colors.transparent),
                                  ),
                                );

                                if (result is DateTime) {
                                  if (controller.dateInitial.text.isEmpty) {
                                    controller.dateInitial.text = result.formatddMMyyyy;
                                  }
                                  controller.dateEnd.text = result.formatddMMyyyy;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: ListenableBuilder(
                            listenable: Listenable.merge([controller.dateInitial, controller.dateEnd]),
                            builder: (context, child) {
                              return IconButton.filled(
                                  onPressed: !controller.datesValid ? null : controller.filterHistoric,
                                  icon: const Icon(Icons.search, color: Colors.white));
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Obx(() {
          if (controller.status.isLoading) {
            return const SliverFillRemaining(
                child: Align(alignment: Alignment.topCenter, child: LinearProgressIndicator()));
          }
          return SliverVisibility(
            visible: controller.listVacancy.isNotEmpty,
            replacementSliver: SliverToBoxAdapter(
              child: Offstage(
                offstage: controller.dateInitial.text.trim().isEmpty ||
                    controller.dateEnd.text.trim().isEmpty ||
                    controller.status.isInitial,
                child: ZoomIn(
                  duration: const Duration(milliseconds: 350),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: Colors.black38, size: 80),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum resultado encontrado para o filtro informado',
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            sliver: SliverPadding(
              padding: const EdgeInsets.fromLTRB(6, 8, 6, 40),
              sliver: SliverList.builder(
                  itemCount: controller.listVacancy.length,
                  itemBuilder: (context, index) {
                    final ParkingSpaceModel item = controller.listVacancy[index];
                    final String exitText = item.vacancyModel!.departureTime?.formatddMMyyyyHHmm ?? '';
                    return FadeInUp(
                      duration: const Duration(milliseconds: 300),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Data Entrada',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                      child: Container(
                                          margin: const EdgeInsets.fromLTRB(8, 6, 8, 0),
                                          height: 1,
                                          color: Colors.grey.shade300)),
                                  Text(
                                    item.vacancyModel!.entryTime.formatddMMyyyyHHmm,
                                    style:
                                        const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.green),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Data Saída',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                      child: Container(
                                          margin: const EdgeInsets.fromLTRB(8, 6, 8, 0),
                                          height: 1,
                                          color: Colors.grey.shade300)),
                                  Text(
                                    exitText.isEmpty ? DateTime.now().formatddMMyyyyHHmm : exitText,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: exitText.isEmpty ? Colors.transparent : Colors.red),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text(
                                    'Veículo:  ',
                                    style: TextStyle(fontSize: 12, height: .85, fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(child: Text(item.vacancyModel!.description, maxLines: 1)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Placa:  ',
                                    style: TextStyle(fontSize: 12, height: .85, fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(child: Text(item.vacancyModel!.licensePlate, maxLines: 1)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          );
        })
      ],
    );
  }
}
