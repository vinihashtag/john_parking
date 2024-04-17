import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:john_parking/data/models/response_model.dart';
import 'package:john_parking/data/models/vacancy_model.dart';
import 'package:john_parking/shared/enums/status_type_enum.dart';
import 'package:john_parking/shared/extensions/date_extension.dart';
import 'package:john_parking/shared/extensions/string_extension.dart';

import '../../data/models/parking_space_model.dart';

class ParkingController extends GetxController with GetSingleTickerProviderStateMixin {
  // * Controllers
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  TabController? tabController;
  final TextEditingController descriptionVehicle = TextEditingController();
  final TextEditingController vehicleLicensePlate = TextEditingController();
  final TextEditingController dateInitial = TextEditingController(text: DateTime.now().formatddMMyyyy);
  final TextEditingController dateEnd = TextEditingController(text: DateTime.now().formatddMMyyyy);

  // * Observables
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  /// Controls status of page in tab historic
  final Rx<StatusTypeEnum> _status = Rx<StatusTypeEnum>(StatusTypeEnum.idle);
  StatusTypeEnum get status => _status.value;

  /// Controls a list of vacancy
  final RxList<ParkingSpaceModel> listParkingSpace = RxList<ParkingSpaceModel>();

  /// Controls a list of vacancy
  final RxList<ParkingSpaceModel> listVacancy = RxList<ParkingSpaceModel>();

  // * Getters
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  int get totalParkingSpace => listParkingSpace.length;
  int get availableParkingSpace => listParkingSpace.where((item) => item.vacancyModel == null).length;
  int get unavailableParkingSpace => listParkingSpace.where((item) => item.vacancyModel != null).length;
  bool get datesValid =>
      (dateInitial.text.trim().isNotEmpty && dateEnd.text.trim().isNotEmpty) &&
          dateInitial.text.toDate.isBefore(dateEnd.text.toDate) ||
      dateInitial.text.toDate.equals(dateEnd.text.toDate);

  // * Actions
  // * ----------------------------------------------------------------------------------------------------------------
  // * ----------------------------------------------------------------------------------------------------------------

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    List.generate(50, (index) => listParkingSpace.add(ParkingSpaceModel(position: index)));
    super.onInit();
  }

  void getStatusParking() {}

  /// Creates a reservation
  ResponseModel createParkingReservation(ParkingSpaceModel parking) {
    final int index = listParkingSpace.indexWhere((element) => element.position == parking.position);

    listParkingSpace[index] = parking.copyWith(
      vacancyModel: VacancyModel(
          description: descriptionVehicle.text.trim(),
          licensePlate: vehicleLicensePlate.text.trim(),
          entryTime: DateTime.now()),
    );

    return ResponseModel(data: 'Reserva efetuada com sucesso!');
  }

  /// Finalizes a reservation
  ResponseModel finalizeParkingReservation(ParkingSpaceModel parking) {
    final int index = listParkingSpace.indexWhere((element) => element.position == parking.position);

    listParkingSpace[index] = ParkingSpaceModel(position: index);

    return ResponseModel(data: 'Reserva finalizada com sucesso!');
  }

  /// Makes a filter in historic of parking space
  Future<void> filterHistoric() async {
    if (status.isLoading) return;

    _status.value = StatusTypeEnum.loading;

    await 1.delay();

    listVacancy.clear();

    listVacancy.addAll(_localListToTest.where((element) {
      final initial = element.vacancyModel!.entryTime.equals(dateInitial.text.toDate) ||
          element.vacancyModel!.entryTime.isAfter(dateInitial.text.toDate);
      final end = (element.vacancyModel!.departureTime?.equals(dateEnd.text.toDate) ?? false) ||
          (element.vacancyModel!.departureTime?.isBefore(dateEnd.text.toDate) ?? false) ||
          element.vacancyModel!.departureTime == null;
      return initial && end;
    }));

    _status.value = StatusTypeEnum.success;
  }

  final _localListToTest = <ParkingSpaceModel>[
    ParkingSpaceModel(
      position: 0,
      vacancyModel: VacancyModel(
        description: 'description1',
        licensePlate: 'plate1',
        entryTime: DateTime(2024, 04, 16),
        departureTime: DateTime(2024, 04, 16),
      ),
    ),
    ParkingSpaceModel(
      position: 0,
      vacancyModel: VacancyModel(
        description: 'description2',
        licensePlate: 'plate2',
        entryTime: DateTime(2024, 04, 15),
        departureTime: DateTime(2024, 04, 16),
      ),
    ),
    ParkingSpaceModel(
      position: 0,
      vacancyModel: VacancyModel(
        description: 'description3',
        licensePlate: 'plate3',
        entryTime: DateTime(2024, 04, 14),
        departureTime: DateTime(2024, 04, 14),
      ),
    ),
    ParkingSpaceModel(
      position: 0,
      vacancyModel: VacancyModel(
        description: 'description4',
        licensePlate: 'plate4',
        entryTime: DateTime(2024, 04, 10),
        departureTime: DateTime(2024, 04, 16),
      ),
    ),
    ParkingSpaceModel(
      position: 0,
      vacancyModel: VacancyModel(
        description: 'description5',
        licensePlate: 'plate5',
        entryTime: DateTime(2024, 04, 9),
        departureTime: DateTime(2024, 04, 9),
      ),
    ),
    ParkingSpaceModel(
      position: 0,
      vacancyModel: VacancyModel(
        description: 'description6',
        licensePlate: 'plate6',
        entryTime: DateTime(2024, 04, 9),
        departureTime: DateTime(2024, 04, 9),
      ),
    ),
    ParkingSpaceModel(
      position: 0,
      vacancyModel: VacancyModel(
        description: 'description7',
        licensePlate: 'plate7',
        entryTime: DateTime(2024, 04, 16, 08, 30),
        departureTime: DateTime(2024, 04, 16, 9, 45),
      ),
    ),
    ParkingSpaceModel(
      position: 0,
      vacancyModel: VacancyModel(
        description: 'description8',
        licensePlate: 'plate8',
        entryTime: DateTime(2024, 04, 16, 08, 15),
        departureTime: DateTime(2024, 04, 16, 18, 30),
      ),
    ),
    ParkingSpaceModel(
      position: 0,
      vacancyModel: VacancyModel(
        description: 'description8',
        licensePlate: 'plate8',
        entryTime: DateTime(2024, 04, 16, 08, 15),
      ),
    ),
  ];

  @override
  void onClose() {
    tabController?.dispose();
    descriptionVehicle.dispose();
    vehicleLicensePlate.dispose();
    dateInitial.dispose();
    dateEnd.dispose();
    super.onClose();
  }
}
