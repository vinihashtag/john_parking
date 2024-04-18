import 'package:john_parking/data/database/database_provider.dart';
import 'package:john_parking/data/repositories/parking/parking_repository_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProviderMock extends Mock implements DatabaseProvider {}

class DatabaseMock extends Mock implements Database {}

class ParkingRepositoryMock extends Mock implements IParkingRepository {}
