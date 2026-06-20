import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/rendez_vous.dart';
import '../models/role.dart';

class DetailsRdvScreen extends StatelessWidget {
  final RendezVous rdv;
  final Role role;

  const DetailsRdvScreen({
    super.key,
    required this.rdv,
    required this.role,
  });

  static const navy = Color(0xFF1B2A6B);
  static const teal = Color(0xFF1ABC9C);

  Color _couleurStatut(String statut) {
    switch (statut) {
      case 'prevu':
        return navy;
      case 'termine':
        return Colors.green;
      case 'annule':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _libelleStatut(String statut) {
    switch (statut) {
      case 'prevu':
        return 'Prévu';
      case 'termine':
        return 'Terminé';
      case 'annule':
        return 'Annulé';
      default:
        return statut;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Détails du rendez-vous'),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              color: navy,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: teal,
                    child: const Icon(Icons.event, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: _couleurStatut(rdv.statut),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _libelleStatut(rdv.statut),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informations',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: navy),
                  ),
                  const SizedBox(height: 16),
                  _ligneInfo(Icons.medical_information, 'Motif', rdv.motif),
                  _ligneInfo(
                    Icons.calendar_today,
                    'Date et heure',
                    DateFormat('dd MMMM yyyy à HH:mm', 'fr').format(rdv.date),
                  ),
                  _ligneInfo(Icons.local_hospital, 'Médecin', rdv.medecin),
                  _ligneInfo(Icons.flag, 'Statut', _libelleStatut(rdv.statut)),
                  const SizedBox(height: 32),
                  if (role == Role.medecin) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Fonctionnalité disponible en version complète.'),
                              backgroundColor: navy,
                            ),
                          );
                        },
                        icon: const Icon(Icons.check_circle, color: Colors.white),
                        label: const Text('Marquer comme terminé', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fonctionnalité disponible en version complète.'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      },
                      icon: const Icon(Icons.cancel, color: Colors.redAccent),
                      label: const Text('Annuler le rendez-vous', style: TextStyle(color: Colors.redAccent)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ligneInfo(IconData icone, String label, String valeur) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icone, color: navy, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(valeur, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}