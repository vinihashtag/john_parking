import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:john_parking/data/models/response_model.dart';
import 'package:john_parking/data/models/vacancy_model.dart';
import 'package:john_parking/data/repositories/parking/parking_repository_interface.dart';
import 'package:john_parking/shared/enums/status_type_enum.dart';
import 'package:john_parking/shared/extensions/date_extension.dart';
import 'package:john_parking/shared/extensions/string_extension.dart';

import '../../data/models/parking_space_model.dart';

class ParkingController extends GetxController with GetSingleTickerProviderStateMixin {
  final IParkingRepository _parkingRepository;

  ParkingController(this._parkingRepository);

  // * Controllers
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  TabController? tabController;
  final TextEditingController descriptionVehicle = TextEditingController();
  final TextEditingController vehicleLicensePlate = TextEditingController();
  final TextEditingController dateFilterInitial = TextEditingController(text: DateTime.now().formatddMMyyyy);
  final TextEditingController dateFilterEnd = TextEditingController(text: DateTime.now().formatddMMyyyy);

  // * Observables
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------
  /// Controls status of page in tab parking space
  final Rx<StatusTypeEnum> _statusParkingSpace = Rx<StatusTypeEnum>(StatusTypeEnum.idle);
  StatusTypeEnum get statusParkingSpace => _statusParkingSpace.value;

  /// Controls status of page in tab historic
  final Rx<StatusTypeEnum> _statusHistoric = Rx<StatusTypeEnum>(StatusTypeEnum.idle);
  StatusTypeEnum get statusHistoric => _statusHistoric.value;

  /// Controls a list of parking space
  final RxList<ParkingSpaceModel> listParkingSpace = RxList<ParkingSpaceModel>();

  /// Controls a list of vacancy
  final RxList<VacancyModel> listVacancy = RxList<VacancyModel>();

  // * Getters
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  int get totalParkingSpace => listParkingSpace.length;
  int get availableParkingSpace => listParkingSpace.where((item) => item.vacancyModel == null).length;
  int get unavailableParkingSpace => listParkingSpace.where((item) => item.vacancyModel != null).length;
  bool get datesValid =>
      dateFilterInitial.text.trim().isNotEmpty &&
      dateFilterEnd.text.trim().isNotEmpty &&
      (dateFilterInitial.text.toDate.isBefore(dateFilterEnd.text.toDate) ||
          dateFilterInitial.text.toDate.equals(dateFilterEnd.text.toDate));

  // * Actions
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    getListParkingSpace();
    super.onInit();
  }

  /// Gets initial list of parking
  Future<void> getListParkingSpace() async {
    if (statusParkingSpace.isLoading) return;

    _statusParkingSpace.value = StatusTypeEnum.loading;

    listParkingSpace.clear();

    final response = await _parkingRepository.getAllParkingSpace();

    if (response.isSuccess) {
      listParkingSpace.addAll(response.data!);
      _statusParkingSpace.value = StatusTypeEnum.success;
    } else {
      _statusParkingSpace.value = StatusTypeEnum.failure;
    }
  }

  /// Creates a reservation
  Future<ResponseModel<String, String>> createParkingReservation(ParkingSpaceModel parking) async {
    final int index = listParkingSpace.indexWhere((element) => element.id == parking.id);

    final ParkingSpaceModel updateParkingSpace = parking.copyWith(
      vacancyModel: VacancyModel(
        description: descriptionVehicle.text.trim(),
        licensePlate: vehicleLicensePlate.text.trim(),
        entryTime: DateTime.now(),
        parkingSpaceId: parking.id,
      ),
    );

    final response = await _parkingRepository.saveParkingSpace(updateParkingSpace);

    if (response.isSuccess) {
      listParkingSpace[index] = response.data!;
      return ResponseModel(data: 'Reserva efetuada com sucesso!');
    } else {
      return ResponseModel(error: 'Erro ao reservar, tente novamente.');
    }
  }

  /// Finalizes a reservation
  Future<ResponseModel<String, String>> finalizeParkingReservation(ParkingSpaceModel parking) async {
    final int index = listParkingSpace.indexWhere((element) => element.id == parking.id);

    final response = await _parkingRepository.removeParkingSpace(parking);

    if (response.isError) {
      return ResponseModel(error: 'Erro ao finalizar a reserva, tente novamente.');
    } else {
      listParkingSpace[index] = ParkingSpaceModel(id: parking.id, vacancyModel: null);
      return ResponseModel(data: 'Reserva finalizada com sucesso!');
    }
  }

  /// Makes a filter in historic of parking space
  Future<void> filterHistoric() async {
    if (statusHistoric.isLoading) return;

    _statusHistoric.value = StatusTypeEnum.loading;

    listVacancy.clear();

    final response = await _parkingRepository.getHistoricParkingByPeriod(
      initDate: dateFilterInitial.text.toDate,
      endDate: dateFilterEnd.text.toDate,
    );

    if (response.isSuccess) {
      listVacancy.addAll(response.data!);
      _statusHistoric.value = StatusTypeEnum.success;
    } else {
      _statusHistoric.value = StatusTypeEnum.failure;
    }
  }

  @override
  void onClose() {
    tabController?.dispose();
    descriptionVehicle.dispose();
    vehicleLicensePlate.dispose();
    dateFilterInitial.dispose();
    dateFilterEnd.dispose();
    super.onClose();
  }
}
