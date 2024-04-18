import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:john_parking/modules/parking/parking_controller.dart';
import 'package:john_parking/modules/parking/parking_page.dart';
import 'package:john_parking/shared/utils/constants.dart';

import '../../mocks/class_fake.dart';

void main() {
  tearDown(Get.reset);

  group('[LOAD PARKING SPACE]', () {
    testWidgets('should returns a list of parking space', (tester) async {
      //Arrange
      Get.put(ParkingController(ParkingRepositoryFake()));

      //Act
      await tester.pumpWidget(const GetMaterialApp(home: ParkingPage()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key(ConstantsApp.kLoadingParkingSpace)), findsNothing);
      expect(find.byKey(const Key(ConstantsApp.kFailureParkingSpace)), findsNothing);
      expect(find.byKey(const Key(ConstantsApp.kTitleParkingSpace)), findsOne);
      expect(find.byKey(const Key(ConstantsApp.kListParkingSpace)), findsOne);
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('should returns a empty list of parking space', (tester) async {
      //Arrange
      Get.put(ParkingController(ParkingRepositoryEmptyFake()));

      //Act
      await tester.pumpWidget(const GetMaterialApp(home: ParkingPage()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key(ConstantsApp.kLoadingParkingSpace)), findsNothing);
      expect(find.byKey(const Key(ConstantsApp.kFailureParkingSpace)), findsNothing);
      expect(find.byKey(const Key(ConstantsApp.kTitleParkingSpace)), findsOne);
      expect(find.byKey(const Key(ConstantsApp.kListParkingSpace)), findsOne);
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('should returns a failure widget', (tester) async {
      //Arrange
      Get.put(ParkingController(ParkingRepositoryFailureFake()));

      //Act
      await tester.pumpWidget(const GetMaterialApp(home: ParkingPage()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key(ConstantsApp.kLoadingParkingSpace)), findsNothing);
      expect(find.byKey(const Key(ConstantsApp.kFailureParkingSpace)), findsOne);
      expect(find.byKey(const Key(ConstantsApp.kTitleParkingSpace)), findsNothing);
      expect(find.byKey(const Key(ConstantsApp.kListParkingSpace)), findsNothing);
      expect(find.byType(Card), findsNothing);
    });
  });

  group('[CREATE RESERVATION]', () {
    testWidgets('should saves a parking space', (tester) async {
      //Arrange
      Get.put(ParkingController(ParkingRepositoryFake()));

      //Act
      await tester.pumpWidget(const GetMaterialApp(home: ParkingPage()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key(ConstantsApp.kLoadingParkingSpace)), findsNothing);
      expect(find.byKey(const Key(ConstantsApp.kFailureParkingSpace)), findsNothing);
      expect(find.byKey(const Key(ConstantsApp.kTitleParkingSpace)), findsOne);
      expect(find.byKey(const Key(ConstantsApp.kListParkingSpace)), findsOne);
      expect(find.byType(Card), findsWidgets);

      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOne);

      final finderDescription = find.byType(TextFormField).first;
      final finderLicensePlate = find.byType(TextFormField).last;
      await tester.enterText(finderDescription, 'Creta Prata');
      await tester.pumpAndSettle();
      await tester.enterText(finderLicensePlate, 'FTP2F45');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key(ConstantsApp.kLButtonReservation)));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    });
  });

  group('[REMOVE RESERVATION]', () {
    testWidgets('should removes removes a reservation', (tester) async {
      //Arrange
      Get.put(ParkingController(ParkingRepositoryFake()));

      //Act
      await tester.pumpWidget(const GetMaterialApp(home: ParkingPage()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key(ConstantsApp.kLoadingParkingSpace)), findsNothing);
      expect(find.byKey(const Key(ConstantsApp.kFailureParkingSpace)), findsNothing);
      expect(find.byKey(const Key(ConstantsApp.kTitleParkingSpace)), findsOne);
      expect(find.byKey(const Key(ConstantsApp.kListParkingSpace)), findsOne);
      expect(find.byType(Card), findsWidgets);

      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOne);

      final finderDescription = find.byType(TextFormField).first;
      final finderLicensePlate = find.byType(TextFormField).last;
      await tester.enterText(finderDescription, 'Creta Preto');
      await tester.pumpAndSettle();
      await tester.enterText(finderLicensePlate, 'FTP2F79');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key(ConstantsApp.kLButtonReservation)));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);

      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle(Durations.long1);
      expect(find.byType(Dialog), findsOne);
      expect(find.byKey(const Key(ConstantsApp.kLButtonFinalizeReservation)), findsOne);

      await tester.tap(find.byKey(const Key(ConstantsApp.kLButtonFinalizeReservation)));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    });
  });
}
