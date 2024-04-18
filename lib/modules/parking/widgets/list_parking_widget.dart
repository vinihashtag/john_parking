import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:john_parking/shared/utils/constants.dart';
import 'package:john_parking/shared/utils/custom_snackbar.dart';

import '../../../data/models/parking_space_model.dart';
import '../../../shared/animations/animate_do_fades.dart';
import '../../../shared/animations/animate_do_zooms.dart';
import '../../../shared/utils/license_plate_formatter.dart';
import '../../../shared/widgets/custom_sliver_persistent_header.dart';
import '../parking_controller.dart';

class ListParkingWidget extends StatelessWidget {
  final ParkingController controller;

  const ListParkingWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.statusParkingSpace.isLoading) {
        return const Center(key: Key(ConstantsApp.kLoadingParkingSpace), child: CircularProgressIndicator());
      }

      if (controller.statusParkingSpace.isFailure) {
        return ZoomIn(
          key: const Key(ConstantsApp.kFailureParkingSpace),
          duration: const Duration(milliseconds: 350),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, color: Colors.black38, size: 80),
                const SizedBox(height: 16),
                const Text(
                  'Ocorreu um erro ao carregar as vagas do estacionamento',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                ElevatedButton(onPressed: controller.getListParkingSpace, child: const Text('TENTAR NOVAMENTE'))
              ],
            ),
          ),
        );
      }
      return CustomScrollView(
        slivers: [
          // * Header Infos about parking space
          SliverPersistentHeader(
            floating: true,
            pinned: true,
            key: const Key(ConstantsApp.kTitleParkingSpace),
            delegate: CustomSliverPersistentHeaderDelegate(
              minHeight: 95,
              maxHeight: 95,
              child: FadeInDown(
                duration: const Duration(milliseconds: 400),
                child: Material(
                  elevation: 4,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.grey.shade800,
                    child: Obx(
                      () => Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Total Vagas: ${controller.totalParkingSpace}',
                              style: const TextStyle(color: Colors.white, fontSize: 16)),
                          Text('Vagas Utilizadas: ${controller.unavailableParkingSpace}',
                              style: const TextStyle(color: Colors.white, fontSize: 16)),
                          Text('Vagas Disponíveis: ${controller.availableParkingSpace}',
                              style: const TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // * Grid of parking space
          SliverPadding(
            key: const Key(ConstantsApp.kListParkingSpace),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            sliver: Obx(() {
              return SliverGrid.builder(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.95),
                itemCount: controller.totalParkingSpace,
                itemBuilder: (context, index) {
                  final ParkingSpaceModel parkingSpace = controller.listParkingSpace[index];
                  return ZoomIn(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 250),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          controller.descriptionVehicle.text = parkingSpace.vacancyModel?.description ?? '';
                          controller.vehicleLicensePlate.text = parkingSpace.vacancyModel?.licensePlate ?? '';
                          if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
                          final bool isAvailable = parkingSpace.vacancyModel == null;
                          Get.dialog(
                            ZoomIn(
                              duration: const Duration(milliseconds: 350),
                              child: Dialog(
                                insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Center(
                                        child: Text(
                                          'Vaga',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border:
                                                Border.all(color: isAvailable ? Colors.green : Colors.red, width: 4),
                                            shape: BoxShape.circle),
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          '${parkingSpace.id}',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      const Text('Descritivo do veículo',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                      TextFormField(
                                        autofocus: isAvailable,
                                        autocorrect: false,
                                        enableSuggestions: false,
                                        controller: controller.descriptionVehicle,
                                        readOnly: !isAvailable,
                                        textCapitalization: TextCapitalization.words,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        decoration: const InputDecoration(hintText: 'Informe dados do veículo'),
                                        validator: (value) => controller.descriptionVehicle.text.trim().length >= 3
                                            ? null
                                            : 'Informe uma descrição válida do veículo',
                                      ),
                                      const SizedBox(height: 25),
                                      const Text('Placa do veículo',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                      TextFormField(
                                        autocorrect: false,
                                        enableSuggestions: false,
                                        controller: controller.vehicleLicensePlate,
                                        readOnly: !isAvailable,
                                        textCapitalization: TextCapitalization.characters,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        decoration: const InputDecoration(hintText: 'Informe a placa do veículo'),
                                        inputFormatters: [PlacaVeiculoInputFormatter()],
                                        keyboardType: TextInputType.visiblePassword,
                                        validator: (value) => controller.vehicleLicensePlate.text.trim().length == 7
                                            ? null
                                            : 'Informe uma placa de veículo válida',
                                      ),
                                      const SizedBox(height: 25),
                                      Offstage(
                                        offstage: isAvailable,
                                        child: const Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Center(
                                            child: Text(
                                              'Deseja realmente finalizar esta reserva?',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              icon: const Icon(Icons.close, size: 18),
                                              label: const Text('CANCELAR',
                                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Visibility(
                                              visible: parkingSpace.vacancyModel == null,
                                              replacement: ElevatedButton.icon(
                                                key: const Key(ConstantsApp.kLButtonFinalizeReservation),
                                                onPressed: () async {
                                                  Get.back();
                                                  final response =
                                                      await controller.finalizeParkingReservation(parkingSpace);
                                                  if (response.isSuccess) {
                                                    CustomSnackbar.showMessageSuccess(
                                                        title: 'FINALIZADO', message: response.data!);
                                                  } else {
                                                    CustomSnackbar.showMessageError(
                                                      message: response.error ??
                                                          'Não foi possível liberar esta vaga, tente mais tarde novamente!',
                                                    );
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                icon: const Icon(Icons.check, size: 18),
                                                label: const Text('FINALIZAR',
                                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                              ),
                                              child: ListenableBuilder(
                                                  listenable: Listenable.merge([
                                                    controller.descriptionVehicle,
                                                    controller.vehicleLicensePlate,
                                                  ]),
                                                  builder: (context, child) {
                                                    final bool isValid =
                                                        controller.descriptionVehicle.text.trim().length >= 3 &&
                                                            controller.vehicleLicensePlate.text.trim().length == 7;
                                                    return ElevatedButton.icon(
                                                      key: const Key(ConstantsApp.kLButtonReservation),
                                                      onPressed: !isValid
                                                          ? null
                                                          : () async {
                                                              Get.back();
                                                              final response = await controller
                                                                  .createParkingReservation(parkingSpace);
                                                              if (response.isSuccess) {
                                                                CustomSnackbar.showMessageSuccess(
                                                                    title: 'RESERVADO', message: response.data!);
                                                              } else {
                                                                CustomSnackbar.showMessageError(
                                                                  message: response.error ??
                                                                      'Não foi possível efetuar a reserva, tente mais tarde novamente!',
                                                                );
                                                              }
                                                            },
                                                      icon: const Icon(Icons.check, size: 18),
                                                      label: const Text('RESERVAR',
                                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                                    );
                                                  }),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 2),
                              child: Text(
                                '${parkingSpace.id}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: parkingSpace.vacancyModel != null ? Colors.red : Colors.green,
                              ),
                              child: Text(
                                parkingSpace.vacancyModel == null ? 'LIVRE' : 'OCUPADO',
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            if (parkingSpace.vacancyModel != null) ...[
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Text('PLACA', style: TextStyle(color: Colors.black45, fontSize: 12)),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade200,
                                ),
                                child: Text(
                                  parkingSpace.vacancyModel!.licensePlate,
                                  style:
                                      const TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          )
        ],
      );
    });
  }
}
