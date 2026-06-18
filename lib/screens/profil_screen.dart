import 'package:flutter/material.dart';
import '../models/role.dart';
import 'login_screen.dart';

class ProfilScreen extends StatelessWidget {
  final Role role;
  const ProfilScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF1B2A6B);
    const teal = Color(0xFF1ABC9C);

    final estMedecin = role == Role.medecin;

    final nom = estMedecin ? 'Dr Sawadogo Idrissa' : 'Compaoré Mariam';
    final identifiant = estMedecin ? 'dr.sawadogo' : 'mariam.compaore';
    final info1Label = estMedecin ? 'Spécialité' : 'Date de naissance';
    final info1Value = estMedecin ? 'Médecine Générale' : '22 juillet 1985';
    final info2Label = estMedecin ? 'N° Ordre' : 'Groupe sanguin';
    final info2Value = estMedecin ? 'MED-BF-2024-0412' : 'O+';
    final info3Label = estMedecin ? 'Structure' : 'Téléphone';
    final info3Value = estMedecin ? 'CHU Yalgado Ouédraogo' : '+226 76 44 55 66';
    final info4Label = estMedecin ? 'Téléphone' : 'Adresse';
    final info4Value = estMedecin ? '+226 70 11 22 33' : 'Secteur 30, Ouagadougou';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Mon profil'),
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
                    radius: 45,
                    backgroundColor: teal,
                    child: Text(
                      nom.split(' ').first[0] + nom.split(' ').last[0],
                      style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    nom,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: teal,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      estMedecin ? 'Médecin' : 'Patient',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@$identifiant',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
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
                  const SizedBox(height: 12),
                  _ligneInfo(icone: Icons.badge, label: info1Label, valeur: info1Value),
                  _ligneInfo(icone: Icons.numbers, label: info2Label, valeur: info2Value),
                  _ligneInfo(icone: Icons.business, label: info3Label, valeur: info3Value),
                  _ligneInfo(icone: Icons.phone, label: info4Label, valeur: info4Value),
                  const SizedBox(height: 32),
                  const Text(
                    'Sécurité',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: navy),
                  ),
                  const SizedBox(height: 12),
                  _ligneInfo(icone: Icons.lock, label: 'Authentification', valeur: 'Biométrique activée'),
                  _ligneInfo(icone: Icons.storage, label: 'Données', valeur: 'Chiffrées AES-256'),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text('Déconnexion', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
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

  Widget _ligneInfo({required IconData icone, required String label, required String valeur}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icone, color: const Color(0xFF1B2A6B), size: 22),
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