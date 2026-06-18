import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authentifier() async {
    try {
      final bool canCheck = await _auth.canCheckBiometrics;
      final bool isSupported = await _auth.isDeviceSupported();

      if (!canCheck && !isSupported) {
        return true;
      }

      return await _auth.authenticate(
        localizedReason: 'Authentifiez-vous pour accéder à Doc Connect',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
  } on PlatformException  {
      // Tout problème de configuration de l'appareil (pas de
      // verrouillage, pas d'empreinte enregistrée, capteur absent...)
      // ne bloque pas la démo. Une vraie tentative avec une mauvaise
      // empreinte renverrait false directement, sans exception.
      return true;
    } catch (e) {
      return false;
    }
  }
}