import 'package:flutter/material.dart';
import '../models/role.dart';
import 'patients_screen.dart';
import 'rendez_vous_screen.dart';
import 'profil_screen.dart';

class HomeShell extends StatefulWidget {
  final Role role;

  const HomeShell({super.key, required this.role});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _indexActuel = 0;
  static const navy = Color(0xFF1B2A6B);

  @override
  Widget build(BuildContext context) {
    final ecrans = [
      PatientsScreen(role: widget.role),
      RendezVousScreen(role: widget.role),
      ProfilScreen(role: widget.role),
    ];

    final premierOnglet = widget.role == Role.medecin ? 'Patients' : 'Mon dossier';

    return Scaffold(
      body: ecrans[_indexActuel],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexActuel,
        onDestinationSelected: (index) => setState(() => _indexActuel = index),
        indicatorColor: navy.withOpacity(0.15),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(Icons.people),
            label: premierOnglet,
          ),
          const NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Rendez-vous',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}