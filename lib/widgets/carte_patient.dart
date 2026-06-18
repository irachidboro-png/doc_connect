import 'package:flutter/material.dart';
import '../models/patient.dart';

class CartePatient extends StatelessWidget {
  final Patient patient;
  final VoidCallback onTap;

  const CartePatient({
    super.key,
    required this.patient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1B2A6B),
          child: Text(
            patient.prenom[0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          patient.nomComplet,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(patient.telephone),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF1ABC9C)),
        onTap: onTap,
      ),
    );
  }
}