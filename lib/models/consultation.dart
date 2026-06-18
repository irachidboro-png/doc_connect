import 'package:hive/hive.dart';

part 'consultation.g.dart';

@HiveType(typeId: 2)
class Consultation extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String patientId;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String diagnostic;

  @HiveField(4)
  String notes;

  @HiveField(5)
  String prescription;

  Consultation({
    required this.id,
    required this.patientId,
    required this.date,
    required this.diagnostic,
    required this.notes,
    required this.prescription,
  });
}