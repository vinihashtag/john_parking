import '../../../shared/errors/custom_error.dart';
import '../../models/parking_space_model.dart';
import '../../models/vacancy_model.dart';
import '../../models/response_model.dart';

abstract class IParkingRepository {
  Future<ResponseModel<ParkingSpaceModel, CustomException>> saveParkingSpace(ParkingSpaceModel parking);

  Future<ResponseModel<void, CustomException>> removeParkingSpace(ParkingSpaceModel parking);

  Future<ResponseModel<List<ParkingSpaceModel>, CustomException>> getAllParkingSpace();

  Future<ResponseModel<List<VacancyModel>, CustomException>> getHistoricParkingByPeriod(
      {required DateTime initDate, required DateTime endDate});
}
