import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/patient.dart';

class FhirService {
  static const String _baseUrl = 'https://hapi.fhir.org/baseR4';

  static Future<List<Patient>> getPatients() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/Patient?_count=10'),
        headers: {'Accept': 'application/fhir+json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final entries = data['entry'] as List<dynamic>? ?? [];

        return entries.map((entry) {
          final resource = entry['resource'];
          final name = resource['name']?[0];
          final family = name?['family'] ?? 'Inconnu';
          final given = name?['given']?[0] ?? 'Prénom';
          final birthDate = resource['birthDate'] ?? '1990-01-01';
          final phone = resource['telecom']
              ?.firstWhere(
                (t) => t['system'] == 'phone',
                orElse: () => {'value': 'N/A'},
              )['value'] ?? 'N/A';

          return Patient(
            id: resource['id'].toString(),
            nom: family,
            prenom: given,
            dateNaissance: DateTime.parse(birthDate),
            telephone: phone,
          );
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Map<String, dynamic> patientToFhir(Patient patient) {
    return {
      'resourceType': 'Patient',
      'id': patient.id,
      'name': [
        {
          'family': patient.nom,
          'given': [patient.prenom],
        }
      ],
      'birthDate': patient.dateNaissance.toIso8601String().split('T')[0],
      'telecom': [
        {
          'system': 'phone',
          'value': patient.telephone,
        }
      ],
    };
  }
}