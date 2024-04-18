class ConstantsApp {
  ConstantsApp._();

  /// Database
  static const String tableVacancy = 'vacancy';
  static const String tableParkingSpace = 'parking_space';
  static const String databaseName = "john_parking.db";
  static const int databaseVersion = 1;

  /// Tables Column
  ///
  /// Vacancy
  static const String columnVacancyIdVacancy = 'vacancyId';
  static const String columnDescriptionVacancy = 'description';
  static const String columnLicensePlateVacancy = 'licensePlate';
  static const String columnEntryTimeVacancy = 'entryTime';
  static const String columnDepartureTimeVacancy = 'departureTime';
  static const String columnParkingSpaceIdVacancy = 'parkingSpaceId';

  /// Keys
}
