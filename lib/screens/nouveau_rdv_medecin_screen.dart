import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/patient.dart';
import '../models/rendez_vous.dart';

class NouveauRdvMedecinScreen extends StatefulWidget {
  final Map<String, Patient> patients;

  const NouveauRdvMedecinScreen({super.key, required this.patients});

  @override
  State<NouveauRdvMedecinScreen> createState() => _NouveauRdvMedecinScreenState();
}

class _NouveauRdvMedecinScreenState extends State<NouveauRdvMedecinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _motifController = TextEditingController();
  DateTime? _dateSelectionnee;
  String? _patientIdSelectionne;
  bool _enCours = false;

  static const navy = Color(0xFF1B2A6B);
  static const teal = Color(0xFF1ABC9C);

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
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: navy)),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      final heure = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 8, minute: 0),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: navy)),
          child: child!,
        ),
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

  void _confirmer() {
    if (!_formKey.currentState!.validate()) return;

    if (_patientIdSelectionne == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez choisir un patient.'), backgroundColor: Colors.orange),
      );
      return;
    }
    if (_dateSelectionnee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez choisir une date et une heure.'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _enCours = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      final nouveauRdv = RendezVous(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        patientId: _patientIdSelectionne!,
        medecin: 'Dr Sawadogo',
        date: _dateSelectionnee!,
        motif: _motifController.text.trim(),
        statut: 'prevu',
      );
      Navigator.of(context).pop(nouveauRdv);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Nouveau rendez-vous'),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Patient', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Sélectionner un patient'),
                    value: _patientIdSelectionne,
                    items: widget.patients.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value.nomComplet),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _patientIdSelectionne = value),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Motif de la consultation', style: TextStyle(fontWeight: FontWeight.w600)),
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
              const Text('Date et heure', style: TextStyle(fontWeight: FontWeight.w600)),
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
                        style: TextStyle(color: _dateSelectionnee == null ? Colors.grey : Colors.black),
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
                  onPressed: _enCours ? null : _confirmer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: teal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _enCours
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Créer le rendez-vous', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}