import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/patient.dart';
import '../models/rendez_vous.dart';
import '../models/consultation.dart';

class StorageService {
  static const _secureStorage = FlutterSecureStorage();
  static const _keyName = 'hive_encryption_key';

  static late Box<Patient> patientsBox;
  static late Box<RendezVous> rendezVousBox;
  static late Box<Consultation> consultationsBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(PatientAdapter());
    Hive.registerAdapter(RendezVousAdapter());
    Hive.registerAdapter(ConsultationAdapter());

    final encryptionKey = await _getEncryptionKey();

    patientsBox = await Hive.openBox<Patient>(
      'patients',
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
    rendezVousBox = await Hive.openBox<RendezVous>(
      'rendez_vous',
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
    consultationsBox = await Hive.openBox<Consultation>(
      'consultations',
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }

  static Future<List<int>> _getEncryptionKey() async {
    final storedKey = await _secureStorage.read(key: _keyName);
    if (storedKey != null) {
      return storedKey.split(',').map(int.parse).toList();
    } else {
      final newKey = Hive.generateSecureKey();
      await _secureStorage.write(
        key: _keyName,
        value: newKey.join(','),
      );
      return newKey;
    }
  }
}