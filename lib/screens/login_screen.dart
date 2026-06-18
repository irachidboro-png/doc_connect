import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/role.dart';
import '../widgets/consentement_dialog.dart';
import 'home_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _enCours = false;

  Future<void> _seConnecter(Role role) async {
    final consentement = await ConsentementDialog.afficherSiNecessaire(context);
    if (!consentement || !mounted) return;

    setState(() => _enCours = true);
    final succes = await AuthService.authentifier();
    setState(() => _enCours = false);

    if (succes && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeShell(role: role)),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentification échouée. Réessayez.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF1B2A6B);
    const teal = Color(0xFF1ABC9C);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              decoration: const BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: teal,
                    child: Icon(Icons.medical_services, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Doc Connect',
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Consultation médicale connectée',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            const Text('Choisissez votre profil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  _boutonProfil(
                    label: 'Médecin',
                    icone: Icons.local_hospital,
                    couleur: navy,
                    onPressed: _enCours ? null : () => _seConnecter(Role.medecin),
                  ),
                  const SizedBox(height: 16),
                  _boutonProfil(
                    label: 'Patient',
                    icone: Icons.person,
                    couleur: teal,
                    onPressed: _enCours ? null : () => _seConnecter(Role.patient),
                  ),
                ],
              ),
            ),
            if (_enCours)
              const Padding(
                padding: EdgeInsets.only(top: 32),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _boutonProfil({
    required String label,
    required IconData icone,
    required Color couleur,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icone, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: couleur,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}