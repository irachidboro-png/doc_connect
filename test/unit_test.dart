import 'package:flutter_test/flutter_test.dart';
import 'package:doc_connect/models/role.dart';
import 'package:doc_connect/models/rendez_vous.dart';
import 'package:doc_connect/services/fhir_service.dart';
import 'package:doc_connect/models/patient.dart';

void main() {
  // ─────────────────────────────────────────────
  // TEST 1 — RBAC : règles d'accès par rôle
  // ─────────────────────────────────────────────
  group('RBAC - Règles d\'accès', () {
    test('Un médecin peut ajouter une note de consultation', () {
      expect(peutAjouterNoteConsultation(Role.medecin), isTrue);
    });

    test('Un patient ne peut pas ajouter une note de consultation', () {
      expect(peutAjouterNoteConsultation(Role.patient), isFalse);
    });

    test('Un médecin peut voir la liste des patients', () {
      expect(peutVoirListePatients(Role.medecin), isTrue);
    });

    test('Un patient ne peut pas voir la liste des patients', () {
      expect(peutVoirListePatients(Role.patient), isFalse);
    });
  });

  // ─────────────────────────────────────────────
  // TEST 2 — Validation du formulaire RDV
  // ─────────────────────────────────────────────
  group('Validation formulaire RDV', () {
    test('Une date future est valide', () {
      final dateFuture = DateTime.now().add(const Duration(days: 5));
      expect(dateFuture.isAfter(DateTime.now()), isTrue);
    });

    test('Une date passée est invalide', () {
      final datePassee = DateTime.now().subtract(const Duration(days: 1));
      expect(datePassee.isAfter(DateTime.now()), isFalse);
    });

    test('Un motif vide est invalide', () {
      const motif = '';
      expect(motif.trim().isEmpty, isTrue);
    });

    test('Un motif trop court est invalide', () {
      const motif = 'ab';
      expect(motif.trim().length < 5, isTrue);
    });

    test('Un motif valide est accepté', () {
      const motif = 'Consultation générale';
      expect(motif.trim().length >= 5, isTrue);
    });
  });

  // ─────────────────────────────────────────────
  // TEST 3 — Mapping FHIR
  // ─────────────────────────────────────────────
  group('Mapping FHIR', () {
    test('patientToFhir produit le bon resourceType', () {
      final patient = Patient(
        id: 'test-1',
        nom: 'Ouédraogo',
        prenom: 'Aminata',
        dateNaissance: DateTime(1990, 3, 15),
        telephone: '+226 70 11 22 33',
      );
      final fhir = FhirService.patientToFhir(patient);
      expect(fhir['resourceType'], equals('Patient'));
    });

    test('patientToFhir contient le bon nom de famille', () {
      final patient = Patient(
        id: 'test-2',
        nom: 'Compaoré',
        prenom: 'Mariam',
        dateNaissance: DateTime(1985, 7, 22),
        telephone: '+226 76 44 55 66',
      );
      final fhir = FhirService.patientToFhir(patient);
      expect(fhir['name'][0]['family'], equals('Compaoré'));
    });

    test('patientToFhir contient le bon prénom', () {
      final patient = Patient(
        id: 'test-3',
        nom: 'Traoré',
        prenom: 'Ibrahim',
        dateNaissance: DateTime(1978, 11, 8),
        telephone: '+226 65 77 88 99',
      );
      final fhir = FhirService.patientToFhir(patient);
      expect(fhir['name'][0]['given'][0], equals('Ibrahim'));
    });

    test('patientToFhir contient la bonne date de naissance', () {
      final patient = Patient(
        id: 'test-4',
        nom: 'Kaboré',
        prenom: 'Fatimata',
        dateNaissance: DateTime(2001, 1, 30),
        telephone: '+226 71 23 45 67',
      );
      final fhir = FhirService.patientToFhir(patient);
      expect(fhir['birthDate'], equals('2001-01-30'));
    });

    test('RendezVous a le statut par défaut prevu', () {
      final rdv = RendezVous(
        id: 'rdv-1',
        patientId: 'p-1',
        medecin: 'Dr Sawadogo',
        date: DateTime(2026, 7, 1),
        motif: 'Consultation',
      );
      expect(rdv.statut, equals('prevu'));
    });
  });
}