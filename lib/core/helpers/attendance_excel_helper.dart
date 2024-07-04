import 'dart:io';
import 'package:excel/excel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart'; // تأكد من استيراد هذه المكتبة

Future<List<Map<String, dynamic>>> fetchAttendanceData() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('attendance').get();

  List<Map<String, dynamic>> attendanceData = [];

  for (var doc in querySnapshot.docs) {
    attendanceData.add(doc.data() as Map<String, dynamic>);
  }

  return attendanceData;
}

Future<String> generateAttendanceExcel() async {
  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Attendance'];

  // إضافة العناوين
  sheetObject.appendRow([
    const TextCellValue('كود الفرع'),
    const TextCellValue('اسم الفرع'),
    const TextCellValue('تاريخ الحضور'),
    const TextCellValue('تاريخ الانصراف'),
    const TextCellValue('كود المستخدم'),
    const TextCellValue('اسم المستخدم'),
    const TextCellValue('العنوان'),
    const TextCellValue('Mobile IP')
  ]);

  // استرجاع بيانات جلسات الحضور من Firestore
  List<Map<String, dynamic>> attendanceData = await fetchAttendanceData();

  // إضافة البيانات إلى الملف
  for (var data in attendanceData) {
    String locationString =
        '${data['location'].latitude}, ${data['location'].longitude}';
    sheetObject.appendRow([
      TextCellValue(data['branchId'].toString()),
      TextCellValue(data['branchName']),
      TextCellValue((data['checkInTime'] as Timestamp).toDate().toString()),
      TextCellValue((data['checkOutTime'] as Timestamp).toDate().toString()),
      TextCellValue(data['employeeId'].toString()),
      TextCellValue(data['employeeName']),
      TextCellValue(locationString),
      TextCellValue(data['mobileIp']),
    ]);
  }

  // حفظ الملف في التخزين المؤقت
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  String filePath = '$tempPath/attendance.xlsx';
  File(filePath)
    ..createSync(recursive: true)
    ..writeAsBytesSync(excel.save()!);

  return filePath;
}
