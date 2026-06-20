import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/role.dart';
import '../models/rendez_vous.dart';
import '../models/patient.dart';
import 'details_rdv_screen.dart';
import 'nouveau_rdv_medecin_screen.dart';

class RendezVousScreen extends StatefulWidget {
  final Role role;
  const RendezVousScreen({super.key, required this.role});

  @override
  State<RendezVousScreen> createState() => _RendezVousScreenState();
}

class _RendezVousScreenState extends State<RendezVousScreen> {
  final _formKey = GlobalKey<FormState>();
  final _motifController = TextEditingController();
  DateTime? _dateSelectionnee;
  bool _enCours = false;

  static const navy = Color(0xFF1B2A6B);
  static const teal = Color(0xFF1ABC9C);

  final Map<String, Patient> _patientsParId = {
    '1': Patient(
      id: '1',
      nom: 'Ouédraogo',
      prenom: 'Aminata',
      dateNaissance: DateTime(1990, 3, 15),
      telephone: '+226 70 11 22 33',
    ),
    '2': Patient(
      id: '2',
      nom: 'Compaoré',
      prenom: 'Mariam',
      dateNaissance: DateTime(1985, 7, 22),
      telephone: '+226 76 44 55 66',
    ),
    '3': Patient(
      id: '3',
      nom: 'Traoré',
      prenom: 'Ibrahim',
      dateNaissance: DateTime(1978, 11, 8),
      telephone: '+226 65 77 88 99',
    ),
  };

  final List<RendezVous> _rendezVous = [
    RendezVous(
      id: '1',
      patientId: '1',
      medecin: 'Dr Sawadogo',
      date: DateTime.now().add(const Duration(days: 2)),
      motif: 'Consultation générale',
      statut: 'prevu',
    ),
    RendezVous(
      id: '2',
      patientId: '2',
      medecin: 'Dr Sawadogo',
      date: DateTime.now().add(const Duration(days: 5)),
      motif: 'Suivi tension artérielle',
      statut: 'prevu',
    ),
    RendezVous(
      id: '3',
      patientId: '3',
      medecin: 'Dr Sawadogo',
      date: DateTime.now().subtract(const Duration(days: 1)),
      motif: 'Renouvellement ordonnance',
      statut: 'termine',
    ),
  ];

  @override
  void dispose() {
    _motifController.dispose();
    super.dispose();
  }

  Future<void> _choisirDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: navy),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      final heure = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 8, minute: 0),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(primary: navy),
            ),
            child: child!,
          );
        },
      );
      if (heure != null && mounted) {
        setState(() {
          _dateSelectionnee = DateTime(
            picked.year,
            picked.month,
            picked.day,
            heure.hour,
            heure.minute,
          );
        });
      }
    }
  }

  void _soumettreFormulaire() {
    if (_formKey.currentState!.validate()) {
      if (_dateSelectionnee == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez choisir une date et une heure.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      setState(() => _enCours = true);
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() {
          _rendezVous.add(RendezVous(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            patientId: '2',
            medecin: 'Dr Sawadogo',
            date: _dateSelectionnee!,
            motif: _motifController.text.trim(),
            statut: 'prevu',
          ));
          _enCours = false;
          _motifController.clear();
          _dateSelectionnee = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rendez-vous enregistré !'),
            backgroundColor: Colors.green,
          ),
        );
      });
    }
  }

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

  Widget _carteRdv(RendezVous rdv) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _couleurStatut(rdv.statut),
          child: const Icon(Icons.calendar_today, color: Colors.white, size: 18),
        ),
        title: Text(rdv.motif, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(DateFormat('dd MMM yyyy à HH:mm', 'fr').format(rdv.date)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _couleurStatut(rdv.statut).withAlpha(30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            rdv.statut,
            style: TextStyle(color: _couleurStatut(rdv.statut), fontSize: 12),
          ),
        ),
        onTap: () {
          final patientConcerne =
              widget.role == Role.medecin ? _patientsParId[rdv.patientId] : null;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DetailsRdvScreen(
                rdv: rdv,
                role: widget.role,
                patient: patientConcerne,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _vueListeMedecin() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 12),
      itemCount: _rendezVous.length,
      itemBuilder: (context, index) => _carteRdv(_rendezVous[index]),
    );
  }

  Widget _vuePatient() {
    final mesRdv = _rendezVous.where((r) => r.patientId == '2').toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Text(
              'Mes rendez-vous',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: navy),
            ),
          ),
          if (mesRdv.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                'Aucun rendez-vous pour le moment.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ...mesRdv.map((rdv) => _carteRdv(rdv)),
          const Divider(height: 32, thickness: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nouveau rendez-vous',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: navy),
                  ),
                  const SizedBox(height: 24),
                  const Text('Motif de la consultation',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _motifController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Ex: Consultation générale, suivi tension...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: navy, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Le motif ne peut pas être vide.';
                      }
                      if (value.trim().length < 5) {
                        return 'Le motif doit contenir au moins 5 caractères.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text('Date et heure souhaitées',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _choisirDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: navy),
                          const SizedBox(width: 12),
                          Text(
                            _dateSelectionnee == null
                                ? 'Choisir une date et une heure'
                                : DateFormat('dd MMMM yyyy à HH:mm', 'fr').format(_dateSelectionnee!),
                            style: TextStyle(
                              color: _dateSelectionnee == null ? Colors.grey : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _enCours ? null : _soumettreFormulaire,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: teal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _enCours
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Confirmer le rendez-vous',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Rendez-vous'),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),
      body: widget.role == Role.medecin
          ? _vueListeMedecin()
          : _vuePatient(),
      floatingActionButton: widget.role == Role.medecin
          ? FloatingActionButton(
              backgroundColor: teal,
              onPressed: () async {
                final nouveauRdv = await Navigator.of(context).push<RendezVous>(
                  MaterialPageRoute(
                    builder: (_) => NouveauRdvMedecinScreen(patients: _patientsParId),
                  ),
                );
                if (nouveauRdv != null && mounted) {
                  setState(() => _rendezVous.add(nouveauRdv));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Rendez-vous créé !'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}