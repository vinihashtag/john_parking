import 'package:flutter_test/flutter_test.dart';
import 'package:john_parking/data/models/vacancy_model.dart';
import 'package:john_parking/shared/extensions/date_extension.dart';
import 'package:john_parking/shared/utils/constants.dart';

void main() {
  group('[VACANCY MODEL]', () {
    test('should returns a vacancy with entrance and no exit', () async {
      //Arrange
      final vacancyJsonMock = {
        'id': 2,
        ConstantsApp.columnDescriptionVacancy: 'Creta Preto',
        ConstantsApp.columnLicensePlateVacancy: 'FTP2F13',
        ConstantsApp.columnEntryTimeVacancy: DateTime.now().millisecondsSinceEpoch,
        ConstantsApp.columnDepartureTimeVacancy: null,
        ConstantsApp.columnParkingSpaceIdVacancy: 1,
      };

      //Act
      final model = VacancyModel.fromMap(vacancyJsonMock);

      //Assert
      expect(model.id, 2);
      expect(model.description, 'Creta Preto');
      expect(model.licensePlate, 'FTP2F13');
      expect(model.entryTime.equals(DateTime.now()), true);
      expect(model.departureTime, null);
      expect(model.parkingSpaceId, 1);
    });

    test('should returns a vacancy with entrance and exit', () async {
      //Arrange
      final vacancyJsonMock = {
        'id': 2,
        ConstantsApp.columnDescriptionVacancy: 'Creta Preto',
        ConstantsApp.columnLicensePlateVacancy: 'FTP2F13',
        ConstantsApp.columnEntryTimeVacancy: DateTime.now().millisecondsSinceEpoch,
        ConstantsApp.columnDepartureTimeVacancy: DateTime.now().millisecondsSinceEpoch,
        ConstantsApp.columnParkingSpaceIdVacancy: 1,
      };

      //Act
      final model = VacancyModel.fromMap(vacancyJsonMock);

      //Assert
      expect(model.id, 2);
      expect(model.description, 'Creta Preto');
      expect(model.licensePlate, 'FTP2F13');
      expect(model.entryTime.equals(DateTime.now()), true);
      expect(model.departureTime!.equals(DateTime.now()), true);
      expect(model.parkingSpaceId, 1);
    });
  });
}
