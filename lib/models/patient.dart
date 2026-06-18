import 'package:hive/hive.dart';

part 'patient.g.dart';

@HiveType(typeId: 0)
class Patient extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String nom;

  @HiveField(2)
  String prenom;

  @HiveField(3)
  DateTime dateNaissance;

  @HiveField(4)
  String telephone;

  Patient({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.telephone,
  });

  String get nomComplet => '$prenom $nom';
}