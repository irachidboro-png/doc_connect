import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/patient.dart';
import '../models/consultation.dart';
import '../models/rendez_vous.dart';
import '../models/role.dart';

class DossierPatientScreen extends StatelessWidget {
  final Patient patient;
  final Role role;

  const DossierPatientScreen({
    super.key,
    required this.patient,
    required this.role,
  });

  static const navy = Color(0xFF1B2A6B);
  static const teal = Color(0xFF1ABC9C);

  @override
  Widget build(BuildContext context) {
    final consultations = [
      Consultation(
        id: 'c1',
        patientId: patient.id,
        date: DateTime.now().subtract(const Duration(days: 30)),
        diagnostic: 'Hypertension artérielle légère',
        notes: 'Tension 14/9. Conseils hygiéno-diététiques donnés.',
        prescription: 'Amlodipine 5mg — 1 comprimé/jour pendant 30 jours.',
      ),
      Consultation(
        id: 'c2',
        patientId: patient.id,
        date: DateTime.now().subtract(const Duration(days: 90)),
        diagnostic: 'Paludisme simple',
        notes: 'Fièvre à 38,5°C. TDR positif.',
        prescription: 'Arthemether-Lumefantrine — 3 jours.',
      ),
    ];

    final rendezVous = [
      RendezVous(
        id: 'r1',
        patientId: patient.id,
        medecin: 'Dr Sawadogo',
        date: DateTime.now().add(const Duration(days: 5)),
        motif: 'Suivi tension artérielle',
        statut: 'prevu',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(patient.nomComplet),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              color: navy,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: teal,
                    child: Text(
                      patient.prenom[0].toUpperCase(),
                      style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.nomComplet,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Né(e) le ${DateFormat('dd MMMM yyyy', 'fr').format(patient.dateNaissance)}',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        Text(
                          patient.telephone,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitre('Historique des consultations', Icons.history),
                  const SizedBox(height: 8),
                  ...consultations.map((c) => _carteConsultation(c, context)),
                  const SizedBox(height: 24),
                  _sectionTitre('Rendez-vous à venir', Icons.calendar_today),
                  const SizedBox(height: 8),
                  ...rendezVous.map((r) => _carteRdv(r)),
                  if (role == Role.medecin) ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () => _ajouterNote(context),
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text('Ajouter une note', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: teal,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitre(String titre, IconData icone) {
    return Row(
      children: [
        Icon(icone, color: navy, size: 20),
        const SizedBox(width: 8),
        Text(
          titre,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: navy),
        ),
      ],
    );
  }

  Widget _carteConsultation(Consultation c, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd MMM yyyy', 'fr').format(c.date),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: navy.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Terminée', style: TextStyle(color: navy, fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(c.diagnostic, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 4),
            Text(c.notes, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const Divider(height: 16),
            Row(
              children: [
                const Icon(Icons.medical_services, size: 14, color: teal),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    c.prescription,
                    style: const TextStyle(fontSize: 12, color: teal),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _carteRdv(RendezVous r) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: navy,
          child: Icon(Icons.event, color: Colors.white, size: 18),
        ),
        title: Text(r.motif, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(DateFormat('dd MMM yyyy à HH:mm', 'fr').format(r.date)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text('Prévu', style: TextStyle(color: Colors.blue, fontSize: 12)),
        ),
      ),
    );
  }

  void _ajouterNote(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité disponible en version complète.'),
        backgroundColor: navy,
      ),
    );
  }
}