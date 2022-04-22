import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/camera/camera_dialog.dart';

void main() {
  const bodyCheckBox = Key('bodyDialog_checkBoxListTile');
  const foodCheckBox = Key('foodDialog_checkBoxListTile');

  group('CameraDialog', () {
    testWidgets('BodyDialog render all widget correct', (tester) async {
      await tester.pumpWidget(MaterialApp(home: BodyDialog()));
      expect(find.byType(BodyDialog), findsOneWidget);
      expect(find.text('กล้องวัดสัดส่วนร่างกาย'), findsOneWidget);
      expect(
          find.text(
              'กล้องจะทำการถ่ายรูป 2 ครั้ง เมื่อกดถ่ายรูปจะทำการนับเวลาถอยหลัง 5 วิ ในการถ่ายแต่ละรูป'),
          findsOneWidget);
      expect(
          find.text(
              'ผู้ใช้จะต้องยืนหันหน้าเข้าหากล้องในรูปที่หนึ่ง และยืนหันข้างในที่รูปสอง'),
          findsOneWidget);
      expect(
          find.text(
              'ในการถ่ายรูปโดยควรวางกล้องให้สามารถถ่ายเห็นทั้งตัว และยืนให้พอดีกับกรอบสีชมพูที่แสดงบนหน้าจอ'),
          findsOneWidget);
      expect(find.text('ไม่ต้องแสดงอีก'), findsOneWidget);
    });

    testWidgets('BodyDialog check Checkbox when check CheckboxListTile',
        (tester) async {
      await tester.pumpWidget(MaterialApp(home: BodyDialog()));
      await tester.tap(find.byKey(bodyCheckBox));
      await tester.pump();
      final checkBox = tester.widget<CheckboxListTile>(find.byKey(bodyCheckBox));
      expect(checkBox.value, true);
    });

    testWidgets('FoodDialog render all widget correct', (tester) async {
      await tester.pumpWidget(MaterialApp(home: FoodDialog()));
      expect(find.byType(FoodDialog), findsOneWidget);
      expect(find.text('กล้องประมาณแคลอรีอาหาร'), findsOneWidget);
      expect(
          find.text(
              'ผู้ใช้จะต้องขยับกล้องขึ้นด้านบนของอาหาร และขยับลง 45 องศา ถ่ายด้านข้างของอาหาร ตามรูปที่แสดงด้านล่าง'),
          findsOneWidget);
      expect(
          find.text(
              'จนกว่าจะปรากฏจุดสีเขียวขึ้นบนหน้าจอเพียงพอ กล้องจะแนะนำผู้ใช้ขยับกล้องให้ขนานกับอาหาร โดยขยับให้ตัวเลขเข้าใกล้ 0 หรือ 180 จนกว่ากล้องจะขึ้นพร้อมสำหรับถ่ายรูปตามรูปที่แสดงด้านล่าง'),
          findsOneWidget);
      expect(find.byType(Image), findsNWidgets(4));
    });

    testWidgets('FoodDialog check Checkbox when check CheckboxListTile',
        (tester) async {
      await tester.pumpWidget(MaterialApp(home: FoodDialog()));
      await tester.tap(find.byKey(foodCheckBox));
      await tester.pump();
      final checkBox = tester.widget<CheckboxListTile>(find.byKey(foodCheckBox));
      expect(checkBox.value, true);
    });
  });
}
