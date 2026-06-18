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
  bool _motDePasseVisible = false;
  Role? _roleSelectionne;
  final _identifiantController = TextEditingController();
  final _motDePasseController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _erreurConnexion;

  static const _comptes = {
    Role.medecin: {'identifiant': 'dr.sawadogo', 'password': 'medecin123'},
    Role.patient: {'identifiant': 'mariam.compaore', 'password': 'patient123'},
  };

  @override
  void dispose() {
    _identifiantController.dispose();
    _motDePasseController.dispose();
    super.dispose();
  }

  void _choisirRole(Role role) {
    final compte = _comptes[role]!;
    setState(() {
      _roleSelectionne = role;
      _erreurConnexion = null;
      _identifiantController.text = compte['identifiant']!;
      _motDePasseController.text = compte['password']!;
    });
  }

  Future<void> _seConnecter() async {
    if (!_formKey.currentState!.validate()) return;

    final compte = _comptes[_roleSelectionne!];
    final identifiant = _identifiantController.text.trim().toLowerCase();
    final motDePasse = _motDePasseController.text;

    if (identifiant != compte!['identifiant'] || motDePasse != compte['password']) {
      setState(() => _erreurConnexion = 'Identifiant ou mot de passe incorrect.');
      return;
    }

    setState(() {
      _erreurConnexion = null;
      _enCours = true;
    });

    final consentement = await ConsentementDialog.afficherSiNecessaire(context);
    if (!consentement || !mounted) {
      setState(() => _enCours = false);
      return;
    }

    final succes = await AuthService.authentifier();
    if (!mounted) return;
    setState(() => _enCours = false);

    if (succes) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeShell(role: _roleSelectionne!)),
      );
    } else {
      setState(() => _erreurConnexion = 'Authentification échouée. Réessayez.');
    }
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF1B2A6B);
    const teal = Color(0xFF1ABC9C);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
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
                child: const Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: teal,
                      child: Icon(Icons.medical_services, size: 40, color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Doc Connect',
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Consultation médicale connectée',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choisissez votre profil',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _boutonProfil(
                            label: 'Médecin',
                            icone: Icons.local_hospital,
                            role: Role.medecin,
                            couleur: navy,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _boutonProfil(
                            label: 'Patient',
                            icone: Icons.person,
                            role: Role.patient,
                            couleur: teal,
                          ),
                        ),
                      ],
                    ),
                    if (_roleSelectionne != null) ...[
                      const SizedBox(height: 32),
                      Text(
                        'Connexion — ${_roleSelectionne == Role.medecin ? "Médecin" : "Patient"}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: navy),
                      ),
                      const SizedBox(height: 16),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _identifiantController,
                              decoration: InputDecoration(
                                labelText: 'Identifiant',
                                prefixIcon: const Icon(Icons.person, color: navy),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: navy, width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Veuillez entrer votre identifiant.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _motDePasseController,
                              obscureText: !_motDePasseVisible,
                              decoration: InputDecoration(
                                labelText: 'Mot de passe',
                                prefixIcon: const Icon(Icons.lock, color: navy),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _motDePasseVisible ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () => setState(() => _motDePasseVisible = !_motDePasseVisible),
                                ),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: navy, width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre mot de passe.';
                                }
                                return null;
                              },
                            ),
                            if (_erreurConnexion != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                  _erreurConnexion!,
                                  style: const TextStyle(color: Colors.red, fontSize: 13),
                                ),
                              ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton.icon(
                                onPressed: _enCours ? null : _seConnecter,
                                icon: _enCours
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            color: Colors.white, strokeWidth: 2),
                                      )
                                    : const Icon(Icons.login, color: Colors.white),
                                label: Text(
                                  _enCours ? 'Connexion...' : 'Se connecter',
                                  style: const TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _roleSelectionne == Role.medecin ? navy : teal,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _boutonProfil({
    required String label,
    required IconData icone,
    required Role role,
    required Color couleur,
  }) {
    final estSelectionne = _roleSelectionne == role;
    return GestureDetector(
      onTap: () => _choisirRole(role),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: estSelectionne ? couleur : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: couleur, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, color: estSelectionne ? Colors.white : couleur, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: estSelectionne ? Colors.white : couleur,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}