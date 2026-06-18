import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../models/role.dart';
import '../services/fhir_service.dart';
import '../widgets/carte_patient.dart';

class PatientsScreen extends StatefulWidget {
  final Role role;
  const PatientsScreen({super.key, required this.role});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  List<Patient> _patients = [];
  bool _chargement = true;
  String? _erreur;

  final List<Patient> _patientsFictifs = [
    Patient(
      id: 'local-1',
      nom: 'Ouédraogo',
      prenom: 'Aminata',
      dateNaissance: DateTime(1990, 3, 15),
      telephone: '+226 70 11 22 33',
    ),
    Patient(
      id: 'local-2',
      nom: 'Compaoré',
      prenom: 'Mariam',
      dateNaissance: DateTime(1985, 7, 22),
      telephone: '+226 76 44 55 66',
    ),
    Patient(
      id: 'local-3',
      nom: 'Traoré',
      prenom: 'Ibrahim',
      dateNaissance: DateTime(1978, 11, 8),
      telephone: '+226 65 77 88 99',
    ),
    Patient(
      id: 'local-4',
      nom: 'Kaboré',
      prenom: 'Fatimata',
      dateNaissance: DateTime(2001, 1, 30),
      telephone: '+226 71 23 45 67',
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.role == Role.medecin) {
      _chargerPatientsFHIR();
    } else {
      setState(() {
        _patients = _patientsFictifs.where((p) => p.id == 'local-2').toList();
        _chargement = false;
      });
    }
  }

  Future<void> _chargerPatientsFHIR() async {
    try {
      setState(() {
        _chargement = true;
        _erreur = null;
      });
      final patients = await FhirService.getPatients();
      if (!mounted) return;
      setState(() {
        _patients = patients.isNotEmpty ? patients : _patientsFictifs;
        _chargement = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _patients = _patientsFictifs;
        _chargement = false;
        _erreur = 'Données locales (hors ligne)';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final titre = widget.role == Role.medecin ? 'Mes patients' : 'Mon dossier';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(titre),
        backgroundColor: const Color(0xFF1B2A6B),
        foregroundColor: Colors.white,
        actions: widget.role == Role.medecin
            ? [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _chargerPatientsFHIR,
                  tooltip: 'Actualiser depuis FHIR',
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          if (_erreur != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              color: Colors.orange.shade100,
              child: Row(
                children: [
                  const Icon(Icons.wifi_off, size: 16, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(_erreur!, style: const TextStyle(fontSize: 12, color: Colors.orange)),
                ],
              ),
            ),
          Expanded(
            child: _chargement
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 12),
                    itemCount: _patients.length,
                    itemBuilder: (context, index) {
                      return CartePatient(
                        patient: _patients[index],
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Dossier de ${_patients[index].nomComplet}'),
                              backgroundColor: const Color(0xFF1B2A6B),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: widget.role == Role.medecin
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF1ABC9C),
              onPressed: () {},
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}