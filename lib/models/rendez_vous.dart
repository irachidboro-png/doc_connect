import 'package:hive/hive.dart';

part 'rendez_vous.g.dart';

@HiveType(typeId: 1)
class RendezVous extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String patientId;

  @HiveField(2)
  String medecin;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String motif;

  @HiveField(5)
  String statut;

  RendezVous({
    required this.id,
    required this.patientId,
    required this.medecin,
    required this.date,
    required this.motif,
    this.statut = 'prevu',
  });
}