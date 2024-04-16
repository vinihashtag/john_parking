import '../../../shared/errors/custom_error.dart';
import '../../models/parking_space_model.dart';
import '../../models/vacancy_model.dart';
import '../../models/response_model.dart';

abstract class IParkingRepository {
  Future<ResponseModel<List<VacancyModel>, CustomException>> getHistoricParkingByPeriod(
      {required DateTime initDate, required DateTime endDate});

  Future<ResponseModel<VacancyModel, CustomException>> saveParking(ParkingSpaceModel parking);
}
